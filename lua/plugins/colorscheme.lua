-- Rosé Pine - All natural pine, faux fur and a bit of soho vibes for the classy minimalist
return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000, -- Make sure to load this before all the other start plugins
  lazy = false, -- Make sure we load this during startup
  
  opts = {
    variant = "auto", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn (when dark_variant is used)
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
      terminal = true,
      legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
      migrations = true, -- Handle deprecated options automatically
    },

    styles = {
      bold = true,
      italic = true,
      transparency = false, -- Can be enabled for transparent terminals
    },

    groups = {
      border = "muted",
      link = "iris",
      panel = "surface",

      error = "love",
      hint = "iris",
      info = "foam",
      note = "pine",
      todo = "rose",
      warn = "gold",

      git_add = "foam",
      git_change = "rose",
      git_delete = "love",
      git_dirty = "rose",
      git_ignore = "muted",
      git_merge = "iris",
      git_rename = "pine",
      git_stage = "iris",
      git_text = "rose",
      git_untracked = "subtle",

      h1 = "iris",
      h2 = "foam",
      h3 = "rose",
      h4 = "gold",
      h5 = "pine",
      h6 = "foam",
    },

    -- Custom highlight groups for better integration
    highlight_groups = {
      -- Enhanced visibility for which-key and similar plugins
      WhichKey = { fg = "iris" },
      WhichKeyGroup = { fg = "foam" },
      WhichKeyDesc = { fg = "text" },
      WhichKeySeparator = { fg = "subtle" },
      WhichKeyFloat = { bg = "surface" },
      
      -- Better LSP diagnostics visibility
      DiagnosticError = { fg = "love" },
      DiagnosticWarn = { fg = "gold" },
      DiagnosticInfo = { fg = "foam" },
      DiagnosticHint = { fg = "iris" },
      
      -- Enhanced telescope colors
      TelescopeSelection = { fg = "text", bg = "highlight_med" },
      TelescopeSelectionCaret = { fg = "rose" },
      TelescopeMatching = { fg = "gold" },
      TelescopePromptPrefix = { fg = "pine" },
      
      -- Better git signs
      GitSignsAdd = { fg = "foam" },
      GitSignsChange = { fg = "rose" },
      GitSignsDelete = { fg = "love" },
      
      -- Enhanced statusline
      StatusLine = { fg = "text", bg = "surface" },
      StatusLineNC = { fg = "subtle", bg = "surface" },
      
      -- Better visual selection
      Visual = { bg = "highlight_med" },
      
      -- Enhanced completion menu
      Pmenu = { fg = "text", bg = "surface" },
      PmenuSel = { fg = "base", bg = "iris" },
      PmenuSbar = { bg = "highlight_low" },
      PmenuThumb = { bg = "highlight_med" },
      
      -- Better folds
      Folded = { fg = "subtle", bg = "surface" },
      FoldColumn = { fg = "muted" },
      
      -- Enhanced search
      Search = { fg = "base", bg = "gold" },
      IncSearch = { fg = "base", bg = "rose" },
      
      -- Better indent guides
      IndentBlanklineChar = { fg = "highlight_low" },
      IndentBlanklineContextChar = { fg = "highlight_med" },
      
      -- Enhanced floating windows
      NormalFloat = { fg = "text", bg = "surface" },
      FloatBorder = { fg = "muted", bg = "surface" },
      
      -- Better tabline
      TabLine = { fg = "subtle", bg = "surface" },
      TabLineFill = { bg = "base" },
      TabLineSel = { fg = "text", bg = "overlay" },
    },

    before_highlight = function(group, highlight, palette)
      -- Ensure consistent transparency handling
      if vim.g.rose_pine_transparency and highlight.bg then
        if highlight.bg == palette.base or highlight.bg == palette.surface then
          highlight.bg = "NONE"
        end
      end
    end,
  },
  
  config = function(_, opts)
    require("rose-pine").setup(opts)
    
    -- Set the colorscheme
    vim.cmd("colorscheme rose-pine")
    
    -- Create user commands for easy theme switching
    vim.api.nvim_create_user_command("RosePineMain", function()
      vim.cmd("colorscheme rose-pine-main")
    end, { desc = "Switch to Rosé Pine Main" })
    
    vim.api.nvim_create_user_command("RosePineMoon", function()
      vim.cmd("colorscheme rose-pine-moon")
    end, { desc = "Switch to Rosé Pine Moon" })
    
    vim.api.nvim_create_user_command("RosePineDawn", function()
      vim.cmd("colorscheme rose-pine-dawn")
    end, { desc = "Switch to Rosé Pine Dawn" })
    
    -- Toggle transparency
    vim.api.nvim_create_user_command("RosePineToggleTransparency", function()
      vim.g.rose_pine_transparency = not vim.g.rose_pine_transparency
      require("rose-pine").setup(opts)
      vim.cmd("colorscheme rose-pine")
    end, { desc = "Toggle Rosé Pine transparency" })
  end,
}