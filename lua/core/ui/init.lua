-- MARVIM Ultimate UI Framework
-- Combining the best UI elements from all major vim distributions
-- Because apparently, making text editing look pretty is what we do now

local M = {}
local config = require("core.config")

-- UI state management
M.state = {
  statusline = { enabled = false },
  winbar = { enabled = false },
  tabline = { enabled = false },
  dashboard = { enabled = false },
  notifications = { enabled = false },
}

-- Initialize UI components based on configuration
function M.setup()
  local ui_config = config.get("ui", {})
  
  -- Initialize statusline
  if ui_config.statusline and ui_config.statusline.enabled then
    M.state.statusline.enabled = true
    require("core.ui.statusline").setup()
  end
  
  -- Initialize winbar
  if ui_config.winbar and ui_config.winbar.enabled then
    M.state.winbar.enabled = true
    require("core.ui.winbar").setup()
  end
  
  -- Initialize tabline
  if ui_config.tabline and ui_config.tabline.enabled then
    M.state.tabline.enabled = true
    require("core.ui.tabline").setup()
  end
  
  -- Initialize dashboard
  if ui_config.dashboard and ui_config.dashboard.enabled then
    M.state.dashboard.enabled = true
    require("core.ui.dashboard").setup()
  end
  
  -- Initialize notifications
  if ui_config.notifications and ui_config.notifications.enabled then
    M.state.notifications.enabled = true
    require("core.ui.notifications").setup()
  end
  
  -- Set up UI autocmds
  M._setup_autocmds()
end

-- Set up UI-related autocmds
function M._setup_autocmds()
  local utils = require("core.utils")
  local group = utils.augroup("marvim_ui")
  
  -- Update UI components on various events
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = group,
    callback = function()
      if M.state.winbar.enabled then
        require("core.ui.winbar").update()
      end
    end,
  })
  
  -- Handle large files by disabling UI features
  vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    group = group,
    callback = function(args)
      local file = args.file
      if file and vim.fn.getfsize(file) > config.get("performance.large_file_size", 1024 * 1024) then
        -- Disable UI features for large files
        M.disable_for_large_file()
      end
    end,
  })
  
  -- Re-enable UI features for normal files
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = group,
    callback = function(args)
      local file = args.file
      if not file or vim.fn.getfsize(file) <= config.get("performance.large_file_size", 1024 * 1024) then
        M.enable_for_normal_file()
      end
    end,
  })
end

-- Disable UI features for large files
function M.disable_for_large_file()
  if M.state.winbar.enabled then
    vim.opt_local.winbar = ""
  end
end

-- Re-enable UI features for normal files
function M.enable_for_normal_file()
  if M.state.winbar.enabled then
    require("core.ui.winbar").update()
  end
end

-- Get UI component status
function M.status()
  return {
    statusline = M.state.statusline.enabled,
    winbar = M.state.winbar.enabled,
    tabline = M.state.tabline.enabled,
    dashboard = M.state.dashboard.enabled,
    notifications = M.state.notifications.enabled,
  }
end

-- Toggle UI component
function M.toggle(component)
  if not M.state[component] then
    return false, "Unknown UI component: " .. component
  end
  
  M.state[component].enabled = not M.state[component].enabled
  
  -- Reinitialize the component
  if M.state[component].enabled then
    require("core.ui." .. component).setup()
  else
    require("core.ui." .. component).disable()
  end
  
  return true, "Toggled " .. component .. " " .. (M.state[component].enabled and "on" or "off")
end

-- Refresh all UI components
function M.refresh()
  for component, state in pairs(M.state) do
    if state.enabled then
      local ok, module = pcall(require, "core.ui." .. component)
      if ok and module.refresh then
        module.refresh()
      elseif ok and module.update then
        module.update()
      end
    end
  end
end

-- Health check for UI components
function M.health()
  local health = {
    components = {},
    performance = {
      startup_impact = 0,
      memory_usage = 0,
    },
  }
  
  for component, state in pairs(M.state) do
    health.components[component] = {
      enabled = state.enabled,
      loaded = pcall(require, "core.ui." .. component),
    }
  end
  
  return health
end

return M