-- Testing framework plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Alternative test runner (disabled)
  {
    "rcarriga/vim-ultest",
    enabled = false,
    dependencies = { "vim-test/vim-test" },
    cmd = {
      "Ultest",
      "UltestSummary",
      "UltestNearest",
      "UltestDebug",
      "UltestLast",
      "UltestOutput",
    },
    keys = function()
      return require("config.keymaps").ultest_keys
    end,
    config = function()
      vim.g.ultest_use_pty = 1
      vim.g.ultest_output_on_line = 0
      vim.g.ultest_output_on_run = 0
      vim.g.ultest_max_threads = 4
    end,
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.testing.neotest" },
  { import = "config.plugins.testing.coverage" },
  { import = "config.plugins.testing.overseer" },
}
