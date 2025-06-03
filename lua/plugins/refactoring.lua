-- Refactoring tools for better code transformation
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("refactoring").setup({
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
    })

    -- Keymaps
    local keymap = vim.keymap.set

    -- Extract function
    keymap(
      {"x", "n"},
      "<leader>re",
      function() require("refactoring").refactor("Extract Function") end,
      { desc = "Extract Function" }
    )
    keymap(
      {"x", "n"},
      "<leader>rf",
      function() require("refactoring").refactor("Extract Function To File") end,
      { desc = "Extract Function To File" }
    )

    -- Extract variable
    keymap(
      "x",
      "<leader>rv",
      function() require("refactoring").refactor("Extract Variable") end,
      { desc = "Extract Variable" }
    )

    -- Inline
    keymap(
      {"n", "x"},
      "<leader>ri",
      function() require("refactoring").refactor("Inline Variable") end,
      { desc = "Inline Variable" }
    )

    -- Extract block
    keymap(
      "x",
      "<leader>rb",
      function() require("refactoring").refactor("Extract Block") end,
      { desc = "Extract Block" }
    )
    keymap(
      "x",
      "<leader>rbf",
      function() require("refactoring").refactor("Extract Block To File") end,
      { desc = "Extract Block To File" }
    )

    -- Print debugging
    keymap(
      "x",
      "<leader>rp",
      function() require("refactoring").debug.print_var() end,
      { desc = "Debug Print Variable" }
    )
    keymap(
      "n",
      "<leader>rP",
      function() require("refactoring").debug.printf({ below = false }) end,
      { desc = "Debug Printf" }
    )
    keymap(
      "n",
      "<leader>rpb",
      function() require("refactoring").debug.printf({ below = true }) end,
      { desc = "Debug Printf Below" }
    )

    -- Cleanup debug prints
    keymap(
      "n",
      "<leader>rpc",
      function() require("refactoring").debug.cleanup({}) end,
      { desc = "Cleanup Debug Prints" }
    )
  end,
}