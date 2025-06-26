-- LSP configuration
-- Language servers, completion, and diagnostics

return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      inlay_hints = {
        enabled = true,
      },
      codelens = {
        enabled = true,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        -- Explicitly disable ts_ls to prevent conflicts with vtsls
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("tsconfig.json", "package.json", ".git")(fname)
          end,
          single_file_support = false, -- Prevent issues with single files
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = false, -- Can cause performance issues
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
            },
          },
        },
        eslint = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- Only start ESLint if there's an eslint config file
            local root = util.root_pattern(
              ".eslintrc.js",
              ".eslintrc.json", 
              ".eslintrc.yml",
              ".eslintrc.yaml",
              ".eslintrc",
              "eslint.config.js",
              "eslint.config.mjs", 
              "eslint.config.cjs"
            )(fname)
            
            -- Also check for package.json with eslint config
            if not root then
              local package_root = util.root_pattern("package.json")(fname)
              if package_root then
                local package_json = package_root .. "/package.json"
                local stat = vim.uv.fs_stat(package_json)
                if stat and stat.type == "file" then
                  local fd = vim.uv.fs_open(package_json, "r", 438)
                  if fd then
                    local data = vim.uv.fs_read(fd, stat.size, 0)
                    vim.uv.fs_close(fd)
                    if data and data:match('"eslintConfig"') then
                      root = package_root
                    end
                  end
                end
              end
            end
            
            return root
          end,
          settings = {
            workingDirectories = { mode = "auto" },
            experimental = {
              useFlatConfig = false,
            },
            validate = "on",
            packageManager = "npm",
            useESLintClass = false,
            codeActionOnSave = {
              enable = false,
              mode = "all"
            },
            format = false,
            quiet = false,
            onIgnoredFiles = "off",
            rulesCustomizations = {},
            run = "onType",
            problems = {
              shortenToSingleLine = false,
            },
            -- ESLint server configuration
            nodePath = "",
            -- Disable if no eslint found
            enable = true,
          },
        },
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
      setup = {
        -- Prevent ts_ls from loading to avoid conflicts with vtsls
        ts_ls = function()
          return true -- Skip setup completely
        end,
      },
    },
    config = function(_, opts)
      local Util = require("utils.lsp")
      
      Util.setup()
      Util.on_attach(function(client, buffer)
        -- Defer keybinding setup to avoid circular dependency
        vim.schedule(function()
          local ok, keymaps = pcall(require, "config.keymaps")
          if ok and keymaps.setup_lsp_keybindings then
            keymaps.setup_lsp_keybindings(client, buffer)
          end
        end)
      end)

      local servers = opts.servers
      -- Try blink.cmp first, fallback to cmp_nvim_lsp if available
      local has_blink, blink = pcall(require, "blink.cmp")
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      
      local completion_capabilities = {}
      if has_blink then
        -- Use blink.cmp capabilities if available
        local ok, caps = pcall(blink.get_lsp_capabilities)
        if ok then
          completion_capabilities = caps
        end
      elseif has_cmp then
        -- Fallback to nvim-cmp capabilities
        completion_capabilities = cmp_nvim_lsp.default_capabilities()
      end
      
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        completion_capabilities,
        opts.capabilities or {}
      )

      local function setup(server)
        -- Explicitly prevent ts_ls from being set up to avoid conflicts with vtsls
        if server == "ts_ls" then
          return
        end
        
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        -- Get available servers from mason-lspconfig
        all_mslp_servers = mlsp.get_available_servers()
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- Skip disabled servers
          if server_opts.enabled == false then
            goto continue
          end
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
        ::continue::
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end

      if Util.get_config("diagnostics").update_in_insert then
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, Util.get_config("diagnostics")
        )
      else
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics,
          vim.tbl_extend("force", Util.get_config("diagnostics"), {
            update_in_insert = false,
          })
        )
      end

      vim.diagnostic.config(vim.deepcopy(Util.get_config("diagnostics")))

      local inlay_hint = Util.get_config("inlay_hints")
      if inlay_hint.enabled then
        Util.on_attach(function(client, buffer)
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- Document highlighting is handled in keymaps.lua to avoid duplication

      local codelens = Util.get_config("codelens")
      if codelens.enabled then
        Util.on_attach(function(client, buffer)
          if client:supports_method("textDocument/codeLens") then
            local codelens_augroup = vim.api.nvim_create_augroup("lsp_codelens_" .. buffer, { clear = true })
            
            -- Initial refresh
            pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
            
            -- Set up refresh triggers with debouncing
            local refresh_timer = nil
            local function refresh_codelens()
              if refresh_timer then
                vim.fn.timer_stop(refresh_timer)
                refresh_timer = nil
              end
              refresh_timer = vim.fn.timer_start(100, function()
                if vim.g.codelens_enabled ~= false and vim.api.nvim_buf_is_valid(buffer) then
                  pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
                end
                refresh_timer = nil
              end)
            end
            
            vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave"}, {
              buffer = buffer,
              group = codelens_augroup,
              callback = refresh_codelens,
            })
            
            -- Clean up when buffer is deleted
            vim.api.nvim_create_autocmd("BufDelete", {
              buffer = buffer,
              callback = function()
                if refresh_timer then
                  vim.fn.timer_stop(refresh_timer)
                end
                pcall(vim.api.nvim_del_augroup_by_name, "lsp_codelens_" .. buffer)
              end,
            })
          end
        end)
      end
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    -- keybindings in config/keymaps.lua
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Modern completion engine (blink.cmp)
  {
    "saghen/blink.cmp",
    lazy = false, -- Load immediately for better performance
    version = "v0.*", -- Use latest v0.x for newest features
    dependencies = {
      "rafamadriz/friendly-snippets",
      "echasnovski/mini.icons",
    },
    
    opts = {
      keymap = { preset = "default" },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        -- do not enable cmdline, it causes a deadlock
        -- cmdline = { "path", "cmdline" },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            score_offset = 90,
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 3,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context) return vim.fn.expand(('#%d:p:h'):format(context.bufnr)) end,
              show_hidden_files_by_default = false,
            },
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 85,
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath("config") .. "/snippets" },
              global_snippets = { "all" },
              extended_filetypes = {},
              ignored_filetypes = {},
            },
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            score_offset = -3,
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(
                  function(buf)
                    if not vim.api.nvim_buf_is_valid(buf) then
                      return false
                    end
                    local ok, byte_size = pcall(vim.api.nvim_buf_get_offset, buf, vim.api.nvim_buf_line_count(buf))
                    if not ok then
                      return false
                    end
                    return byte_size < 1024 * 1024
                  end,
                  vim.api.nvim_list_bufs()
                )
              end,
              min_keyword_length = 2,
              max_items = 5,
            },
          },
        },
      },

      -- Enable signature help
      signature = { 
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
        },
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "rounded",
          scrolloff = 2,
          scrollbar = true,
          direction_priority = { "s", "n" },
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          auto_show = function(ctx)
            local buftype = vim.bo[ctx.bufnr] and vim.bo[ctx.bufnr].buftype or ""
            return ctx.mode ~= "c" and not vim.tbl_contains({ "nofile", "prompt" }, buftype)
          end,
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          treesitter_highlighting = true,
          window = {
            border = "rounded",
          },
        },
        ghost_text = {
          enabled = false, -- Disabled to avoid conflicts with Copilot
        },
        list = {
          max_items = 200,
          -- do not enable this, it causes a deadlock
          -- selection = function(ctx)
          --   return ctx.mode == "cmdline" and "auto_insert" or "preselect"
          -- end,
        },
      },

      -- Fuzzy matching configuration
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        max_typos = function(keyword) return math.floor(#keyword / 4) end,
        use_frecency = true,
        use_proximity = true,
        sorts = { 'score', 'sort_text' },
        prebuilt_binaries = {
          download = true,
        },
      },
    },
    
    opts_extend = { "sources.default" },
  },

  -- Enhanced Lua development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        -- Load LazyVim types when the `LazyVim` global is found
        { path = "LazyVim", words = { "LazyVim" } },
        -- Load lazy.nvim types when the `lazy` global is found
        { path = "lazy.nvim", words = { "lazy" } },
        -- Load mini.nvim types for all mini.* modules
        { path = "mini.nvim", words = { "mini" } },
        -- Add your project-specific libraries here
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
      -- Enable for Lua projects or when working on Neovim configuration
      enabled = function(root_dir)
        -- Check for Lua project indicators
        local lua_indicators = {
          ".luarc.json",
          ".luarc.jsonc", 
          "lua",
          "init.lua",
          "lazy-lock.json",  -- Neovim config with lazy.nvim
          ".stylua.toml",    -- Lua formatting config
          "selene.toml",     -- Lua linting config
        }
        
        for _, indicator in ipairs(lua_indicators) do
          if vim.uv.fs_stat(root_dir .. "/" .. indicator) then
            return true
          end
        end
        
        -- Check if we're in a Neovim config directory
        local nvim_config_indicators = {
          "lua/config",
          "lua/plugins", 
          "init.lua",
        }
        
        for _, indicator in ipairs(nvim_config_indicators) do
          if vim.uv.fs_stat(root_dir .. "/" .. indicator) then
            return true
          end
        end
        
        return false
      end,
    },
    dependencies = {
      -- Optional `vim.uv` typings
      { "Bilal2453/luvit-meta", lazy = true },
    },
  },
}
