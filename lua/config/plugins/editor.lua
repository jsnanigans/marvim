-- Editor enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

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

  -- Oil file manager with simple config
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    opts = {
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
      default_file_explorer = false,
    },
    keys = function()
      return require("config.keymaps").oil_keys
    end,
  },

  -- Illuminate with basic config
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = function()
      return require("config.keymaps").illuminate_keys
    end,
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.editor.snacks" },
  { import = "config.plugins.editor.mini" },
}
