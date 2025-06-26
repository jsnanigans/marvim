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
                local ok, content = pcall(vim.fn.readfile, package_json)
                if ok and #content > 0 then
                  local json_str = table.concat(content, "\n")
                  if json_str:match('"eslintConfig"') then
                    root = package_root
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
        require("config.keybindings").setup_lsp_keybindings(client, buffer)
        

      end)

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
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

      if vim.fn.has("nvim-0.10.0") == 1 then
        Util.on_attach(function(client, buffer)
          if client:supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight_" .. buffer, { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
              buffer = buffer,
              group = highlight_augroup,
              callback = function()
                pcall(vim.lsp.buf.document_highlight)
              end,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer = buffer,
              group = highlight_augroup,
              callback = function()
                pcall(vim.lsp.buf.clear_references)
              end,
            })
            -- Clean up when buffer is deleted
            vim.api.nvim_create_autocmd("BufDelete", {
              buffer = buffer,
              callback = function()
                pcall(vim.api.nvim_del_augroup_by_name, "lsp_document_highlight_" .. buffer)
              end,
            })
          end
        end)
      end

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
    -- keybindings in config/keybindings.lua
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

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "b0o/schemastore.nvim",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded", 
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder",
          }),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = function(_, item)
            local icons = {
              Array = " ",
              Boolean = "󰨙 ",
              Class = " ",
              Codeium = "󰘦 ",
              Color = " ",
              Control = " ",
              Collapsed = " ",
              Constant = "󰏿 ",
              Constructor = " ",
              Copilot = " ",
              Enum = " ",
              EnumMember = " ",
              Event = " ",
              Field = " ",
              File = " ",
              Folder = " ",
              Function = "󰊕 ",
              Interface = " ",
              Key = " ",
              Keyword = " ",
              Method = "󰊕 ",
              Module = " ",
              Namespace = "󰦮 ",
              Null = " ",
              Number = "󰎠 ",
              Object = " ",
              Operator = " ",
              Package = " ",
              Property = " ",
              Reference = " ",
              Snippet = " ",
              String = " ",
              Struct = "󰆼 ",
              TabNine = "󰏚 ",
              Text = " ",
              TypeParameter = " ",
              Unit = " ",
              Value = " ",
              Variable = "󰀫 ",
            }
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
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