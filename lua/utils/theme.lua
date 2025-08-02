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

  -- Snow Storm (darker to lighter) - INCREASED CONTRAST
  muted = "#A8B0C0", -- Brightened from #D8DEE9
  subtle = "#C8D0E0", -- Brightened from #E5E9F0
  text = "#F2F4F8", -- Brightened from #ECEFF4

  -- Frost (blues/teals) - MORE VIBRANT
  frost1 = "#9FCCC8", -- Brightened from #8FBCBB
  frost2 = "#98D0E0", -- Brightened from #88C0D0
  frost3 = "#91B1D1", -- Brightened from #81A1C1
  frost4 = "#6E91BC", -- Brightened from #5E81AC

  -- Aurora (accent colors) - MORE VIBRANT
  love = "#CF717A", -- Brightened from #BF616A
  gold = "#E09780", -- Brightened from #D08770
  rose = "#FBDB9B", -- Brightened from #EBCB8B
  pine = "#B3CE9C", -- Brightened from #A3BE8C
  foam = "#C49EBD", -- Brightened from #B48EAD
  iris = "#C49EBD", -- Brightened from #B48EAD

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
  
  -- Line numbers with better contrast
  LineNr = { fg = "#B0B9C8" }, -- Much brighter gray
  LineNrAbove = { fg = "#B0B9C8" },
  LineNrBelow = { fg = "#B0B9C8" },
  CursorLineNr = { fg = M.colors.text, bold = true },
  
  -- Snacks picker highlights for better contrast
  SnacksPickerMatch = { fg = M.colors.frost2, bold = true },
  SnacksPickerMatchBorder = { fg = M.colors.frost3 },
  SnacksPickerNormal = { fg = M.colors.text },
  SnacksPickerFaint = { fg = "#B0B9C8" }, -- Much brighter gray for file paths
  SnacksPickerComment = { fg = "#B0B9C8" }, -- Much brighter gray for comments
  SnacksPickerSelection = { bg = M.colors.highlight_high, fg = M.colors.text },
  SnacksPickerSelectionBorder = { bg = M.colors.highlight_high, fg = M.colors.frost3 },
  
  -- Telescope-like highlights that snacks might also use
  TelescopeNormal = { fg = M.colors.text },
  TelescopePreviewLine = { bg = M.colors.highlight_high },
  TelescopePreviewMatch = { fg = M.colors.frost2, bold = true },
  TelescopeMatching = { fg = M.colors.frost2, bold = true },
  TelescopeSelection = { bg = M.colors.highlight_high, fg = M.colors.text },
  TelescopeSelectionCaret = { fg = M.colors.frost3 },
  
  -- General high-contrast improvements
  Comment = { fg = M.colors.muted, italic = true }, -- Uses the brighter muted color
  NonText = { fg = "#808A98" }, -- Brighter than default
  SpecialKey = { fg = "#808A98" },
  Conceal = { fg = M.colors.muted },
  Directory = { fg = M.colors.frost2, bold = true },
  IncSearch = { bg = M.colors.gold, fg = M.colors.base, bold = true },
  Search = { bg = M.colors.highlight_high, fg = M.colors.text },
  MoreMsg = { fg = M.colors.pine, bold = true },
  Question = { fg = M.colors.frost2, bold = true },
  Title = { fg = M.colors.frost3, bold = true },
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
