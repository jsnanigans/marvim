-- Edgy.nvim - Window management and layout system
return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    -- Configure which windows should be managed by edgy
    bottom = {
      -- toggleterm / terminal
      {
        ft = "terminal",
        size = { height = 0.4 },
        filter = function(buf, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
      -- neotest output panel
      {
        ft = "neotest-output-panel",
        size = { height = 15 },
      },
      -- quickfix
      "qf",
      -- help
      {
        ft = "help",
        size = { height = 20 },
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
      -- grug-far
      {
        ft = "grug-far",
        size = { height = 0.4 },
      },
    },

    left = {
      -- Mini.files
      {
        title = "Mini.Files",
        ft = "minifiles",
        filter = function(buf)
          return vim.b[buf].minifiles_config ~= nil
        end,
        size = { width = 50 },
      },
      -- Neotest summary
      {
        title = "Neotest Summary",
        ft = "neotest-summary",
        size = { width = 50 },
      },
    },

    right = {
      -- Any right-side panels can go here
    },

    top = {
      -- Any top panels can go here
    },

    -- Global options
    options = {
    },

    -- Key mappings
    keys = {
      -- Increase width
      ["<c-Right>"] = function(win)
        win:resize("width", 2)
      end,
      -- Decrease width
      ["<c-Left>"] = function(win)
        win:resize("width", -2)
      end,
      -- Increase height
      ["<c-Up>"] = function(win)
        win:resize("height", 2)
      end,
      -- Decrease height
      ["<c-Down>"] = function(win)
        win:resize("height", -2)
      end,
    },

    -- Window configuration
    wo = {
      -- Setting to `true` will add a winbar to edgy windows
      winbar = false,
      winfixwidth = true,
      winfixheight = false,
      winhighlight = "",
      spell = false,
      signcolumn = "no",
    },

    -- Buffer-local options for edgy buffers
    bo = {},

    -- close edgy when all windows are hidden
    close_when_all_hidden = true,

    -- Don't show edgy windows in the tabline
    exclude_ft = { "qf" },

    -- override the default styles with new ones
    icons = {
      closed = " ",
      open = " ",
    },

    -- exit edgy when switching to one of these filetypes
    exit_when_last = {},

    -- enable this to debug edgy
    debug = false,
  },

  -- Custom keymaps
  keys = {
    {
      "<leader>ue",
      function()
        require("edgy").toggle()
      end,
      desc = "Edgy Toggle",
    },
    {
      "<leader>uE",
      function()
        require("edgy").select_window()
      end,
      desc = "Edgy Select Window",
    },
  },
}
