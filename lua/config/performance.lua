-- Performance monitoring and optimization utilities
local M = {}

-- Track startup time
local start_time = vim.loop.hrtime()

-- Performance profiling
M.profile = {
  enabled = false,
  times = {},
}

-- Enable profiling
function M.enable_profiling()
  M.profile.enabled = true
  M.profile.times = {}
end

-- Log a performance checkpoint
function M.checkpoint(name)
  if not M.profile.enabled then return end
  
  local current_time = vim.loop.hrtime()
  local elapsed = (current_time - start_time) / 1e6 -- Convert to milliseconds
  
  M.profile.times[name] = elapsed
  print(string.format("Performance: %s took %.2fms", name, elapsed))
end

-- Show performance summary
function M.show_summary()
  if not M.profile.enabled then
    print("Profiling not enabled. Use require('config.performance').enable_profiling() first")
    return
  end
  
  print("\n=== MARVIM Performance Summary ===")
  local sorted_times = {}
  for name, time in pairs(M.profile.times) do
    table.insert(sorted_times, { name = name, time = time })
  end
  
  table.sort(sorted_times, function(a, b) return a.time < b.time end)
  
  for _, entry in ipairs(sorted_times) do
    print(string.format("  %-20s: %.2fms", entry.name, entry.time))
  end
  
  local total_time = (vim.loop.hrtime() - start_time) / 1e6
  print(string.format("\nTotal startup time: %.2fms", total_time))
end

-- Quick startup time check
function M.startup_time()
  local total_time = (vim.loop.hrtime() - start_time) / 1e6
  print(string.format("MARVIM startup time: %.2fms", total_time))
  return total_time
end

-- Optimize for large files
function M.optimize_for_large_file(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  
  -- Disable heavy features for large files
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].undofile = false
  vim.wo.foldmethod = "manual"
  vim.wo.spell = false
  vim.wo.colorcolumn = ""
  vim.wo.signcolumn = "no"
  
  print("Optimized buffer for large file")
end

-- Memory usage check
function M.memory_usage()
  local mem_kb = vim.fn.luaeval("collectgarbage('count')")
  local mem_mb = mem_kb / 1024
  print(string.format("Memory usage: %.2f MB", mem_mb))
  return mem_mb
end

-- Garbage collection
function M.cleanup()
  collectgarbage("collect")
  local mem_after = M.memory_usage()
  print("Garbage collection completed")
  return mem_after
end

-- Setup performance monitoring
function M.setup()
  -- Create user commands for performance monitoring
  vim.api.nvim_create_user_command("MarvimPerf", function()
    M.startup_time()
  end, { desc = "Show MARVIM startup time" })
  
  vim.api.nvim_create_user_command("MarvimMemory", function()
    M.memory_usage()
  end, { desc = "Show memory usage" })
  
  vim.api.nvim_create_user_command("MarvimCleanup", function()
    M.cleanup()
  end, { desc = "Run garbage collection" })
  
  vim.api.nvim_create_user_command("MarvimProfile", function()
    M.show_summary()
  end, { desc = "Show performance profile" })
  
  -- Add keybindings for performance monitoring
  vim.keymap.set("n", "<leader>cp", M.startup_time, { desc = "Check startup performance" })
  vim.keymap.set("n", "<leader>cm", M.memory_usage, { desc = "Check memory usage" })
  vim.keymap.set("n", "<leader>cc", M.cleanup, { desc = "Cleanup memory" })
end

return M 