-- Editor enhancement plugins
-- Plugin files with 18+ lines get their own file, smaller ones are consolidated here

return {
  -- Fast navigation with flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Smart commenting
  {
    "numToStr/Comment.nvim",
    opts = {
      ignore = "^$",
    },
  },

  -- File navigation with harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    },
  },

  -- Larger plugins kept in separate files
  { import = "config.plugins.editor.oil" },
  { import = "config.plugins.editor.illuminate" },
  { import = "config.plugins.editor.snacks" },
  { import = "config.plugins.editor.mini" },
}