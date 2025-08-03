local M = {}

-- ============================================================================
-- ROSE PINE COLORS
-- ============================================================================

-- Get the current background and variant
local function get_variant()
  if vim.o.background == "light" then
    return "dawn"
  else
    -- You can change this to "moon" if preferred
    return "main"
  end
end

-- Rose Pine color palettes
local palettes = {
  main = {
    -- Base colors
    base = "#191724",
    surface = "#1f1d2e",
    overlay = "#26233a",
    highlight_low = "#21202e",
    highlight_med = "#403d52",
    highlight_high = "#524f67",

    -- Text colors
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
  },
  moon = {
    -- Base colors
    base = "#232136",
    surface = "#2a273f",
    overlay = "#393552",
    highlight_low = "#2a283e",
    highlight_med = "#44415a",
    highlight_high = "#56526e",

    -- Text colors
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",

    -- Accent colors
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ea9a97",
    pine = "#3e8fb0",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
  },
  dawn = {
    -- Base colors
    base = "#faf4ed",
    surface = "#fffaf3",
    overlay = "#f2e9e1",
    highlight_low = "#f4ede8",
    highlight_med = "#dfdad9",
    highlight_high = "#cecacd",

    -- Text colors
    muted = "#9893a5",
    subtle = "#797593",
    text = "#575279",

    -- Accent colors
    love = "#b4637a",
    gold = "#ea9d34",
    rose = "#d7827e",
    pine = "#286983",
    foam = "#56949f",
    iris = "#907aa9",
  },
}

-- Get current variant colors
M.colors = palettes[get_variant()]

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
  LineNr = { fg = M.colors.subtle }, -- Use rose-pine subtle color
  LineNrAbove = { fg = M.colors.subtle },
  LineNrBelow = { fg = M.colors.subtle },
  CursorLineNr = { fg = M.colors.text, bold = true },
  
  -- Snacks picker highlights for better contrast
  SnacksPickerMatch = { fg = M.colors.iris, bold = true },
  SnacksPickerMatchBorder = { fg = M.colors.foam },
  SnacksPickerNormal = { fg = M.colors.text },
  SnacksPickerFaint = { fg = M.colors.subtle }, -- Use rose-pine subtle color
  SnacksPickerComment = { fg = M.colors.subtle }, -- Use rose-pine subtle color
  SnacksPickerSelection = { bg = M.colors.highlight_high, fg = M.colors.text },
  SnacksPickerSelectionBorder = { bg = M.colors.highlight_high, fg = M.colors.foam },
  
  -- Telescope-like highlights that snacks might also use
  TelescopeNormal = { fg = M.colors.text },
  TelescopePreviewLine = { bg = M.colors.highlight_high },
  TelescopePreviewMatch = { fg = M.colors.iris, bold = true },
  TelescopeMatching = { fg = M.colors.iris, bold = true },
  TelescopeSelection = { bg = M.colors.highlight_high, fg = M.colors.text },
  TelescopeSelectionCaret = { fg = M.colors.foam },
  
  -- General high-contrast improvements
  Comment = { fg = M.colors.muted, italic = true }, -- Uses rose-pine muted color
  NonText = { fg = M.colors.muted }, -- Use rose-pine muted color
  SpecialKey = { fg = M.colors.muted },
  Conceal = { fg = M.colors.muted },
  Directory = { fg = M.colors.foam, bold = true },
  IncSearch = { bg = M.colors.gold, fg = M.colors.base, bold = true },
  Search = { bg = M.colors.highlight_high, fg = M.colors.text },
  MoreMsg = { fg = M.colors.pine, bold = true },
  Question = { fg = M.colors.foam, bold = true },
  Title = { fg = M.colors.iris, bold = true },
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
      if vim.g.colors_name == "rose-pine" or vim.g.colors_name == "rose-pine-main" or vim.g.colors_name == "rose-pine-moon" or vim.g.colors_name == "rose-pine-dawn" then
        vim.schedule(function()
          M.set_highlights(M.ui_highlights)
        end)
      end
    end,
  })
end

return M
