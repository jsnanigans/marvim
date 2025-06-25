-- MARVIM Ultimate Notifications
-- Non-intrusive notification system
-- Because even Marvin needs to communicate sometimes

local M = {}
local config = require("core.config")

-- Notification state
M.notifications = {}
M.next_id = 1

-- Initialize notifications
function M.setup()
  local notifications_config = config.get("ui.notifications", {})
  
  if not notifications_config.enabled then
    return
  end
  
  -- Override vim.notify to use our system
  local original_notify = vim.notify
  vim.notify = function(msg, level, opts)
    M.show(msg, level, opts)
    -- Also call original for compatibility
    original_notify(msg, level, opts)
  end
end

-- Show a notification
function M.show(message, level, opts)
  local notifications_config = config.get("ui.notifications", {})
  opts = opts or {}
  
  level = level or vim.log.levels.INFO
  local level_name = M._get_level_name(level)
  
  local notification = {
    id = M.next_id,
    message = message,
    level = level,
    level_name = level_name,
    title = opts.title or "MARVIM",
    timeout = opts.timeout or notifications_config.timeout or 3000,
    timestamp = os.time(),
  }
  
  M.next_id = M.next_id + 1
  table.insert(M.notifications, notification)
  
  -- Auto-remove after timeout
  vim.defer_fn(function()
    M.remove(notification.id)
  end, notification.timeout)
  
  -- Display the notification
  M._display_notification(notification)
end

-- Display a notification (simple implementation)
function M._display_notification(notification)
  local notifications_config = config.get("ui.notifications", {})
  local icon = notifications_config.icons[notification.level_name:lower()] or ""
  
  -- Simple echo implementation
  local hl_group = "Normal"
  if notification.level == vim.log.levels.ERROR then
    hl_group = "ErrorMsg"
  elseif notification.level == vim.log.levels.WARN then
    hl_group = "WarningMsg"
  elseif notification.level == vim.log.levels.INFO then
    hl_group = "MoreMsg"
  end
  
  vim.api.nvim_echo({
    { string.format("[%s] %s %s", notification.title, icon, notification.message), hl_group }
  }, false, {})
end

-- Remove a notification
function M.remove(id)
  for i, notification in ipairs(M.notifications) do
    if notification.id == id then
      table.remove(M.notifications, i)
      break
    end
  end
end

-- Clear all notifications
function M.clear()
  M.notifications = {}
end

-- Get level name from level number
function M._get_level_name(level)
  local levels = {
    [vim.log.levels.TRACE] = "TRACE",
    [vim.log.levels.DEBUG] = "DEBUG", 
    [vim.log.levels.INFO] = "INFO",
    [vim.log.levels.WARN] = "WARN",
    [vim.log.levels.ERROR] = "ERROR",
  }
  return levels[level] or "INFO"
end

-- Get all notifications
function M.get_notifications()
  return M.notifications
end

-- Disable notifications
function M.disable()
  -- Restore original vim.notify if we overrode it
  -- This is a simplified implementation
end

-- Refresh notifications
function M.refresh()
  -- Notifications are event-driven, no refresh needed
end

return M