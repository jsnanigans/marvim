-- Essential utilities for power users
return {
  -- Mini.icons - Modern icon provider for better which-key support
  {
    "echasnovski/mini.icons",
    event = "VeryLazy",
    opts = {},
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Which-key - Never forget a keybinding again
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      preset = "classic",
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        mappings = true,
      },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      win = {
        border = "rounded",
        padding = { 1, 2 }, -- top/bottom, left/right
        title = true,
        title_pos = "center",
        zindex = 1000,
      },
      layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Register group descriptions
      wk.add({
        -- Root groups
        { "<leader>b",     group = "+buffer" },
        { "<leader>c",     group = "+code" },
        { "<leader>d",     group = "+debug/test" },
        { "<leader>e",     desc = "Show diagnostic" },
        { "<leader>f",     group = "+find/file" },
        { "<leader>g",     group = "+git" },
        { "<leader>h",     group = "+git-hunk" },
        { "<leader>l",     group = "+lsp" },
        { "<leader>n",     desc = "Clear search highlights" },
        { "<leader>p",     group = "+project/session" },
        { "<leader>q",     desc = "Diagnostic loclist" },
        { "<leader>r",     group = "+refactor/replace" },
        { "<leader>s",     group = "+search/substitute" },
        { "<leader>t",     group = "+terminal/test/tab" },
        { "<leader>u",     group = "+ui/toggle" },
        { "<leader>w",     group = "+window" },
        { "<leader>x",     group = "+diagnostics/quickfix" },
        { "<leader>z",     group = "+fzf" },
        { "<leader><tab>", group = "+tabs" },
        { "<leader>L",     desc = "Lazy plugin manager" },
        { "<leader>Q",     desc = "Force quit all" },
        { "<leader>S",     desc = "Substitute to end of line" },

        -- Sub-groups
        { "<leader>ts",    group = "+typescript" },
        { "<leader>gh",    group = "+github" },
        { "<leader>gd",    group = "+diff" },
        { "<leader>dP",    group = "+profile" },

        -- Motion groups
        { "g",             group = "+goto" },
        { "[",             group = "+prev" },
        { "]",             group = "+next" },
        { "z",             group = "+fold/spell" },

        -- Text object descriptions
        { "s",             desc = "Flash motion",                            mode = { "n", "x", "o" } },
        { "S",             desc = "Flash treesitter",                        mode = { "n", "x", "o" } },
        { "gs",            desc = "Leap motion",                             mode = { "n", "x", "o" } },

        -- Standalone keybindings
        { "<C-s>",         desc = "Save file",                               mode = { "i", "x", "n", "s" } },
        { "<C-a>",         desc = "Select all" },
        { "<C-.>",         desc = "Toggle to previous buffer" },
        { "H",             desc = "Go to first non-blank character" },
        { "L",             desc = "Go to end of line" },
        { "K",             desc = "Hover Documentation" },
        { "*",             desc = "Search word under cursor (stay)" },
        { "#",             desc = "Search word under cursor backward (stay)" },
      })
    end,
  },

  -- Surround - Master of text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- NOTE: Commenting is handled by ts-comments.nvim plugin (see comments.lua)

  -- Auto pairs - Smart bracket completion
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Indent blankline - Beautiful indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- Todo comments - Never miss a TODO again
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local todo_comments = require("todo-comments")

      local keymap = vim.keymap.set
      keymap("n", "]T", function()
        todo_comments.jump_next()
      end, { desc = "Next todo comment" })

      keymap("n", "[T", function()
        todo_comments.jump_prev()
      end, { desc = "Previous todo comment" })

      todo_comments.setup()
    end,
  },

  -- Trouble - Beautiful diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Open/close trouble list" },
      { "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble workspace diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                   desc = "Open trouble quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                  desc = "Open trouble location list" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>",                     desc = "Open todos in trouble" },
    },
  },

  -- Substitute - Enhanced substitute operations
  {
    "gbprod/substitute.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local substitute = require("substitute")

      substitute.setup()

      local keymap = vim.keymap.set
      keymap("n", "<leader>s", substitute.operator, { desc = "Substitute with motion" })
      keymap("n", "<leader>ss", substitute.line, { desc = "Substitute line" })
      keymap("n", "<leader>S", substitute.eol, { desc = "Substitute to end of line" })
      keymap("x", "<leader>s", substitute.visual, { desc = "Substitute in visual mode" })
    end,
  },

  -- Vim-sleuth - Automatic indentation detection
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Alpha - Beautiful dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Set header
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ███╗ █████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗ ████║██╔══██╗██╔══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔████╔██║███████║██████╔╝██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╔╝██║██╔══██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚═╝ ██║██║  ██║██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
        "                                                     ",
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
        dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
        dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
        dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("SPC fr", "󰄉  > Recent Files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("SPC L", "󰒲  > Plugin Manager", "<cmd>Lazy<CR>"),
        dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
      }

      -- Send config to alpha
      alpha.setup(dashboard.opts)

      -- Disable folding on alpha buffer
      vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
  },
}
