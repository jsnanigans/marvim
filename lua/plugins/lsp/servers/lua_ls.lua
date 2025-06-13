local M = {}

M.settings = {
  Lua = {
    runtime = {
      version = "LuaJIT",
    },
    diagnostics = {
      globals = { "vim", "require" },
      disable = { "missing-fields" },
    },
    workspace = {
      library = {
        vim.env.VIMRUNTIME,
        vim.fn.stdpath("config") .. "/lua",
      },
      checkThirdParty = false,
    },
    telemetry = {
      enable = false,
    },
    completion = {
      callSnippet = "Replace",
    },
    hint = {
      enable = true,
      setType = true,
      paramType = true,
      paramName = "Disable",
      semicolon = "Disable",
      arrayIndex = "Disable",
    },
    format = {
      enable = false, -- Use stylua instead
    },
  },
}

M.on_attach = function(client, bufnr)
  -- Disable formatting in favor of stylua
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

M.capabilities = function(base_capabilities)
  return base_capabilities
end

return M