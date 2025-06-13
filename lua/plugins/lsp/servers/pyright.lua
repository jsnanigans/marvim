local M = {}

M.settings = {
  python = {
    analysis = {
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      diagnosticMode = "workspace",
      typeCheckingMode = "standard",
      autoImportCompletions = true,
      indexing = true,
      inlayHints = {
        variableTypes = true,
        functionReturnTypes = true,
        parameterTypes = true,
      },
    },
  },
}

M.on_attach = function(client, bufnr)
  -- Disable formatting in favor of ruff
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  
  -- Python specific keymaps
  local keymaps = require("core.keymaps")
  keymaps.register({
    n = {
      ["<leader>tI"] = { ":PyrightOrganizeImports<CR>", { buffer = bufnr, desc = "Organize imports" } },
    }
  })
end

M.capabilities = function(base_capabilities)
  return base_capabilities
end

-- Dynamic root pattern based on project type
M.root_dir = function(fname)
  local util = require("lspconfig.util")
  return util.root_pattern(
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "poetry.lock",
    ".git"
  )(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
end

return M