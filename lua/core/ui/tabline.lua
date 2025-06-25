-- MARVIM Ultimate Tabline
-- Enhanced tab management with buffer integration
-- Because apparently we need tabs that look impressive

local M = {}
local config = require("core.config")

-- Initialize tabline
function M.setup()
  local tabline_config = config.get("ui.tabline", {})
  
  if not tabline_config.enabled then
    return
  end
  
  -- Set up the tabline
  vim.opt.showtabline = 2 -- Always show tabline
  vim.opt.tabline = "%!v:lua.require('core.ui.tabline').render()"
end

-- Render the complete tabline
function M.render()
  local tabline_config = config.get("ui.tabline", {})
  
  local tabline = ""
  local tabs = vim.api.nvim_list_tabpages()
  
  for i, tab in ipairs(tabs) do
    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local filename = vim.api.nvim_buf_get_name(buf)
    
    -- Get file name
    local name = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    
    -- Truncate name if too long
    local max_length = tabline_config.max_name_length or 18
    if #name > max_length then
      name = name:sub(1, max_length - 3) .. "..."
    end
    
    -- Check if buffer is modified
    local modified = vim.api.nvim_buf_get_option(buf, "modified")
    local modified_icon = modified and " ●" or ""
    
    -- Check if this is the current tab
    local current = tab == vim.api.nvim_get_current_tabpage()
    local hl = current and "%#TabLineSel#" or "%#TabLine#"
    
    -- Add close icon if enabled
    local close_icon = ""
    if tabline_config.show_close_icons and #tabs > 1 then
      close_icon = " %#TabLineClose#×%*"
    end
    
    tabline = tabline .. hl .. " " .. name .. modified_icon .. close_icon .. " %*"
  end
  
  -- Fill the rest with TabLineFill
  tabline = tabline .. "%#TabLineFill#%T"
  
  return tabline
end

-- Disable tabline
function M.disable()
  vim.opt.showtabline = 1 -- Only show when multiple tabs
  vim.opt.tabline = ""
end

-- Refresh tabline
function M.refresh()
  vim.cmd("redrawtabline")
end

return M