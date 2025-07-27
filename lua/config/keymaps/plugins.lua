local M = {}

-- ============================================================================
-- PLUGIN KEY TABLES - Exported for use in plugin configs
-- ============================================================================

-- Persistence (session management)
M.persistence_keys = {
  {
    "<leader>qs",
    function()
      require("persistence").load()
    end,
    desc = "Restore Session",
  },
  {
    "<leader>ql",
    function()
      require("persistence").load({ last = true })
    end,
    desc = "Restore Last Session",
  },
  {
    "<leader>qd",
    function()
      require("persistence").stop()
    end,
    desc = "Don't Save Current Session",
  },
}

-- Copilot AI
M.copilot_keys = {
  { "<C-l>", 'copilot#Accept("\\<CR>")', mode = "i", expr = true, replace_keycodes = false, desc = "Accept Copilot" },
}

-- Undotree
M.undotree_keys = {
  { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
}

-- Debug Adapter Protocol (DAP)
M.dap_keys = {
  -- Basic debugging
  {
    "<leader>db",
    function()
      require("dap").toggle_breakpoint()
    end,
    desc = "Toggle Breakpoint",
  },
  {
    "<leader>dB",
    function()
      require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end,
    desc = "Conditional Breakpoint",
  },
  {
    "<leader>dc",
    function()
      require("dap").continue()
    end,
    desc = "Continue",
  },
  {
    "<leader>dC",
    function()
      require("dap").run_to_cursor()
    end,
    desc = "Run to Cursor",
  },
  {
    "<leader>dg",
    function()
      require("dap").goto_()
    end,
    desc = "Go to Line (no execute)",
  },
  {
    "<leader>di",
    function()
      require("dap").step_into()
    end,
    desc = "Step Into",
  },
  {
    "<leader>dj",
    function()
      require("dap").down()
    end,
    desc = "Down",
  },
  {
    "<leader>dk",
    function()
      require("dap").up()
    end,
    desc = "Up",
  },
  {
    "<leader>dl",
    function()
      require("dap").run_last()
    end,
    desc = "Run Last",
  },
  {
    "<leader>do",
    function()
      require("dap").step_out()
    end,
    desc = "Step Out",
  },
  {
    "<leader>dO",
    function()
      require("dap").step_over()
    end,
    desc = "Step Over",
  },
  {
    "<leader>dp",
    function()
      require("dap").pause()
    end,
    desc = "Pause",
  },
  {
    "<leader>dr",
    function()
      require("dap").repl.toggle()
    end,
    desc = "Toggle REPL",
  },
  {
    "<leader>ds",
    function()
      require("dap").session()
    end,
    desc = "Session",
  },
  {
    "<leader>dt",
    function()
      require("dap").terminate()
    end,
    desc = "Terminate",
  },
  {
    "<leader>dw",
    function()
      require("dap.ui.widgets").hover()
    end,
    desc = "Widgets",
  },
  -- DAP UI
  {
    "<leader>du",
    function()
      require("dapui").toggle({})
    end,
    desc = "Dap UI",
  },
  {
    "<leader>de",
    function()
      require("dapui").eval()
    end,
    desc = "Eval",
    mode = { "n", "v" },
  },
}

-- Overseer task runner
M.overseer_keys = {
  { "<leader>tor", "<cmd>OverseerRun<cr>", desc = "Run Task" },
  { "<leader>tot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
  { "<leader>toa", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
}

-- Ultest
M.ultest_keys = {
  { "<leader>tul", "<cmd>UltestLast<cr>", desc = "Run Last Test (Ultest)" },
  { "<leader>tun", "<cmd>UltestNearest<cr>", desc = "Run Nearest Test (Ultest)" },
  { "<leader>tus", "<cmd>UltestSummary<cr>", desc = "Test Summary (Ultest)" },
  { "<leader>tuo", "<cmd>UltestOutput<cr>", desc = "Test Output (Ultest)" },
}

-- Coverage
M.coverage_keys = {
  { "<leader>tcv", "<cmd>Coverage<cr>", desc = "Toggle Coverage" },
  { "<leader>tcs", "<cmd>CoverageSummary<cr>", desc = "Coverage Summary" },
  { "<leader>tcl", "<cmd>CoverageLoad<cr>", desc = "Load Coverage" },
  { "<leader>tcc", "<cmd>CoverageClear<cr>", desc = "Clear Coverage" },
}

-- Neotest
M.neotest_keys = {
  {
    "<leader>tt",
    function()
      require("neotest").run.run()
    end,
    desc = "Run Nearest Test",
  },
  {
    "<leader>tf",
    function()
      require("neotest").run.run(vim.fn.expand("%"))
    end,
    desc = "Run File Tests",
  },
  {
    "<leader>ta",
    function()
      require("neotest").run.run(vim.uv.cwd())
    end,
    desc = "Run All Tests",
  },
  {
    "<leader>ts",
    function()
      require("neotest").summary.toggle()
    end,
    desc = "Toggle Test Summary",
  },
  {
    "<leader>to",
    function()
      require("neotest").output.open({ enter = true, auto_close = true })
    end,
    desc = "Show Test Output",
  },
  {
    "<leader>tO",
    function()
      require("neotest").output_panel.toggle()
    end,
    desc = "Toggle Output Panel",
  },
  {
    "<leader>tw",
    function()
      require("neotest").watch.toggle(vim.fn.expand("%"))
    end,
    desc = "Toggle Test Watch",
  },
  {
    "<leader>tS",
    function()
      require("neotest").run.stop()
    end,
    desc = "Stop Tests",
  },
  {
    "]T",
    function()
      require("neotest").jump.next({ status = "failed" })
    end,
    desc = "Next Failed Test",
  },
  {
    "[T",
    function()
      require("neotest").jump.prev({ status = "failed" })
    end,
    desc = "Prev Failed Test",
  },
}

-- Todo Comments
M.todo_comments_keys = {
  {
    "]t",
    function()
      require("todo-comments").jump_next()
    end,
    desc = "Next Todo Comment",
  },
  {
    "[t",
    function()
      require("todo-comments").jump_prev()
    end,
    desc = "Previous Todo Comment",
  },
  { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
  { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
  {
    "<leader>st",
    function()
      require("snacks").picker.grep({ pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME" })
    end,
    desc = "Todo Comments",
  },
  {
    "<leader>sT",
    function()
      require("snacks").picker.grep({ pattern = "TODO|FIX|FIXME" })
    end,
    desc = "Todo/Fix/Fixme",
  },
}

-- Trouble
M.trouble_keys = {
  {
    "<leader>xx",
    function()
      require("trouble").toggle("document_diagnostics")
    end,
    desc = "Document Diagnostics (Trouble)",
  },
  {
    "<leader>xX",
    function()
      require("trouble").toggle("workspace_diagnostics")
    end,
    desc = "Workspace Diagnostics (Trouble)",
  },
  {
    "<leader>xL",
    function()
      require("trouble").toggle("loclist")
    end,
    desc = "Location List (Trouble)",
  },
  {
    "<leader>xQ",
    function()
      require("trouble").toggle("quickfix")
    end,
    desc = "Quickfix List (Trouble)",
  },
  {
    "[q",
    function()
      require("trouble").prev({ skip_groups = true, jump = true })
    end,
    desc = "Previous Trouble/Quickfix Item",
  },
  {
    "]q",
    function()
      require("trouble").next({ skip_groups = true, jump = true })
    end,
    desc = "Next Trouble/Quickfix Item",
  },
}

-- Conform formatting
M.conform_keys = {
  {
    "<leader>cF",
    function()
      require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
    end,
    desc = "Format Injected Langs",
  },
}

-- LuaSnip (complex keymaps that need special handling)
M.luasnip_keys = {
  {
    "<Tab>",
    function()
      local luasnip = require("luasnip")
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        return "<Tab>"
      end
    end,
    mode = { "i", "s" },
    expr = true,
    desc = "Jump Next or Tab",
  },
  {
    "<S-Tab>",
    function()
      local luasnip = require("luasnip")
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        return "<S-Tab>"
      end
    end,
    mode = { "i", "s" },
    expr = true,
    desc = "Jump Previous",
  },
}

-- Treesitter
M.treesitter_keys = {
  {
    "<c-space>",
    function()
      require("nvim-treesitter.incremental_selection").node_incremental()
    end,
    desc = "Increment Selection",
  },
  {
    "<bs>",
    function()
      require("nvim-treesitter.incremental_selection").node_decremental()
    end,
    mode = "v",
    desc = "Decrement Selection",
  },
}

-- Illuminate
M.illuminate_keys = {
  {
    "]]i",
    function()
      require("illuminate").goto_next_reference(false)
    end,
    desc = "Next Reference",
  },
  {
    "[[i",
    function()
      require("illuminate").goto_prev_reference(false)
    end,
    desc = "Prev Reference",
  },
}

-- Oil file manager
M.oil_keys = {
  { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
}

-- Dropbar breadcrumbs
M.dropbar_keys = {
  {
    "<leader>;",
    function()
      require("dropbar.api").pick()
    end,
    desc = "Pick symbols in winbar",
  },
  {
    "[;",
    function()
      require("dropbar.api").goto_context_start()
    end,
    desc = "Go to start of current context",
  },
  {
    "];",
    function()
      require("dropbar.api").select_next_context()
    end,
    desc = "Select next context",
  },
}

-- Notification keys
M.notify_keys = {
  {
    "<leader>un",
    function()
      require("notify").dismiss({ silent = true, pending = true })
    end,
    desc = "Dismiss All Notifications",
  },
}

-- Noice keys
M.noice_keys = {
  {
    "<S-Enter>",
    function()
      require("noice").redirect(vim.fn.getcmdline())
    end,
    mode = "c",
    desc = "Redirect Cmdline",
  },
  {
    "<leader>snl",
    function()
      require("noice").cmd("last")
    end,
    desc = "Noice Last Message",
  },
  {
    "<leader>snh",
    function()
      require("noice").cmd("history")
    end,
    desc = "Noice History",
  },
  {
    "<leader>sna",
    function()
      require("noice").cmd("all")
    end,
    desc = "Noice All",
  },
  {
    "<leader>snd",
    function()
      require("noice").cmd("dismiss")
    end,
    desc = "Dismiss All",
  },
  {
    "<c-f>",
    function()
      if not require("noice.lsp").scroll(4) then
        return "<c-f>"
      end
    end,
    silent = true,
    expr = true,
    desc = "Scroll Forward",
    mode = { "i", "n", "s" },
  },
  {
    "<c-b>",
    function()
      if not require("noice.lsp").scroll(-4) then
        return "<c-b>"
      end
    end,
    silent = true,
    expr = true,
    desc = "Scroll Backward",
    mode = { "i", "n", "s" },
  },
}

return M
