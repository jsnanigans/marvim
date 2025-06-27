return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      use_icons = true,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      commit_log_panel = {
        win_config = {
          win_opts = {},
        },
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},
      keymaps = {
        disable_defaults = false,
        view = {
          ["<tab>"] = false,
          ["<s-tab>"] = false,
          ["gf"] = false,
          ["<C-w><C-f>"] = false,
          ["<C-w>gf"] = false,
          ["<leader>e"] = false,
          ["<leader>b"] = false,
          ["<leader>co"] = false,
          ["<leader>ct"] = false,
          ["<leader>cb"] = false,
          ["<leader>ca"] = false,
          ["dx"] = false,
          ["dX"] = false,
        },
        diff1 = {},
        diff2 = {},
        diff3 = {
          { { "n", "x" }, "2do", ":diffget //2<CR>" },
          { { "n", "x" }, "3do", ":diffget //3<CR>" },
        },
        diff4 = {
          { { "n", "x" }, "1do", ":diffget //1<CR>" },
          { { "n", "x" }, "2do", ":diffget //2<CR>" },
          { { "n", "x" }, "3do", ":diffget //3<CR>" },
          { { "n", "x" }, "4do", ":diffget //4<CR>" },
        },
        file_panel = {},
        file_history_panel = {},
        option_panel = {},
        help_panel = {},
      },
    },
  },
}
