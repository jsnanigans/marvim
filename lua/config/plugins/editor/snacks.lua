return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        sources = {
          grep = {
            cmd = "rg",
            args = {
              "--column",
              "--line-number",
              "--no-heading",
              "--color=never",
              "--smart-case",
              "--with-filename",
            },
          },
          files = {
            cmd = "fd",
            args = {
              "--type=file",
              "--hidden",
              "--exclude",
              "node_modules",
              "--exclude",
              ".git",
              "--exclude",
              "dist",
              "--exclude",
              "build",
              "--exclude",
              ".next",
              "--exclude",
              "coverage",
              "--exclude",
              "__pycache__",
              "--exclude",
              ".pytest_cache",
              "--exclude",
              ".DS_Store",
            },
          },
        },
        layout = {
          preset = "ivy",
        },
        icons = {
          enabled = true,
        },
        ui = {
          select = true,
        },
        win = {
          input = {
            keys = {
              ["<C-c>"] = { "close", mode = { "n", "i" } },
              ["<C-j>"] = { "move_down", mode = { "i", "n" } },
              ["<C-k>"] = { "move_up", mode = { "i", "n" } },
            },
          },
          list = {
            cursorline = true,
          },
        },
      },
    },
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
    end,
  },
}
