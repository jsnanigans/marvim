local M = {}

-- Get visual selection text
-- @return string The selected text
function M.get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

-- Check if a plugin is loaded
-- @param name string The plugin name
-- @return boolean
function M.is_loaded(name)
  local status, lazy = pcall(require, "lazy.core.config")
  return status and lazy.plugins[name] and lazy.plugins[name]._.loaded
end

-- Create autocmd group with namespace
-- @param name string The group name
-- @param opts table Optional autocmd group options
-- @return number The augroup id
function M.augroup(name, opts)
  return vim.api.nvim_create_augroup("marvim_" .. name, opts or { clear = true })
end

-- Create an autocmd
-- @param event string|table The event(s) to listen for
-- @param opts table The autocmd options
function M.autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts)
end

-- Debounce a function
-- @param fn function The function to debounce
-- @param ms number Milliseconds to wait
-- @return function The debounced function
function M.debounce(fn, ms)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer then
      vim.fn.timer_stop(timer)
    end
    timer = vim.fn.timer_start(ms, function()
      timer = nil
      vim.schedule(function()
        fn(unpack(args))
      end)
    end)
  end
end

-- Throttle a function
-- @param fn function The function to throttle
-- @param ms number Milliseconds to wait between calls
-- @return function The throttled function
function M.throttle(fn, ms)
  local timer = nil
  local last_call = 0
  return function(...)
    local args = {...}
    local now = vim.loop.now()
    local remaining = ms - (now - last_call)
    
    if remaining <= 0 then
      if timer then
        vim.fn.timer_stop(timer)
        timer = nil
      end
      last_call = now
      return fn(...)
    elseif not timer then
      timer = vim.fn.timer_start(remaining, function()
        timer = nil
        last_call = vim.loop.now()
        fn(unpack(args))
      end)
    end
  end
end

-- Deep merge tables
-- @param ... table Tables to merge
-- @return table The merged table
function M.deep_merge(...)
  local result = {}
  for _, tbl in ipairs({ ... }) do
    if type(tbl) == "table" then
      for k, v in pairs(tbl) do
        if type(v) == "table" and type(result[k]) == "table" then
          result[k] = M.deep_merge(result[k], v)
        else
          result[k] = v
        end
      end
    end
  end
  return result
end

-- Check if running in a terminal
-- @return boolean
function M.is_terminal()
  return vim.fn.has("gui_running") == 0
end

-- Get the current OS
-- @return string "windows", "mac", or "linux"
function M.get_os()
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return "windows"
  elseif vim.fn.has("mac") == 1 then
    return "mac"
  else
    return "linux"
  end
end

-- Check if a command exists
-- @param cmd string The command to check
-- @return boolean
function M.command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Get file size in bytes
-- @param file string The file path
-- @return number File size in bytes
function M.get_file_size(file)
  local ok, stats = pcall(vim.loop.fs_stat, file)
  return ok and stats and stats.size or 0
end

-- Check if file is large based on config
-- @param file string The file path
-- @return boolean
function M.is_large_file(file)
  local config = require("core.config")
  local size = M.get_file_size(file)
  return size > config.performance.large_file_size
end

-- Notification with custom defaults
-- @param msg string The message
-- @param level number|string The log level
-- @param opts table Optional notification options
function M.notify(msg, level, opts)
  opts = opts or {}
  level = level or vim.log.levels.INFO
  
  if type(level) == "string" then
    level = vim.log.levels[level:upper()] or vim.log.levels.INFO
  end
  
  vim.notify(msg, level, vim.tbl_extend("force", {
    title = "MARVIM",
  }, opts))
end

-- Safe require with error handling
-- @param module string The module to require
-- @return table|nil The module or nil if error
-- @return string|nil Error message if failed
function M.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    return nil, result
  end
  return result
end

return M