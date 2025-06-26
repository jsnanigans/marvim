-- Debug script to help identify Neovim crashes
-- Save this file and run :luafile debug_crashes.lua

local M = {}

-- Enable verbose logging
vim.o.verbose = 1

-- Log LSP activity
local original_on_attach = vim.lsp.buf_attach_client
vim.lsp.buf_attach_client = function(client, bufnr)
  print(string.format("[DEBUG] LSP attach: %s to buffer %d", client.name, bufnr))
  return original_on_attach(client, bufnr)
end

-- Monitor autocmd creation
local original_create_autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_autocmd = function(events, opts)
  if type(events) == "string" then
    events = { events }
  end
  print(string.format("[DEBUG] Creating autocmd for events: %s, group: %s", 
    table.concat(events, ","), opts.group or "default"))
  return original_create_autocmd(events, opts)
end

-- Monitor buffer events
vim.api.nvim_create_autocmd({"BufEnter", "BufLeave", "InsertEnter", "InsertLeave"}, {
  callback = function(args)
    print(string.format("[DEBUG] Event: %s, buffer: %d, filetype: %s", 
      args.event, args.buf, vim.bo[args.buf].filetype))
  end
})

-- Check for runaway processes
local check_performance = function()
  local stats = vim.loop.getrusage()
  if stats.maxrss > 500000 then -- 500MB
    print(string.format("[WARNING] High memory usage: %d KB", stats.maxrss))
  end
end

vim.fn.timer_start(5000, check_performance, { ["repeat"] = -1 })

-- Command to check current autocmds
vim.api.nvim_create_user_command("DebugAutocmds", function()
  vim.cmd("autocmd")
end, {})

-- Command to check LSP clients
vim.api.nvim_create_user_command("DebugLSP", function()
  local clients = vim.lsp.get_clients()
  print("Active LSP clients:")
  for _, client in ipairs(clients) do
    print(string.format("- %s (id: %d)", client.name, client.id))
  end
end, {})

print("[DEBUG] Crash debugging enabled. Use :DebugAutocmds and :DebugLSP to investigate.")

return M