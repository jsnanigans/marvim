-- ts_ls (TypeScript Language Server) configuration
-- Direct wrapper around TypeScript's tsserver
-- Often more reliable for core features like go to definition and organize imports

return {
  init_options = {
    hostInfo = "neovim",
    preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      importModuleSpecifierPreference = "shortest",
      -- Enable organize imports
      includeCompletionsForModuleExports = true,
      quotePreference = "auto",
    },
  },
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      -- Enable organize imports functionality
      organizeImports = {
        enabled = true,
      },
      suggest = {
        includeCompletionsForModuleExports = true,
      },
      -- Important for module resolution
      preferences = {
        importModuleSpecifier = "shortest",
        includePackageJsonAutoImports = "auto",
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
      -- Important for module resolution
      preferences = {
        importModuleSpecifier = "shortest",
        includePackageJsonAutoImports = "auto",
      },
    },
  },
  -- Use the same filetypes as vtsls
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  -- Add commands for common operations
  commands = {
    OrganizeImports = {
      function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
        }
        vim.lsp.buf.execute_command(params)
      end,
      description = "Organize Imports",
    },
  },
  -- Custom handlers to ensure proper go-to-definition
  handlers = {
    ["textDocument/definition"] = vim.lsp.with(
      vim.lsp.handlers["textDocument/definition"],
      {
        -- This helps with relative imports
        reuse_win = true,
      }
    ),
  },
  -- Ensure proper root directory detection with caching
  root_dir = function(fname)
    local util = require("lspconfig.util")
    -- Use cached project finder from core utils if available
    local ok, project_utils = pcall(require, "core.utils.project")
    if ok and project_utils.find_root then
      return project_utils.find_root(fname, {"tsconfig.json", "package.json", "jsconfig.json", ".git"})
        or util.find_git_ancestor(fname)
        or util.path.dirname(fname)
    end
    -- Fallback to standard detection
    return util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
      or util.find_git_ancestor(fname)
      or util.path.dirname(fname)
  end,
}