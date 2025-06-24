-- LSP Debug Utilities
local M = {}

-- Check LSP status and capabilities
function M.check_lsp()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print("No LSP clients attached")
    return
  end
  
  for _, client in ipairs(clients) do
    print(string.format("LSP: %s (id: %d)", client.name, client.id))
    print("  Capabilities:")
    
    -- Check go-to-definition capabilities
    if client.server_capabilities.definitionProvider then
      print("    ✓ Go to definition")
    else
      print("    ✗ Go to definition")
    end
    
    -- Check go-to-implementation capabilities
    if client.server_capabilities.implementationProvider then
      print("    ✓ Go to implementation")
    else
      print("    ✗ Go to implementation")
    end
    
    -- Check references
    if client.server_capabilities.referencesProvider then
      print("    ✓ Find references")
    else
      print("    ✗ Find references")
    end
    
    -- Check organize imports
    if client.server_capabilities.codeActionProvider then
      print("    ✓ Code actions (organize imports)")
    else
      print("    ✗ Code actions (organize imports)")
    end
  end
end

-- Test go-to-definition with debugging
function M.test_definition()
  print("Testing go-to-definition...")
  
  -- Get word under cursor
  local word = vim.fn.expand("<cword>")
  print("Word under cursor: " .. word)
  
  -- Get current position
  local params = vim.lsp.util.make_position_params()
  print(string.format("Position: line %d, char %d", params.position.line, params.position.character))
  
  -- Try to get definition
  vim.lsp.buf.definition()
end

-- Stop duplicate TypeScript LSPs
function M.stop_duplicate_ts_lsp()
  local ts_clients = {}
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == "vtsls" or client.name == "ts_ls" then
      table.insert(ts_clients, client)
    end
  end
  
  -- If we have duplicates, keep only ts_ls
  if #ts_clients > 1 then
    for _, client in ipairs(ts_clients) do
      if client.name == "vtsls" then
        client.stop()
        vim.notify("Stopped duplicate vtsls client", vim.log.levels.INFO)
      end
    end
  end
end

-- Create user commands
vim.api.nvim_create_user_command("LspCheck", M.check_lsp, { desc = "Check LSP status and capabilities" })
vim.api.nvim_create_user_command("LspTestDef", M.test_definition, { desc = "Test go-to-definition with debug info" })
vim.api.nvim_create_user_command("LspStopDuplicates", M.stop_duplicate_ts_lsp, { desc = "Stop duplicate TypeScript LSPs" })

-- Auto-stop duplicates when buffer is entered
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    vim.defer_fn(M.stop_duplicate_ts_lsp, 100)
  end,
})

return M