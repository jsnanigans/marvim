-- MARVIM Ultimate Dashboard
-- Startup dashboard with Marvin's existential charm
-- Because even text editors need an identity crisis

local M = {}
local config = require("core.config")

-- Initialize dashboard
function M.setup()
  local dashboard_config = config.get("ui.dashboard", {})
  
  if not dashboard_config.enabled then
    return
  end
  
  -- Set up dashboard autocmd
  local utils = require("core.utils")
  local group = utils.augroup("marvim_dashboard")
  
  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
      -- Only show dashboard if no files were opened
      if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
        M.show()
      end
    end,
  })
end

-- Show the dashboard
function M.show()
  local dashboard_config = config.get("ui.dashboard", {})
  
  -- Create a new buffer for the dashboard
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "buflisted", false)
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_name(buf, "MARVIM Dashboard")
  
  -- Set window options
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.foldcolumn = "0"
  vim.opt_local.cursorline = false
  vim.opt_local.cursorcolumn = false
  vim.opt_local.colorcolumn = ""
  vim.opt_local.wrap = false
  vim.opt_local.list = false
  
  -- Build dashboard content
  local lines = {}
  local shortcuts = {}
  
  -- Add header
  if dashboard_config.header then
    for _, line in ipairs(dashboard_config.header) do
      table.insert(lines, line)
    end
    table.insert(lines, "")
  end
  
  -- Add shortcuts
  if dashboard_config.shortcuts then
    for _, shortcut in ipairs(dashboard_config.shortcuts) do
      local key_line = string.format("  %s  %s", shortcut.key, shortcut.desc)
      table.insert(lines, key_line)
      shortcuts[shortcut.key] = shortcut.action
    end
    table.insert(lines, "")
  end
  
  -- Add footer
  if dashboard_config.footer then
    local footer_lines = dashboard_config.footer
    if type(footer_lines) == "function" then
      footer_lines = footer_lines()
    end
    for _, line in ipairs(footer_lines) do
      table.insert(lines, line)
    end
  end
  
  -- Center the content
  local win_height = vim.api.nvim_win_get_height(0)
  local content_height = #lines
  local padding = math.max(0, math.floor((win_height - content_height) / 2))
  
  for _ = 1, padding do
    table.insert(lines, 1, "")
  end
  
  -- Set the buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  -- Set up keymaps for shortcuts
  for key, action in pairs(shortcuts) do
    vim.keymap.set("n", key, function()
      if type(action) == "string" then
        vim.cmd(action)
      elseif type(action) == "function" then
        action()
      end
    end, { buffer = buf, silent = true })
  end
  
  -- General dashboard keymaps
  vim.keymap.set("n", "q", ":q<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", ":q<CR>", { buffer = buf, silent = true })
  
  -- Make buffer read-only
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "readonly", true)
end

-- Disable dashboard
function M.disable()
  -- Dashboard is only shown on startup, no persistent state to disable
end

-- Refresh dashboard
function M.refresh()
  -- Check if current buffer is dashboard and refresh it
  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name:match("MARVIM Dashboard") then
    M.show()
  end
end

return M