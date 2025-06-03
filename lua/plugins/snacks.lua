-- Snacks.nvim - Collection of useful utilities for Neovim
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = true,
  event = "VeryLazy",
  opts = {
    -- Enable/disable modules
    bigfile = { enabled = true },
    dashboard = { enabled = false }, -- We might have other dashboard plugins
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },

    -- Bigfile configuration - optimize for better performance
    bigfile = {
      notify = true, -- show notification when big file is opened
      size = 1.5 * 1024 * 1024, -- 1.5MB
      -- Options to apply when a big file is detected
      setup = function(ctx)
        vim.cmd([[NoMatchParen]])
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ""
        vim.opt_local.statuscolumn = ""
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.winbar = ""
        vim.schedule(function()
          vim.bo[ctx.buf].syntax = ctx.ft
        end)
      end,
    },

    -- Indent configuration
    indent = {
      indent = {
        char = "│",
        blank = " ",
      },
      scope = {
        char = "│",
        underline = false,
        only_current = false,
      },
      chunk = {
        char = {
          corner_top = "┌",
          corner_bottom = "└",
          horizontal = "─",
          vertical = "│",
          arrow = ">",
        },
        only_current = false,
      },
    },

    -- Notifier configuration
    notifier = {
      enabled = true,
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,
      sort = { "level", "added" },
      level = vim.log.levels.TRACE,
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
      },
      keep = function(notif)
        return vim.fn.getcmdpos() > 0
      end,
      style = "compact",
      top_down = true,
    },

    -- Quickfile configuration
    quickfile = {
      enabled = true,
    },

    -- Scroll configuration - optimized for smooth performance
    scroll = {
      spamming = 10, -- threshold for spamming detection
      -- what buffers to animate
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false
          and vim.bo[buf].buftype ~= "terminal"
      end,
    },

    -- Words configuration (highlighting word under cursor)
    words = {
      debounce = 200,
      enabled = true,
      notify_jump = false,
      notify_end = true,
      foldopen = true,
      jumplist = true,
      modes = { "n", "i", "c" },
    },
  },
  keys = {
    { "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
    { "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
    { "<leader>gb", function() require("snacks").git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git Browse" },
    { "<leader>gf", function() require("snacks").lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>gl", function() require("snacks").lazygit.log() end, desc = "Lazygit Log (cwd)" },
    { "<leader>cR", function() require("snacks").rename.rename_file() end, desc = "Rename File" },
    { "<c-/>", function() require("snacks").terminal() end, desc = "Toggle Terminal" },
    { "<c-_>", function() require("snacks").terminal() end, desc = "which_key_ignore" },
    { "]]", function() require("snacks").words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
  config = function(_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)

    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      snacks.debug.inspect(...)
    end
    _G.bt = function()
      snacks.debug.backtrace()
    end
    vim.print = _G.dd -- Override print to use snacks for `:=` command

    -- Create some toggle mappings
    snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    snacks.toggle.diagnostics():map("<leader>ud")
    snacks.toggle.line_number():map("<leader>ul")
    snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
    snacks.toggle.treesitter():map("<leader>uT")
    snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    snacks.toggle.inlay_hints():map("<leader>uh")
  end,
}
