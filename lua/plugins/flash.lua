-- Flash.nvim - Enhanced navigation with search labels and character motions
-- Optimized for speed and developer experience
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- Optimized labels for fastest finger access (home row + nearby keys)
    labels = "asdghklqwertyuiopzxcvbnmjf",
    
    -- Search configuration - optimized for speed
    search = {
      mode = "exact", -- Exact mode is fastest
      incremental = false, -- Disable incremental for speed
      trigger = "", -- Manual trigger only
      max_length = false,
      multi_window = true, -- Search across windows
      forward = true,
      wrap = true,
      mode_after = { "n", "t" }, -- Stay in normal/terminal mode
    },
    
    -- Jump configuration - optimized for efficiency
    jump = {
      jumplist = true, -- Save to jumplist for <C-o>/<C-i>
      pos = "start", -- Jump to start of match
      history = false, -- Don't clutter search history
      register = false, -- Don't clutter registers
      nohlsearch = false, -- Keep highlights
      autojump = false, -- Manual selection for precision
    },
    
    -- Label configuration - optimized for visibility and speed
    label = {
      uppercase = true, -- Allow uppercase for more options
      exclude = "", -- Don't exclude any labels
      current = true, -- Label current position
      after = true, -- Show label after match
      before = false, -- Don't show before (cleaner)
      style = "overlay", -- Overlay style for clarity
      reuse = "lowercase", -- Reuse lowercase labels
      distance = true, -- Prioritize closer targets
      min_pattern_length = 0, -- Show labels immediately
      rainbow = {
        enabled = false, -- Disable rainbow for speed
        shade = 5,
      },
    },
    
    -- Highlight configuration - optimized for visibility
    highlight = {
      backdrop = true, -- Show backdrop for focus
      matches = true, -- Highlight matches
      priority = 5000, -- High priority
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent", 
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    
    action = nil,
    pattern = "",
    continue = false,
    
    -- Enhanced modes for different use cases
    modes = {
      -- Character motions (f, t, F, T) - optimized for speed
      char = {
        enabled = true,
        config = function(opts)
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
          opts.jump_labels = opts.jump_labels and vim.v.count == 0
          opts.multi_line = false -- Single line for f/t speed
        end,
        autohide = false,
        jump_labels = false, -- No labels for single chars
        multi_line = true,
        label = { exclude = "hjkliardc" }, -- Exclude movement keys
        keys = { "f", "F", "t", "T", ";", "," },
        char_actions = function(motion)
          return {
            [";"] = "next",
            [","] = "prev", 
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = false },
        jump = { register = false },
      },
      
      -- Treesitter selections - optimized for code navigation
      treesitter = {
        labels = "asdfghjklqwertyuiop", -- Home row priority
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
      
      treesitter_search = {
        jump = { pos = "range" },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = true, style = "inline" },
      },
    },
  },
  
  -- Optimized keybindings for maximum speed and minimal conflicts
  keys = {
    -- Primary motion keys - single key for maximum speed
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    
    -- Operator-pending mode for text objects
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    
    -- Command mode flash toggle
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    
    -- Additional speed optimizations
    { "<leader>s", mode = { "n" }, function() 
      require("flash").jump({
        search = { mode = "search", max_length = false },
        label = { after = { 0, 0 } },
        pattern = "^"
      })
    end, desc = "Flash to line start" },
    
    { "<leader>S", mode = { "n" }, function()
      require("flash").jump({
        search = { mode = "search", max_length = false },
        label = { after = { 0, 0 } },
        pattern = "."
      })
    end, desc = "Flash to any character" },
  },
  
  config = function(_, opts)
    require("flash").setup(opts)
    
    -- Custom highlight groups for better visibility
    vim.api.nvim_set_hl(0, "FlashMatch", { 
      fg = "#ff9e64", 
      bg = "#1a1b26",
      bold = true, 
      nocombine = true 
    })
    
    vim.api.nvim_set_hl(0, "FlashLabel", { 
      fg = "#1a1b26", 
      bg = "#ff007c", 
      bold = true, 
      nocombine = true 
    })
    
    vim.api.nvim_set_hl(0, "FlashCurrent", { 
      fg = "#1a1b26", 
      bg = "#7aa2f7", 
      bold = true, 
      nocombine = true 
    })
    
    vim.api.nvim_set_hl(0, "FlashBackdrop", { 
      fg = "#545c7e",
      nocombine = true
    })
  end,
} 