-- UI enhancements for better visual experience
return {
  -- nvim-notify removed in favor of snacks.nvim notifier

  -- Better vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "Input:",
        title_pos = "left",
        insert_only = true,
        start_in_insert = true,
        border = "rounded",
        relative = "cursor",
        prefer_width = 40,
        width = nil,
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },
        buf_options = {},
        win_options = {
          wrap = false,
          list = true,
          listchars = "precedes:…,extends:…",
          sidescrolloff = 0,
        },
        mappings = {
          n = {
            ["<Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<Up>"] = "HistoryPrev",
            ["<Down>"] = "HistoryNext",
          },
        },
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin", "nui" },
        trim_prompt = true,
        telescope = require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }),
        nui = {
          position = "50%",
          size = nil,
          relative = "editor",
          border = {
            style = "rounded",
          },
          buf_options = {
            swapfile = false,
            filetype = "DressingSelect",
          },
          win_options = {
            winblend = 10,
          },
          max_width = 80,
          max_height = 40,
          min_width = 40,
          min_height = 10,
        },
        builtin = {
          show_numbers = true,
          border = "rounded",
          relative = "editor",
          buf_options = {},
          win_options = {
            cursorline = true,
            winblend = 10,
          },
          width = nil,
          max_width = { 140, 0.8 },
          min_width = { 40, 0.2 },
          height = nil,
          max_height = 0.9,
          min_height = { 10, 0.2 },
        },
      },
    },
  },

  -- Better quickfix/location list
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            ret = false
          end
          return ret
        end,
      },
      func_map = {
        drop = "o",
        openc = "O",
        split = "<C-s>",
        vsplit = "<C-v>",
        tab = "t",
        tabb = "T",
        tabc = "<C-t>",
        tabdrop = "",
        ptogglemode = "z,",
        pscrollup = "<C-b>",
        pscrolldown = "<C-f>",
        pscrollorig = "zo",
        prevfile = "<C-p>",
        nextfile = "<C-n>",
        prevhist = "<",
        nexthist = ">",
        lastleave = "''",
        stoggleup = "<S-Tab>",
        stoggledown = "<Tab>",
        stogglevm = "<Tab>",
        stogglebuf = "''",
        sclear = "z<Tab>",
        filter = "zn",
        filterr = "zN",
        fzffilter = "zf",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
  },

  -- Better winbar
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "netrw", "toggleterm" },
      show_dirname = true,
      show_basename = true,
      show_modified = false,
      modified = function(bufnr)
        return vim.bo[bufnr].modified
      end,
      show_navic = true,
      lead_custom_section = function()
        return " "
      end,
      custom_section = function()
        return " "
      end,
      context_follow_icon_color = false,
    },
    config = function(_, opts)
      require("barbecue").setup(opts)
      -- Defer autocmd creation until first buffer is actually displayed
      local autocmd_created = false
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("barbecue.setup", {}),
        once = true,
        callback = function()
          if not autocmd_created then
            autocmd_created = true
            vim.api.nvim_create_autocmd({
              "WinScrolled",
              "BufWinEnter",
              "CursorHold",
              "InsertLeave",
              "BufModifiedSet",
            }, {
              group = vim.api.nvim_create_augroup("barbecue.updater", {}),
              callback = function()
                require("barbecue.ui").update()
              end,
            })
          end
        end,
      })
    end,
  },

  -- neoscroll removed in favor of snacks.nvim scroll module
}