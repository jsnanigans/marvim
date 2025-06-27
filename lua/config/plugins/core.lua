-- Core plugins that are essential for the configuration

return {
  -- Essential dependencies
  { "folke/lazy.nvim", version = false },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Session persistence
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = function()
      return require("config.keymaps").persistence_keys
    end,
    opts = {},
  },

  -- Better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- Which-key (kept separate due to size)
  { import = "config.plugins.core.which-key" },
}
