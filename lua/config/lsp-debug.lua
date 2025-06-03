-- LSP Debug utilities
local M = {}

-- Show attached LSP clients for current buffer
function M.show_attached_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    print("No LSP clients attached to this buffer")
    return
  end
  
  print("LSP Clients attached to buffer " .. vim.api.nvim_get_current_buf() .. ":")
  for _, client in ipairs(clients) do
    print(string.format("  - %s (id: %d)", client.name, client.id))
    
    -- Show capabilities that might cause duplicates
    if client.server_capabilities then
      local caps = client.server_capabilities
      print("    Capabilities:")
      if caps.definitionProvider then
        print("      ✓ definitionProvider")
      end
      if caps.referencesProvider then
        print("      ✓ referencesProvider")
      end
      if caps.implementationProvider then
        print("      ✓ implementationProvider")
      end
    end
  end
end

-- Create commands
vim.api.nvim_create_user_command("LspClients", M.show_attached_clients, { desc = "Show attached LSP clients" })

return M