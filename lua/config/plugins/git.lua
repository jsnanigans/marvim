-- Git integration plugins
-- Plugin files with 18+ lines get their own file, smaller ones are consolidated here

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

  -- Larger plugins kept in separate files
  { import = "config.plugins.git.gitsigns" },
  { import = "config.plugins.git.conflicts" },
  { import = "config.plugins.git.blame" },
  { import = "config.plugins.git.diffview" },
}