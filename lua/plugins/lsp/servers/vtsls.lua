local M = {}

M.settings = {
  complete_function_calls = true,
  vtsls = {
    enableMoveToFileCodeAction = true,
    autoUseWorkspaceTsdk = true,
    experimental = {
      completion = {
        enableServerSideFuzzyMatch = true,
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
  },
}

M.on_attach = function(client, bufnr)
  -- Disable formatting in favor of prettier/eslint
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  
  -- Custom keymaps for TypeScript specific actions
  local keymaps = require("core.keymaps")
  keymaps.register({
    n = {
      ["<leader>to"] = { ":VtsOrganizeImports<CR>", { buffer = bufnr, desc = "Organize imports" } },
      ["<leader>tu"] = { ":VtsRemoveUnusedImports<CR>", { buffer = bufnr, desc = "Remove unused imports" } },
      ["<leader>ta"] = { ":VtsAddMissingImports<CR>", { buffer = bufnr, desc = "Add missing imports" } },
      ["<leader>tf"] = { ":VtsFixAll<CR>", { buffer = bufnr, desc = "Fix all" } },
      ["<leader>tr"] = { ":VtsRenameFile<CR>", { buffer = bufnr, desc = "Rename file" } },
    }
  })
end

M.capabilities = function(base_capabilities)
  -- Enhanced capabilities for TypeScript
  local capabilities = vim.deepcopy(base_capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  return capabilities
end

M.filetypes = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
}

M.init_options = {
  hostInfo = "neovim",
  plugins = {
    {
      name = "@vue/typescript-plugin",
      location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
      languages = { "javascript", "typescript", "vue" },
    },
  },
}

return M