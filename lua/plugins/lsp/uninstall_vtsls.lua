-- Uninstall vtsls from Mason
vim.api.nvim_create_user_command("UninstallVtsls", function()
  vim.cmd("MasonUninstall vtsls")
  vim.notify("Uninstalling vtsls from Mason", vim.log.levels.INFO)
end, { desc = "Uninstall vtsls from Mason" })

-- Auto-uninstall vtsls if it's installed
vim.defer_fn(function()
  local registry = require("mason-registry")
  if registry.is_installed("vtsls") then
    vim.notify("vtsls is installed, removing it to prevent conflicts", vim.log.levels.WARN)
    vim.cmd("MasonUninstall vtsls")
  end
end, 1000)