return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      "mason-org/mason.nvim",
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
          single_file_support = false,
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = false,
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
              mode = "all",
            },
            format = false,
            quiet = false,
            onIgnoredFiles = "off",
            rulesCustomizations = {},
            run = "onType",
            problems = {
              shortenToSingleLine = false,
            },
            nodePath = "",
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
        ts_ls = function()
          return true
        end,
      },
    },
    config = function(_, opts)
      -- Configure LSP handlers with borders
      vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
        config = config or {}
        config.border = config.border or "rounded"
        config.winhighlight = config.winhighlight or "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
        if
          not result
          or not result.contents
          or (type(result.contents) == "table" and vim.tbl_isempty(result.contents))
          or (type(result.contents) == "string" and result.contents == "")
        then
          return
        end
        return vim.lsp.handlers.hover(_, result, ctx, config)
      end

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      })

      vim.diagnostic.config({
        float = {
          border = "rounded",
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      })

      local Util = require("utils.lsp")
      Util.setup()
      Util.on_attach(function(client, buffer)
        vim.schedule(function()
          local ok, keymaps = pcall(require, "config.keymaps")
          if ok and keymaps.setup_lsp_keybindings then
            keymaps.setup_lsp_keybindings(client, buffer)
          end
        end)
      end)
      local servers = opts.servers
      local has_blink, blink = pcall(require, "blink.cmp")
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local completion_capabilities = {}
      if has_blink then
        local ok, caps = pcall(blink.get_lsp_capabilities)
        if ok then
          completion_capabilities = caps
        end
      end
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        completion_capabilities,
        opts.capabilities or {}
      )
      local function setup(server)
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
        all_mslp_servers = mlsp.get_available_servers()
      end
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
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
        vim.lsp.handlers["textDocument/publishDiagnostics"] =
          vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, Util.get_config("diagnostics"))
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
      local codelens = Util.get_config("codelens")
      if codelens.enabled then
        Util.on_attach(function(client, buffer)
          if client:supports_method("textDocument/codeLens") then
            local codelens_augroup = vim.api.nvim_create_augroup("lsp_codelens_" .. buffer, { clear = true })
            pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
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
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
              buffer = buffer,
              group = codelens_augroup,
              callback = refresh_codelens,
            })
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
}
