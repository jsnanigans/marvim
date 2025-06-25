-- MARVIM Ultimate Statusline
-- Combining the elegance of LazyVim, power of AstroVim, beauty of NvChad
-- Because if we're going to display status, we might as well do it with style

local M = {}
local config = require("core.config")

-- Statusline components
M.components = {}
M.cache = {}
M.timer = nil

-- Initialize statusline
function M.setup()
  local statusline_config = config.get("ui.statusline", {})
  
  if not statusline_config.enabled then
    return
  end
  
  -- Set up the statusline
  vim.opt.statusline = "%!v:lua.require('core.ui.statusline').render()"
  vim.opt.laststatus = 3 -- Global statusline
  
  -- Initialize components
  M._init_components()
  
  -- Set up refresh timer
  M._setup_refresh_timer()
end

-- Initialize all statusline components
function M._init_components()
  M.components = {
    mode = M._component_mode,
    file_info = M._component_file_info,
    git_branch = M._component_git_branch,
    git_diff = M._component_git_diff,
    diagnostics = M._component_diagnostics,
    lsp_progress = M._component_lsp_progress,
    search_count = M._component_search_count,
    location = M._component_location,
    progress = M._component_progress,
  }
end

-- Set up refresh timer for dynamic components
function M._setup_refresh_timer()
  if M.timer then
    vim.fn.timer_stop(M.timer)
  end
  
  M.timer = vim.fn.timer_start(1000, function()
    M._update_cache()
    vim.cmd("redrawstatus")
  end, { ["repeat"] = -1 })
end

-- Update cache for expensive operations
function M._update_cache()
  -- Cache LSP progress
  M.cache.lsp_progress = M._get_lsp_progress()
  
  -- Cache git information
  M.cache.git_branch = M._get_git_branch()
  M.cache.git_diff = M._get_git_diff()
  
  -- Cache diagnostics
  M.cache.diagnostics = M._get_diagnostics()
end

-- Render the complete statusline
function M.render()
  local statusline_config = config.get("ui.statusline", {})
  local components = statusline_config.components or {}
  local separators = statusline_config.separators or { left = "", right = "" }
  
  local left_parts = {}
  local right_parts = {}
  
  -- Build left side components
  for i, component_name in ipairs(components) do
    if i <= math.floor(#components / 2) then
      local component = M.components[component_name]
      if component then
        local result = component()
        if result and result ~= "" then
          table.insert(left_parts, result)
        end
      end
    end
  end
  
  -- Build right side components
  for i, component_name in ipairs(components) do
    if i > math.floor(#components / 2) then
      local component = M.components[component_name]
      if component then
        local result = component()
        if result and result ~= "" then
          table.insert(right_parts, result)
        end
      end
    end
  end
  
  -- Combine left and right parts
  local left = table.concat(left_parts, " " .. separators.left .. " ")
  local right = table.concat(right_parts, " " .. separators.right .. " ")
  
  return left .. "%=" .. right
end

-- Mode component with colors
function M._component_mode()
  local mode_map = {
    n = { "NORMAL", "StatusLineModeNormal" },
    i = { "INSERT", "StatusLineModeInsert" },
    v = { "VISUAL", "StatusLineModeVisual" },
    V = { "V-LINE", "StatusLineModeVisual" },
    [""] = { "V-BLOCK", "StatusLineModeVisual" },
    c = { "COMMAND", "StatusLineModeCommand" },
    s = { "SELECT", "StatusLineModeSelect" },
    S = { "S-LINE", "StatusLineModeSelect" },
    [""] = { "S-BLOCK", "StatusLineModeSelect" },
    R = { "REPLACE", "StatusLineModeReplace" },
    r = { "PROMPT", "StatusLineModeReplace" },
    ["!"] = { "SHELL", "StatusLineModeCommand" },
    t = { "TERMINAL", "StatusLineModeCommand" },
  }
  
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_info = mode_map[current_mode] or { "UNKNOWN", "StatusLine" }
  
  return string.format("%%#%s# %s %%*", mode_info[2], mode_info[1])
end

-- File information component
function M._component_file_info()
  local file_name = vim.fn.expand("%:t")
  if file_name == "" then
    file_name = "[No Name]"
  end
  
  local file_icon = ""
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local extension = vim.fn.expand("%:e")
    file_icon = devicons.get_icon(file_name, extension, { default = true }) or ""
    file_icon = file_icon .. " "
  end
  
  local modified = vim.bo.modified and " ●" or ""
  local readonly = vim.bo.readonly and " " or ""
  
  return file_icon .. file_name .. modified .. readonly
end

-- Git branch component
function M._component_git_branch()
  if M.cache.git_branch then
    return " " .. M.cache.git_branch
  end
  return ""
end

-- Git diff component
function M._component_git_diff()
  if M.cache.git_diff and M.cache.git_diff.total > 0 then
    local added = M.cache.git_diff.added > 0 and ("+" .. M.cache.git_diff.added) or ""
    local changed = M.cache.git_diff.changed > 0 and ("~" .. M.cache.git_diff.changed) or ""
    local removed = M.cache.git_diff.removed > 0 and ("-" .. M.cache.git_diff.removed) or ""
    
    local parts = {}
    if added ~= "" then table.insert(parts, "%#GitSignsAdd#" .. added .. "%*") end
    if changed ~= "" then table.insert(parts, "%#GitSignsChange#" .. changed .. "%*") end
    if removed ~= "" then table.insert(parts, "%#GitSignsDelete#" .. removed .. "%*") end
    
    return table.concat(parts, " ")
  end
  return ""
end

-- Diagnostics component
function M._component_diagnostics()
  if M.cache.diagnostics and M.cache.diagnostics.total > 0 then
    local errors = M.cache.diagnostics.errors > 0 and (" " .. M.cache.diagnostics.errors) or ""
    local warnings = M.cache.diagnostics.warnings > 0 and (" " .. M.cache.diagnostics.warnings) or ""
    local hints = M.cache.diagnostics.hints > 0 and (" " .. M.cache.diagnostics.hints) or ""
    local info = M.cache.diagnostics.info > 0 and (" " .. M.cache.diagnostics.info) or ""
    
    local parts = {}
    if errors ~= "" then table.insert(parts, "%#DiagnosticSignError#" .. errors .. "%*") end
    if warnings ~= "" then table.insert(parts, "%#DiagnosticSignWarn#" .. warnings .. "%*") end
    if hints ~= "" then table.insert(parts, "%#DiagnosticSignHint#" .. hints .. "%*") end
    if info ~= "" then table.insert(parts, "%#DiagnosticSignInfo#" .. info .. "%*") end
    
    return table.concat(parts, " ")
  end
  return ""
end

-- LSP progress component
function M._component_lsp_progress()
  if M.cache.lsp_progress and M.cache.lsp_progress ~= "" then
    return " " .. M.cache.lsp_progress
  end
  return ""
end

-- Search count component
function M._component_search_count()
  if vim.v.hlsearch == 1 then
    local ok, result = pcall(vim.fn.searchcount)
    if ok and result.total and result.total > 0 then
      return string.format("[%d/%d]", result.current, result.total)
    end
  end
  return ""
end

-- Location component
function M._component_location()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local total_lines = vim.fn.line("$")
  
  return string.format("%d:%d/%d", line, col, total_lines)
end

-- Progress component
function M._component_progress()
  local line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  
  if total_lines == 0 then
    return "0%"
  end
  
  local percentage = math.floor((line / total_lines) * 100)
  return percentage .. "%%"
end

-- Get git branch information
function M._get_git_branch()
  local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error == 0 and branch ~= "" then
    return branch
  end
  return nil
end

-- Get git diff information
function M._get_git_diff()
  -- This should integrate with gitsigns if available
  local has_gitsigns, gitsigns = pcall(require, "gitsigns")
  if has_gitsigns then
    local status = vim.b.gitsigns_status_dict
    if status then
      return {
        added = status.added or 0,
        changed = status.changed or 0,
        removed = status.removed or 0,
        total = (status.added or 0) + (status.changed or 0) + (status.removed or 0),
      }
    end
  end
  return nil
end

-- Get diagnostics information
function M._get_diagnostics()
  local diagnostics = vim.diagnostic.get(0)
  local counts = { errors = 0, warnings = 0, hints = 0, info = 0, total = 0 }
  
  for _, diagnostic in ipairs(diagnostics) do
    local severity = diagnostic.severity
    counts.total = counts.total + 1
    
    if severity == vim.diagnostic.severity.ERROR then
      counts.errors = counts.errors + 1
    elseif severity == vim.diagnostic.severity.WARN then
      counts.warnings = counts.warnings + 1
    elseif severity == vim.diagnostic.severity.HINT then
      counts.hints = counts.hints + 1
    elseif severity == vim.diagnostic.severity.INFO then
      counts.info = counts.info + 1
    end
  end
  
  return counts
end

-- Get LSP progress information
function M._get_lsp_progress()
  -- Use the new progress API if available
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    return ""
  end
  
  local progress_parts = {}
  for _, client in ipairs(clients) do
    if client.progress and client.progress.value then
      local progress = client.progress.value
      if progress.kind == "begin" or progress.kind == "report" then
        local percentage = progress.percentage and (progress.percentage .. "%%") or ""
        local title = progress.title or client.name
        table.insert(progress_parts, title .. " " .. percentage)
      end
    end
  end
  
  return table.concat(progress_parts, " | ")
end

-- Disable statusline
function M.disable()
  if M.timer then
    vim.fn.timer_stop(M.timer)
    M.timer = nil
  end
  vim.opt.statusline = ""
end

-- Refresh statusline
function M.refresh()
  M._update_cache()
  vim.cmd("redrawstatus")
end

return M