-- MARVIM Unified Theme System
-- Based on Rose Pine color palette
-- Provides consistent theming across all plugins

local M = {}

-- Rose Pine Color Palette
M.colors = {
  -- Base colors
  base = "#191724",
  surface = "#1f1d2e",
  overlay = "#26233a",
  muted = "#6e6a86",
  subtle = "#908caa",
  text = "#e0def4",
  -- Accent colors
  love = "#eb6f92",
  gold = "#f6c177",
  rose = "#ebbcba",
  pine = "#31748f",
  foam = "#9ccfd8",
  iris = "#c4a7e7",
  -- Highlight variants
  highlight_low = "#21202e",
  highlight_med = "#403d52",
  highlight_high = "#524f67",
}

-- Semantic color mapping for consistent usage
M.semantic = {
  -- Background variants
  bg_primary = M.colors.base,
  bg_secondary = M.colors.surface,
  bg_tertiary = M.colors.overlay,
  bg_float = M.colors.surface,
  bg_popup = M.colors.overlay,
  bg_sidebar = M.colors.surface,
  bg_statusline = M.colors.surface,
  -- Foreground variants  
  fg_primary = M.colors.text,
  fg_secondary = M.colors.subtle,
  fg_muted = M.colors.muted,
  fg_disabled = M.colors.muted,
  -- Interactive states
  hover = M.colors.highlight_med,
  active = M.colors.highlight_high,
  selected = M.colors.highlight_high,
  focus = M.colors.iris,
  -- Borders
  border = M.colors.highlight_med,
  border_focus = M.colors.iris,
  border_active = M.colors.foam,
  -- Status colors
  error = M.colors.love,
  warning = M.colors.gold,
  info = M.colors.foam,
  success = M.colors.pine,
  hint = M.colors.iris,
  -- Code syntax highlighting
  keyword = M.colors.pine,
  function_name = M.colors.rose,
  string = M.colors.gold,
  number = M.colors.iris,
  boolean = M.colors.love,
  comment = M.colors.muted,
  variable = M.colors.text,
  constant = M.colors.foam,
  type = M.colors.iris,
  class = M.colors.foam,
  method = M.colors.rose,
  property = M.colors.iris,
  -- Git colors
  git_add = M.colors.pine,
  git_change = M.colors.gold,
  git_delete = M.colors.love,
  -- Diff colors
  diff_add = M.colors.pine,
  diff_change = M.colors.gold,
  diff_delete = M.colors.love,
  diff_text = M.colors.foam,
}

-- Helper functions for creating highlight groups
function M.highlight(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Batch highlight creation
function M.set_highlights(highlights)
  for group, opts in pairs(highlights) do
    M.highlight(group, opts)
  end
end

-- Get a color with optional transparency
function M.with_alpha(color, alpha)
  if alpha == nil then return color end
  -- Convert hex to rgb
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  -- Return rgba format
  return string.format("rgba(%d, %d, %d, %.2f)", r, g, b, alpha)
end

-- Darken a color by a percentage
function M.darken(color, percent)
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  r = math.floor(r * (1 - percent))
  g = math.floor(g * (1 - percent))
  b = math.floor(b * (1 - percent))
  return string.format("#%02x%02x%02x", r, g, b)
end

-- Lighten a color by a percentage  
function M.lighten(color, percent)
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  r = math.floor(r + (255 - r) * percent)
  g = math.floor(g + (255 - g) * percent)
  b = math.floor(b + (255 - b) * percent)
  return string.format("#%02x%02x%02x", r, g, b)
end

-- Common UI component highlight groups
M.ui_highlights = {
  -- Floating windows (transparent backgrounds to eliminate solid color outside borders)
  NormalFloat = { fg = M.semantic.fg_primary, bg = "NONE" },
  FloatBorder = { fg = M.semantic.border, bg = "NONE" },
  FloatTitle = { fg = M.semantic.fg_primary, bg = "NONE", bold = true },
  -- Popups and menus
  Pmenu = { fg = M.semantic.fg_primary, bg = M.semantic.bg_popup },
  PmenuExtra = { fg = M.semantic.fg_secondary, bg = M.semantic.bg_popup },
  PmenuExtraSel = { fg = M.semantic.fg_primary, bg = M.semantic.selected },
  PmenuKind = { fg = M.semantic.info, bg = M.semantic.bg_popup },
  PmenuKindSel = { fg = M.semantic.info, bg = M.semantic.selected },
  PmenuSbar = { bg = M.semantic.bg_popup },
  PmenuSel = { fg = M.semantic.fg_primary, bg = M.semantic.selected },
  PmenuThumb = { bg = M.semantic.border },
  -- LSP floating windows
  LspInfoBorder = { fg = M.semantic.border, bg = "NONE" },
  LspSignatureActiveParameter = { fg = M.semantic.focus, bold = true },
  -- Diagnostics
  DiagnosticError = { fg = M.semantic.error },
  DiagnosticWarn = { fg = M.semantic.warning },
  DiagnosticInfo = { fg = M.semantic.info },
  DiagnosticHint = { fg = M.semantic.hint },
  DiagnosticOk = { fg = M.semantic.success },
  -- LSP references
  LspReferenceText = { bg = M.semantic.highlight_low },
  LspReferenceRead = { bg = M.semantic.highlight_low },
  LspReferenceWrite = { bg = M.semantic.highlight_med },
  -- Winbar
  WinBar = { fg = M.semantic.fg_secondary, bg = M.semantic.bg_statusline },
  WinBarNC = { fg = M.semantic.fg_muted, bg = M.semantic.bg_statusline },
}

-- Apply the unified theme
function M.setup()
  -- Defer setup to avoid startup messages
  vim.schedule(function()
    -- Set base highlights
    M.set_highlights(M.ui_highlights)
  end)
  -- Create autocmd to reapply on colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      -- Only reapply if we're using rose-pine
      if vim.g.colors_name == "rose-pine" then
        vim.schedule(function()
          M.set_highlights(M.ui_highlights)
        end)
      end
    end,
  })
end

return M
