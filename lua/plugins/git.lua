-- Git integration plugins
-- Comprehensive git workflow with enhanced UI and conflict resolution

return {
  -- Core git signs integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      on_attach = function(buffer)
        local keymaps = require("config.keymaps")
        keymaps.setup_gitsigns_keybindings(buffer)
      end,
    },
  },

  -- LazyGit integration for enhanced git workflow
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

  -- Enhanced git conflict resolution
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

  -- Enhanced git blame functionality
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

  -- Git diff view (optional enhancement)
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
        }
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