local M = {}

-- ============================================================================
-- NORD COLORS
-- ============================================================================

M.colors = {
  -- Polar Night (darker to lighter)
  base = "#2E3440", -- nord0
  surface = "#3B4252", -- nord1
  overlay = "#434C5E", -- nord2
  highlight_high = "#4C566A", -- nord3

  -- Snow Storm (darker to lighter)
  muted = "#D8DEE9", -- nord4
  subtle = "#E5E9F0", -- nord5
  text = "#ECEFF4", -- nord6

  -- Frost (blues/teals)
  frost1 = "#8FBCBB", -- nord7
  frost2 = "#88C0D0", -- nord8
  frost3 = "#81A1C1", -- nord9
  frost4 = "#5E81AC", -- nord10

  -- Aurora (accent colors)
  love = "#BF616A", -- nord11 (red)
  gold = "#D08770", -- nord12 (orange)
  rose = "#EBCB8B", -- nord13 (yellow)
  pine = "#A3BE8C", -- nord14 (green)
  foam = "#B48EAD", -- nord15 (purple)
  iris = "#B48EAD", -- nord15 (purple - same as foam in Nord)

  -- Additional mappings for compatibility
  highlight_low = "#3B4252",
  highlight_med = "#434C5E",
}

-- ============================================================================
-- SEMANTIC COLOR MAPPING
-- ============================================================================

M.semantic = {
  bg_primary = M.colors.base,
  bg_secondary = M.colors.surface,
  bg_tertiary = M.colors.overlay,
  bg_float = M.colors.surface,
  bg_popup = M.colors.overlay,
  bg_sidebar = M.colors.surface,
  bg_statusline = M.colors.surface,

  fg_primary = M.colors.text,
  fg_secondary = M.colors.subtle,
  fg_muted = M.colors.muted,
  fg_disabled = M.colors.muted,

  hover = M.colors.highlight_med,
  active = M.colors.highlight_high,
  selected = M.colors.highlight_high,
  focus = M.colors.iris,

  border = M.colors.highlight_med,
  border_focus = M.colors.iris,
  border_active = M.colors.foam,

  error = M.colors.love,
  warning = M.colors.gold,
  info = M.colors.foam,
  success = M.colors.pine,
  hint = M.colors.iris,

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

  git_add = M.colors.pine,
  git_change = M.colors.gold,
  git_delete = M.colors.love,

  diff_add = M.colors.pine,
  diff_change = M.colors.gold,
  diff_delete = M.colors.love,
  diff_text = M.colors.foam,
}

-- ============================================================================
-- HIGHLIGHT UTILITIES
-- ============================================================================

function M.highlight(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.set_highlights(highlights)
  for group, opts in pairs(highlights) do
    M.highlight(group, opts)
  end
end

-- ============================================================================
-- COLOR MANIPULATION
-- ============================================================================

function M.with_alpha(color, alpha)
  if alpha == nil then
    return color
  end
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  return string.format("rgba(%d, %d, %d, %.2f)", r, g, b, alpha)
end

function M.darken(color, percent)
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  r = math.floor(r * (1 - percent))
  g = math.floor(g * (1 - percent))
  b = math.floor(b * (1 - percent))
  return string.format("#%02x%02x%02x", r, g, b)
end

function M.lighten(color, percent)
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  r = math.floor(r + (255 - r) * percent)
  g = math.floor(g + (255 - g) * percent)
  b = math.floor(b + (255 - b) * percent)
  return string.format("#%02x%02x%02x", r, g, b)
end

-- ============================================================================
-- UI HIGHLIGHTS
-- ============================================================================

M.ui_highlights = {
  NormalFloat = { fg = M.semantic.fg_primary, bg = "NONE" },
  FloatBorder = { fg = M.semantic.border, bg = "NONE" },
  FloatTitle = { fg = M.semantic.fg_primary, bg = "NONE", bold = true },

  Pmenu = { fg = M.semantic.fg_primary, bg = M.semantic.bg_popup },
  PmenuExtra = { fg = M.semantic.fg_secondary, bg = M.semantic.bg_popup },
  PmenuExtraSel = { fg = M.semantic.fg_primary, bg = M.semantic.selected },
  PmenuKind = { fg = M.semantic.info, bg = M.semantic.bg_popup },
  PmenuKindSel = { fg = M.semantic.info, bg = M.semantic.selected },
  PmenuSbar = { bg = M.semantic.bg_popup },
  PmenuSel = { fg = M.semantic.fg_primary, bg = M.semantic.selected },
  PmenuThumb = { bg = M.semantic.border },

  LspInfoBorder = { fg = M.semantic.border, bg = "NONE" },
  LspSignatureActiveParameter = { fg = M.semantic.focus, bold = true },

  DiagnosticError = { fg = M.semantic.error },
  DiagnosticWarn = { fg = M.semantic.warning },
  DiagnosticInfo = { fg = M.semantic.info },
  DiagnosticHint = { fg = M.semantic.hint },
  DiagnosticOk = { fg = M.semantic.success },

  LspReferenceText = { bg = M.semantic.highlight_low },
  LspReferenceRead = { bg = M.semantic.highlight_low },
  LspReferenceWrite = { bg = M.semantic.highlight_med },

  WinBar = { fg = M.semantic.fg_secondary, bg = M.semantic.bg_statusline },
  WinBarNC = { fg = M.semantic.fg_muted, bg = M.semantic.bg_statusline },
}

-- ============================================================================
-- SETUP FUNCTION
-- ============================================================================

function M.setup()
  vim.schedule(function()
    M.set_highlights(M.ui_highlights)
  end)

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      if vim.g.colors_name == "nord" then
        vim.schedule(function()
          M.set_highlights(M.ui_highlights)
        end)
      end
    end,
  })
end

return M
