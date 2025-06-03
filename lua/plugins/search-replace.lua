-- Grug-far.nvim - Advanced search and replace with live preview
return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar" },
  keys = {
    { "<leader>sr", desc = "Search and replace" },
    { "<leader>sw", desc = "Search and replace current word" },
    { "<leader>sf", desc = "Search and replace in current file" },
    { "<leader>sr", mode = "v", desc = "Search and replace selection" },
  },
  config = function()
    require("grug-far").setup({
      -- Options, see Configuration section below
      -- There are no required options, everything has defaults
      windowCreationCommand = "vsplit",
      
      -- Keybindings for the grug-far buffer
      keymaps = {
        replace = { n = "<leader>r" },
        qflist = { n = "<leader>q" },
        syncLocations = { n = "<leader>s" },
        syncLine = { n = "<leader>l" },
        close = { n = "<leader>c" },
        historyOpen = { n = "<leader>t" },
        historyAdd = { n = "<leader>a" },
        refresh = { n = "<leader>f" },
        openLocation = { n = "<leader>o" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
        abort = { n = "<leader>b" },
        help = { n = "g?" },
      },
      
      -- Default search options
      searchOnInsertLeave = false,
      
      -- Icons (requires a patched font)
      icons = {
        enabled = true,
        actionEntryBullet = "  ",
        searchInput = " ",
        replaceInput = " ",
        filesFilterInput = " ",
        flagsInput = " ",
        resultLocationPrefix = " ",
        resultIndentOn = "├ ",
        resultIndentOff = "│ ",
        historyTitle = " ",
        helpTitle = " ? ",
      },
      
      -- Engine configuration (ripgrep is default)
      engine = "ripgrep",
      
      -- Search in hidden files by default
      searchInHiddenFiles = false,
      
      -- Max number of search results
      maxSearchMatches = 2000,
      
      -- Max number of replace results  
      maxReplaceMatches = 2000,
    })

    -- Keymaps for opening grug-far
    local keymap = vim.keymap.set
    
    -- Open grug-far with current word
    keymap("n", "<leader>sr", function()
      local grug = require("grug-far")
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.open({
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        }
      })
    end, { desc = "Search and replace" })
    
    -- Open grug-far with current word under cursor
    keymap("n", "<leader>sw", function()
      local grug = require("grug-far")
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.open({
        transient = true,
        prefills = {
          search = vim.fn.expand("<cword>"),
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        }
      })
    end, { desc = "Search and replace current word" })
    
    -- Open grug-far with current word in current file only
    keymap("n", "<leader>sf", function()
      local grug = require("grug-far")
      grug.open({
        transient = true,
        prefills = {
          search = vim.fn.expand("<cword>"),
          paths = vim.fn.expand("%"),
        }
      })
    end, { desc = "Search and replace in current file" })
    
    -- Open grug-far with visual selection
    keymap("v", "<leader>sr", function()
      local grug = require("grug-far")
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.with_visual_selection({
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        }
      })
    end, { desc = "Search and replace selection" })
  end,
} 