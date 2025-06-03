-- LSP Configuration - The brain of your coding setup

-- Helper function to safely configure LSP servers
local function safe_lsp_setup(server_name, setup_fn)
  local ok, err = pcall(setup_fn)
  if not ok then
    vim.notify(string.format("Failed to configure %s: %s", server_name, tostring(err)), vim.log.levels.ERROR)
  end
end

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Enable keybinds only for when lsp server available
      local on_attach = function(client, bufnr)
        -- Configure diagnostics on first LSP attach
        configure_diagnostics()
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local keymap = vim.keymap.set

        keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
        keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        
        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
        keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
        keymap("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
        keymap("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap("n", "]d", vim.diagnostic.goto_next, opts)
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "<leader>rs", ":LspRestart<CR>", opts)

        -- Toggle inlay hints (if supported)
        if client.supports_method("textDocument/inlayHint") then
          keymap("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(bufnr), { bufnr = bufnr })
          end, { desc = "Toggle Inlay Hints", buffer = bufnr })
        end

        -- Conditional formatting for specific file types only
        if client.supports_method("textDocument/formatting") then
          -- Disable formatting for ts_ls - let prettier/eslint handle it
          if client.name == "ts_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          else
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end
      end

      -- Used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Defer diagnostic configuration until first LSP attaches
      local diagnostic_configured = false
      local function configure_diagnostics()
        if diagnostic_configured then return end
        diagnostic_configured = true

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

        vim.diagnostic.config({
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = signs.Error,
              [vim.diagnostic.severity.WARN] = signs.Warn,
              [vim.diagnostic.severity.HINT] = signs.Hint,
              [vim.diagnostic.severity.INFO] = signs.Info,
            },
          },
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
          },
          severity_sort = true,
        })
      end

      mason_lspconfig.setup({
        ensure_installed = {
          "vtsls", -- Using vtsls instead of ts_ls to avoid duplicates
          "html",
          "cssls",
          "tailwindcss",
          "lua_ls",
          "graphql",
          "emmet_ls",
          "prismals",
          "pyright",
          "eslint",
        },
        -- Don't automatically install servers that fail
        automatic_installation = false,
        handlers = {
          -- Default handler
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,
          -- Custom handlers
          ["lua_ls"] = function()
            -- Check if lua_ls is available before configuring
            local ok, _ = pcall(function()
              lspconfig["lua_ls"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                  Lua = {
                    runtime = {
                      version = "LuaJIT",
                    },
                    diagnostics = {
                      globals = { "vim" },
                    },
                    workspace = {
                      library = vim.api.nvim_get_runtime_file("", true),
                      checkThirdParty = false,
                    },
                    telemetry = {
                      enable = false,
                    },
                    completion = {
                      callSnippet = "Replace",
                    },
                  },
                },
              })
            end)

            if not ok then
              vim.notify("lua_ls failed to setup. Install via Mason or system package manager.", vim.log.levels.WARN)
            end
          end,
          ["vtsls"] = function()
            safe_lsp_setup("vtsls", function()
              -- Get vue language server path for Vue support
              local mason_registry = require("mason-registry")
            local vue_language_server_path = nil

            -- Try to get Vue language server path if vue-language-server is installed
            if mason_registry.is_installed("vue-language-server") then
              vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
            end

            local init_options = {
              preferences = {
                disableSuggestions = false,
                quotePreference = "auto",
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
                includeCompletionsWithSnippetText = true,
                includeAutomaticOptionalChainCompletions = true,
              },
            }

            -- Add Vue plugin if vue-language-server is available
            if vue_language_server_path then
              init_options.plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                },
              }
            end

            lspconfig["vtsls"].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              init_options = init_options,
              filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
                vue_language_server_path and "vue" or nil,
              },
              settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "literal",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
              },
            })
            end)
          end,
          ["eslint"] = function()
            safe_lsp_setup("eslint", function()
            lspconfig["eslint"].setup({
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                -- Disable ESLint LSP features that conflict with ts_ls
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
                client.server_capabilities.definitionProvider = false
                client.server_capabilities.referencesProvider = false
                client.server_capabilities.implementationProvider = false
                client.server_capabilities.typeDefinitionProvider = false
                
                on_attach(client, bufnr)

                -- Auto-fix on save
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  command = "EslintFixAll",
                })
              end,
              -- Check if the project has ESLint installed before attaching
              root_dir = function(fname)
                local util = require("lspconfig.util")
                -- Look for ESLint config files or node_modules/eslint
                local root = util.root_pattern(
                  ".eslintrc",
                  ".eslintrc.js",
                  ".eslintrc.cjs",
                  ".eslintrc.yaml",
                  ".eslintrc.yml",
                  ".eslintrc.json",
                  "eslint.config.js",
                  "eslint.config.mjs",
                  "eslint.config.cjs"
                )(fname)
                
                -- If we found a config but no local eslint, don't attach
                if root then
                  local eslint_path = root .. "/node_modules/eslint"
                  if vim.fn.isdirectory(eslint_path) == 0 then
                    return nil
                  end
                end
                
                return root
              end,
              settings = {
                packageManager = "npm",
                useESLintClass = false,
                experimental = {
                  useFlatConfig = false,
                },
                codeAction = {
                  disableRuleComment = {
                    enable = true,
                    location = "separateLine",
                  },
                  showDocumentation = {
                    enable = true,
                  },
                },
                codeActionOnSave = {
                  enable = false,
                  mode = "all",
                },
                format = true,
                nodePath = "",
                onIgnoredFiles = "off",
                problems = {
                  shortenToSingleLine = false,
                },
                quiet = false,
                rulesCustomizations = {},
                run = "onType",
                validate = "on",
                workingDirectory = {
                  mode = "location",
                },
              },
            })
            end)
          end,
          ["emmet_ls"] = function()
            lspconfig["emmet_ls"].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
            })
          end,
          ["pyright"] = function()
            lspconfig["pyright"].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                pyright = {
                  disableOrganizeImports = false,
                  analysis = {
                    useLibraryCodeForTypes = true,
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    autoImportCompletions = true,
                  },
                },
              },
            })
          end,
          -- Disable ts_ls since we're using vtsls
          ["ts_ls"] = function()
            -- Do nothing - this prevents ts_ls from being configured
            vim.notify("ts_ls is disabled in favor of vtsls", vim.log.levels.INFO)
          end,
        },
      })
    end,
  },
}
