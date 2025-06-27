return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerToggle",
      "OverseerOpen",
      "OverseerClose",
      "OverseerLoadBundle",
      "OverseerSaveBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerQuickAction",
      "OverseerTaskAction",
    },
    keys = function()
      return require("config.keymaps").overseer_keys
    end,
    opts = {
      templates = { "builtin", "user.test_runner" },
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
          ["q"] = "Close",
        },
      },
      form = {
        border = "rounded",
        win_opts = {
          winblend = 10,
        },
      },
      confirm = {
        border = "rounded",
        win_opts = {
          winblend = 10,
        },
      },
      task_win = {
        border = "rounded",
        win_opts = {
          winblend = 10,
        },
      },
    },
    config = function(_, opts)
      require("overseer").setup(opts)
      require("overseer").register_template({
        name = "test_runner",
        builder = function()
          local file = vim.fn.expand("%:p")
          local cmd = { vim.o.shell }
          if vim.o.shell == "cmd" then
            table.insert(cmd, "/c")
          else
            table.insert(cmd, "-c")
          end
          table.insert(cmd, "cd " .. vim.fn.shellescape(vim.fn.getcwd()))
          return {
            cmd = cmd,
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "javascript", "typescript", "python", "go", "rust", "lua" },
        },
      })
    end,
  },
}
