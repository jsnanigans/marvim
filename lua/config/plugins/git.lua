-- Git integration plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" }
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },

  -- Git blame with simple config
  {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      enabled = false,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
      highlight_group = "Comment",
      set_extmark_options = {
        hl_mode = "combine",
      },
      display_virtual_text = true,
      ignored_filetypes = { "gitcommit", "gitrebase", "gitconfig" },
      delay = 1000,
    },
  },

  -- Git conflicts with basic mappings
  {
    "akinsho/git-conflict.nvim",
    version = "^1.0.0",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      default_mappings = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
        ancestor = "DiffChange",
      },
    },
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.git.gitsigns" },
  { import = "config.plugins.git.diffview" },
}
