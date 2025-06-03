-- Neotest - Testing framework for Neovim
return {
  "nvim-neotest/neotest",
  cmd = { "Neotest" },
  keys = {
    -- Core test running
    { "<leader>tt", desc = "Run nearest test" },
    { "<leader>tf", desc = "Run tests in current file" },
    { "<leader>tp", desc = "Run all tests in project" },
    { "<leader>ta", desc = "Run all tests in workspace" },
    
    -- Re-running tests
    { "<leader>tl", desc = "Re-run last test" },
    { "<leader>tF", desc = "Re-run only failed tests" },
    
    -- Debugging
    { "<leader>td", desc = "Debug nearest test" },
    { "<leader>tD", desc = "Debug last test" },
    
    -- Watch mode
    { "<leader>tw", desc = "Toggle watch mode for nearest test" },
    { "<leader>tW", desc = "Toggle watch mode for file" },
    { "<leader>tP", desc = "Toggle watch mode for project" },
    
    -- UI
    { "<leader>tS", desc = "Toggle test summary window" },
    { "<leader>to", desc = "Show test output" },
    { "<leader>tO", desc = "Toggle test output panel" },
    
    -- Navigation
    { "[t", desc = "Jump to previous failed test" },
    { "]t", desc = "Jump to next failed test" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/nvim-nio",
    -- Language-specific adapters
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-python",
    "rouge8/neotest-rust",
    "nvim-neotest/neotest-go",
  },
  config = function()
    local neotest = require("neotest")
    local project_utils = require("config.project-utils")
    
    neotest.setup({
      adapters = {
        -- JavaScript/TypeScript testing
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(path)
            -- Always use project root for consistent test execution
            return project_utils.find_project_root()
          end,
        }),
        require("neotest-vitest")({
          vitestCommand = "npm exec vitest",
          env = { CI = true },
          cwd = function(path)
            -- Always use project root for consistent test execution
            return project_utils.find_project_root()
          end,
        }),
        
        -- Python testing
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
          python = "python3",
        }),
        
        -- Rust testing
        require("neotest-rust")({
          args = { "--no-capture" },
        }),
        
        -- Go testing
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" },
        }),
      },
      
      -- Global configuration
      discovery = {
        enabled = true,
        concurrent = 5,
      },
      
      running = {
        concurrent = true,
      },
      
      summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_errors = true,
        open = "botright vsplit | vertical resize 50",
      },
      
      output = {
        enabled = true,
        open_on_run = "short",
      },
      
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      
      quickfix = {
        enabled = true,
        open = false,
      },
      
      status = {
        enabled = true,
        virtual_text = false,
        signs = true,
      },
      
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      
      -- Icons for test states
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "",
        running = "",
        running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
        skipped = "",
        unknown = "",
        watching = "",
      },
      
      -- Floating window configuration
      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      
      -- Highlights
      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        marked = "NeotestMarked",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        select_win = "NeotestWinSelect",
        skipped = "NeotestSkipped",
        target = "NeotestTarget",
        test = "NeotestTest",
        unknown = "NeotestUnknown",
        watching = "NeotestWatching",
      },
    })

    -- Keymaps
    local keymap = vim.keymap.set
    
    -- Test running - Core commands
    keymap("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
    keymap("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run tests in current file" })
    keymap("n", "<leader>tp", function() 
      local root = project_utils.find_project_root()
      neotest.run.run(root)
    end, { desc = "Run all tests in project" })
    keymap("n", "<leader>ta", function() neotest.run.run(vim.fn.getcwd()) end, { desc = "Run all tests in workspace" })
    
    -- Test re-running
    keymap("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Re-run last test" })
    keymap("n", "<leader>tF", function() 
      -- Run only failed tests from last run
      for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
        neotest.run.run({ adapter = adapter_id, status = "failed" })
      end
    end, { desc = "Re-run only failed tests" })
    
    -- Test debugging
    keymap("n", "<leader>td", function() neotest.run.run({strategy = "dap"}) end, { desc = "Debug nearest test" })
    keymap("n", "<leader>tD", function() neotest.run.run_last({strategy = "dap"}) end, { desc = "Debug last test" })
    
    -- Test management
    keymap("n", "<leader>ts", function() neotest.run.stop() end, { desc = "Stop running tests" })
    keymap("n", "<leader>tk", function() neotest.run.stop() end, { desc = "Kill running tests (alias)" })
    keymap("n", "<leader>tA", function() neotest.run.attach() end, { desc = "Attach to running test" })
    
    -- Watch mode
    keymap("n", "<leader>tw", function() neotest.watch.toggle() end, { desc = "Toggle watch mode for nearest test" })
    keymap("n", "<leader>tW", function() neotest.watch.toggle(vim.fn.expand("%")) end, { desc = "Toggle watch mode for file" })
    keymap("n", "<leader>tP", function() 
      local root = project_utils.find_project_root()
      neotest.watch.toggle(root)
    end, { desc = "Toggle watch mode for project" })
    
    -- Test UI and output
    keymap("n", "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end, { desc = "Show test output" })
    keymap("n", "<leader>tO", function() neotest.output_panel.toggle() end, { desc = "Toggle test output panel" })
    keymap("n", "<leader>tS", function() neotest.summary.toggle() end, { desc = "Toggle test summary window" })
    keymap("n", "<leader>tm", function() neotest.summary.mark() end, { desc = "Mark test in summary" })
    keymap("n", "<leader>tM", function() neotest.summary.clear_marked() end, { desc = "Clear marked tests" })
    keymap("n", "<leader>tR", function() neotest.summary.run_marked() end, { desc = "Run marked tests" })
    
    -- Test navigation
    keymap("n", "[t", function() neotest.jump.prev({ status = "failed" }) end, { desc = "Jump to previous failed test" })
    keymap("n", "]t", function() neotest.jump.next({ status = "failed" }) end, { desc = "Jump to next failed test" })
    keymap("n", "[T", function() neotest.jump.prev() end, { desc = "Jump to previous test" })
    keymap("n", "]T", function() neotest.jump.next() end, { desc = "Jump to next test" })
    
    -- Quick test status
    keymap("n", "<leader>ti", function()
      local summary = neotest.state.status_counts(project_utils.find_project_root())
      if summary then
        local total = summary.total or 0
        local passed = summary.passed or 0
        local failed = summary.failed or 0
        local skipped = summary.skipped or 0
        local running = summary.running or 0
        
        vim.notify(string.format(
          "Test Status:\n  Total: %d\n  ✓ Passed: %d\n  ✗ Failed: %d\n  ○ Skipped: %d\n  ⟳ Running: %d",
          total, passed, failed, skipped, running
        ), vim.log.levels.INFO, { title = "Test Results" })
      else
        vim.notify("No test results available", vim.log.levels.WARN)
      end
    end, { desc = "Show test status info" })
  end,
} 