return {
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
    keys = {
      { "<leader>tul", "<cmd>UltestLast<cr>", desc = "Run Last Test (Ultest)" },
      { "<leader>tun", "<cmd>UltestNearest<cr>", desc = "Run Nearest Test (Ultest)" },
      { "<leader>tus", "<cmd>UltestSummary<cr>", desc = "Test Summary (Ultest)" },
      { "<leader>tuo", "<cmd>UltestOutput<cr>", desc = "Test Output (Ultest)" },
    },
    config = function()
      vim.g.ultest_use_pty = 1
      vim.g.ultest_output_on_line = 0
      vim.g.ultest_output_on_run = 0
      vim.g.ultest_max_threads = 4
    end,
  },
}