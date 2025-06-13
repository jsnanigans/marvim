-- LSP Configuration - The brain of your coding setup
local utils = require("core.utils")
local lsp_utils = require("plugins.lsp.utils")
local config = require("core.config")

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

      -- Configure diagnostics
      local function configure_diagnostics()
        vim.diagnostic.config({
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = config.ui.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = config.ui.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = config.ui.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = config.ui.icons.diagnostics.Info,
            },
          },
          virtual_text = config.lsp.virtual_text and {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          } or false,
          float = config.lsp.float,
          severity_sort = config.lsp.severity_sort,
          signs = config.lsp.signs,
          underline = config.lsp.underline,
          update_in_insert = config.lsp.update_in_insert,
        })
      end

      -- Base on_attach function
      local on_attach = function(client, bufnr)
        -- Configure diagnostics on first LSP attach
        configure_diagnostics()
        
        -- Attach navic if supported
        if client.server_capabilities.documentSymbolProvider then
          local ok, navic = pcall(require, "nvim-navic")
          if ok then
            navic.attach(client, bufnr)
          end
        end
        
        -- Setup LSP keymaps
        require("core.keymaps.lsp").on_attach(bufnr)
        
        -- Enable inlay hints if supported and configured
        if config.lsp.inlay_hints.enabled and client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      -- Base capabilities
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Ensure installed servers
      mason_lspconfig.setup({
        ensure_installed = {
          "vtsls",
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
        automatic_installation = false,
        handlers = {
        -- Default handler
        function(server_name)
          local opts = lsp_utils.get_server_opts(server_name, {
            capabilities = capabilities,
            on_attach = on_attach,
          })
          lspconfig[server_name].setup(opts)
        end,
        
        -- Special handling for vtsls to prevent conflicts with ts_ls
        ["vtsls"] = function()
          -- Stop ts_ls if it's running
          for _, client in pairs(vim.lsp.get_clients()) do
            if client.name == "ts_ls" then
              client.stop()
            end
          end
          
          local opts = lsp_utils.get_server_opts("vtsls", {
            capabilities = capabilities,
            on_attach = on_attach,
          })
          lspconfig.vtsls.setup(opts)
        end,
        }
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "SmiteshP/nvim-navic", opts = { lsp = { auto_attach = true } } },
      {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
          bind = true,
          handler_opts = {
            border = "rounded",
          },
          floating_window = false,
          hint_prefix = "🤖 ",
          hint_enable = true,
          hint_inline = function()
            return vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled()
          end,
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },
}