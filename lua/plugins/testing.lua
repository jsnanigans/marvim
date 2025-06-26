-- Unit test support for multiple frameworks
-- Comprehensive testing integration for MARVIM

return {
  -- Neotest - Modern test runner interface
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",               -- Required for neotest
      
      -- Test adapters for different frameworks
      "nvim-neotest/neotest-jest",           -- JavaScript/TypeScript (Jest)
      "marilari88/neotest-vitest",           -- JavaScript/TypeScript (Vitest)
      "nvim-neotest/neotest-python",        -- Python (pytest, unittest)
      "nvim-neotest/neotest-go",            -- Go
      "nvim-neotest/neotest-plenary",       -- Lua (for neovim plugin testing)
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run All Tests" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Test Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Test Watch" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop Tests" },
      { "<leader>tc", function() require("neotest").run.run({ strategy = "dap", suite = false }) end, desc = "Debug Test Class" },
      
      -- Navigation
      { "]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next Failed Test" },
      { "[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev Failed Test" },
    },
    opts = function()
      return {
        adapters = {
          -- Jest for JavaScript/TypeScript
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          
          -- Vitest for modern JS/TS projects
          require("neotest-vitest")({
            vitestCommand = "npx vitest run",
            env = { 
              CI = true,
              VITEST_REPORTER = "verbose"
            },
          }),
          
          -- Python testing
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG", "--quiet" },
            runner = "pytest",
            python = "python3",
          }),
          
          -- Go testing
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" }
          }),
          
          -- Lua/Neovim plugin testing
          require("neotest-plenary"),
        },
        
        -- UI configuration
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },
        
        output = {
          enabled = true,
          open_on_run = "short",
        },
        
        quickfix = {
          enabled = false,
        },
        
        summary = {
          enabled = true,
          animated = true,
          follow = true,
          expand_errors = true,
          mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            output = "o",
            short = "O",
            attach = "a",
            jumpto = "i",
            stop = "u",
            run = "r",
            debug = "d",
            mark = "m",
            run_marked = "R",
            debug_marked = "D",
            clear_marked = "M",
            target = "t",
            clear_target = "T",
            next_failed = "J",
            prev_failed = "K",
          },
        },
        
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "✖",      -- Simple X for failed tests
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "✔",      -- Simple checkmark for passed tests
          running = "●",     -- Solid circle for running tests
          running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          skipped = "○",     -- Empty circle for skipped tests
          unknown = "?",     -- Question mark for unknown status
          watching = "👁",    -- Eye icon for watched tests
        },
        
        floating = {
          border = "rounded",
          max_height = 0.6,
          max_width = 0.6,
          options = {},
        },
        
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },

  -- Coverage.nvim - Test coverage visualization
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "Coverage",
      "CoverageLoad",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
    },
    keys = {
      { "<leader>tcv", "<cmd>Coverage<cr>", desc = "Toggle Coverage" },
      { "<leader>tcs", "<cmd>CoverageSummary<cr>", desc = "Coverage Summary" },
      { "<leader>tcl", "<cmd>CoverageLoad<cr>", desc = "Load Coverage" },
      { "<leader>tcc", "<cmd>CoverageClear<cr>", desc = "Clear Coverage" },
    },
    opts = {
      auto_reload = true,
      lcov_file = "./coverage/lcov.info",
      commands = true,
      highlights = {
        covered = { fg = "#C3E88D" },
        uncovered = { fg = "#F07178" },
      },
      signs = {
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
      },
      summary = {
        min_coverage = 80.0,
      },
      lang = {
        python = {
          coverage_file = "./coverage.xml",
        },
        javascript = {
          coverage_file = "./coverage/lcov.info",
        },
        typescript = {
          coverage_file = "./coverage/lcov.info",
        },
      },
    },
  },

  -- Ultest - Additional test runner (alternative interface)
  {
    "rcarriga/vim-ultest",
    enabled = false, -- Disabled by default, enable if preferred
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

  -- Overseer integration for test tasks
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
    keys = {
      { "<leader>tor", "<cmd>OverseerRun<cr>", desc = "Run Task" },
      { "<leader>tot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
      { "<leader>toa", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
    },
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
      
      -- Register custom test runner template
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