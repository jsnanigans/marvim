local M = {}

-- Utility functions
local function is_available(module)
  local ok, mod = pcall(require, module)
  return ok and mod ~= nil
end

local function plugin_loaded(plugin_name)
  return package.loaded[plugin_name] ~= nil
end

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

-- ToggleTerm
M.toggleterm_keys = {
  { "<leader>Tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
  { "<leader>Th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal Terminal" },
  { "<leader>Tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
}

-- Database UI
M.dadbod_keys = {
  { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
}

-- Copilot AI
M.copilot_keys = {
  { "<C-l>", 'copilot#Accept("\\<CR>")', mode = "i", expr = true, replace_keycodes = false, desc = "Accept Copilot" },
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
    "<leader>td",
    function()
      require("neotest").run.run({ strategy = "dap" })
    end,
    desc = "Debug Nearest Test",
  },
  {
    "<leader>tS",
    function()
      require("neotest").run.stop()
    end,
    desc = "Stop Tests",
  },
  {
    "<leader>tc",
    function()
      require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
    end,
    desc = "Debug Test Class",
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

-- ============================================================================
-- EDITOR KEYMAPS
-- ============================================================================

function M.setup_editor()
  local map = vim.keymap.set

  -- Better up/down with wrapped lines
  map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

  -- Redo with U
  map("n", "U", "<C-r>", { desc = "Redo" })

  -- Clear search with <esc>
  map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

  -- Save file
  map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

  -- Better indenting
  map("v", "<", "<gv", { desc = "Indent Left" })
  map("v", ">", ">gv", { desc = "Indent Right" })

  -- Better paste
  map("v", "p", '"_dP', { desc = "Paste without yanking" })

  -- Add empty lines
  map("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = "Put Empty Line Above" })
  map("n", "go", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", { desc = "Put Empty Line Below" })

  -- Move Lines
  map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
  map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
  map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
  map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
  map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
  map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

  -- Reference navigation (improved search navigation)
  map("n", "]]", function()
    vim.cmd("normal! n")
    vim.cmd("normal! zz")
  end, { desc = "Next Search Result" })
  map("n", "[[", function()
    vim.cmd("normal! N")
    vim.cmd("normal! zz")
  end, { desc = "Previous Search Result" })
end

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

function M.setup_windows()
  local map = vim.keymap.set

  -- Move to window using the <ctrl> hjkl keys
  map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
  map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
  map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
  map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

  -- Resize window using <ctrl> arrow keys
  map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
  map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
  map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
  map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

  -- Windows
  map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
  map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
  map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
  map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
end

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================

function M.setup_buffers()
  local map = vim.keymap.set

  -- Buffer navigation
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

  -- Buffer management (using mini.bufremove if available)
  if is_available("mini.bufremove") then
    map("n", "<leader>bd", function()
      require("mini.bufremove").delete(0, false)
    end, { desc = "Delete Buffer" })
    map("n", "<leader>bD", function()
      require("mini.bufremove").delete(0, true)
    end, { desc = "Delete Buffer (Force)" })
  else
    -- Fallback to built-in commands
    map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
    map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete Buffer (Force)" })
  end
end

-- ============================================================================
-- TAB MANAGEMENT
-- ============================================================================

function M.setup_tabs()
  local map = vim.keymap.set

  map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
  map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
  map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
  map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
  map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
end

-- ============================================================================
-- TERMINAL
-- ============================================================================

function M.setup_terminal()
  local map = vim.keymap.set

  map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
  map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
  map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
  map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
  map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
end

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================

function M.setup_files()
  local map = vim.keymap.set

  -- New file
  map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

  -- Root directory operations
  map("n", "<leader>cD", function()
    local ok, root_utils = pcall(require, "utils.root")
    if ok then
      root_utils.cd_root()
    end
  end, { desc = "Change to Root Directory" })

  map("n", "<leader>cR", function()
    local ok, root_utils = pcall(require, "utils.root")
    if ok then
      local root = root_utils.find_root()
      vim.notify("Project root: " .. root, vim.log.levels.INFO)
    end
  end, { desc = "Show Root Directory" })
end

-- ============================================================================
-- DIAGNOSTICS
-- ============================================================================

function M.setup_diagnostics()
  local map = vim.keymap.set

  -- Diagnostic navigation
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to Previous Diagnostic" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic" })
  map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic Error" })
  map("n", "<leader>qc", vim.diagnostic.setloclist, { desc = "Open Diagnostic Quickfix" })

  -- Location and quickfix lists
  map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
  map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
  map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
  map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
end

-- ============================================================================
-- LSP KEYBINDINGS
-- ============================================================================

function M.setup_lsp_keybindings(client, buffer)
  local function lsp_map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = buffer
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Navigation (using Snacks picker if available, fallback to built-in)
  if is_available("snacks") then
    local snacks = require("snacks")
    if snacks.picker then
      lsp_map("n", "gd", function()
        snacks.picker.lsp_definitions()
      end, { desc = "Go to Definition", nowait = true })
      lsp_map("n", "gr", function()
        snacks.picker.lsp_references()
      end, { desc = "References", nowait = true })
      lsp_map("n", "gD", function()
        snacks.picker.lsp_declarations()
      end, { desc = "Go to Declaration", nowait = true })
      lsp_map("n", "gI", function()
        snacks.picker.lsp_implementations()
      end, { desc = "Go to Implementation", nowait = true })
      lsp_map("n", "gy", function()
        snacks.picker.lsp_type_definitions()
      end, { desc = "Go to Type Definition", nowait = true })
    else
      -- Fallback to built-in LSP functions
      lsp_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      lsp_map("n", "gr", vim.lsp.buf.references, { desc = "References" })
      lsp_map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
      lsp_map("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
      lsp_map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
    end
  else
    -- Fallback to built-in LSP functions
    lsp_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    lsp_map("n", "gr", vim.lsp.buf.references, { desc = "References" })
    lsp_map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
    lsp_map("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
    lsp_map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
  end

  -- Documentation and help
  lsp_map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  lsp_map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  lsp_map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  lsp_map("n", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

  -- Code actions and refactoring
  if is_available("snacks") then
    local snacks = require("snacks")
    if snacks.picker and snacks.picker.lsp_code_actions then
      lsp_map({ "n", "v" }, "<leader>ca", function()
        snacks.picker.lsp_code_actions()
      end, { desc = "Code Action" })
    else
      lsp_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    end
  else
    lsp_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  end

  lsp_map("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
  lsp_map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh Codelens" })
  lsp_map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

  -- Formatting
  lsp_map({ "n", "v" }, "<leader>cf", function()
    local ok, lsp_utils = pcall(require, "utils.lsp")
    if ok then
      lsp_utils.format({ buf = buffer })
    else
      vim.lsp.buf.format({ async = true })
    end
  end, { desc = "Format" })

  -- Diagnostics
  lsp_map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  lsp_map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostic Quickfix" })

  -- Advanced diagnostics navigation
  lsp_map("n", "[D", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Previous Error" })
  lsp_map("n", "]D", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Next Error" })

  -- Workspace management
  lsp_map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
  lsp_map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove Workspace Folder" })
  lsp_map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List Workspace Folders" })

  -- Symbol search
  if is_available("snacks") then
    local snacks = require("snacks")
    if snacks.picker then
      lsp_map("n", "<leader>ds", function()
        snacks.picker.lsp_document_symbols()
      end, { desc = "Document Symbols" })
      lsp_map("n", "<leader>ws", function()
        snacks.picker.lsp_workspace_symbols()
      end, { desc = "Workspace Symbols" })
    end
  end

  -- Call hierarchy (if supported)
  if client:supports_method("callHierarchy/incomingCalls") then
    lsp_map("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Incoming Calls" })
  end
  if client:supports_method("callHierarchy/outgoingCalls") then
    lsp_map("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Outgoing Calls" })
  end

  -- UI toggles
  if client:supports_method("textDocument/inlayHint") then
    lsp_map("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }), { bufnr = buffer })
    end, { desc = "Toggle Inlay Hints (Buffer)" })
    lsp_map("n", "<leader>uH", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle Inlay Hints (Global)" })
  end

  -- Code lens toggle
  if client:supports_method("textDocument/codeLens") then
    lsp_map("n", "<leader>ul", function()
      local is_enabled = vim.g.codelens_enabled ~= false
      vim.g.codelens_enabled = not is_enabled
      if vim.g.codelens_enabled then
        vim.lsp.codelens.refresh({ bufnr = buffer })
      else
        vim.lsp.codelens.clear(nil, buffer)
      end
    end, { desc = "Toggle Code Lens" })
  end

  -- LSP management
  lsp_map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
  lsp_map("n", "<leader>lR", function()
    vim.cmd("LspRestart")
    vim.notify("LSP Restarted", vim.log.levels.INFO)
  end, { desc = "Restart LSP" })

  -- Document highlighting (if supported)
  if client:supports_method("textDocument/documentHighlight") then
    local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight_" .. buffer, { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = buffer,
      group = highlight_augroup,
      callback = function()
        pcall(vim.lsp.buf.document_highlight)
      end,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = buffer,
      group = highlight_augroup,
      callback = function()
        pcall(vim.lsp.buf.clear_references)
      end,
    })
    -- Clean up when buffer is deleted
    vim.api.nvim_create_autocmd("BufDelete", {
      buffer = buffer,
      callback = function()
        pcall(vim.api.nvim_del_augroup_by_name, "lsp_document_highlight_" .. buffer)
      end,
    })
  end

  -- Language-specific keybindings
  if client.name == "vtsls" then
    -- TypeScript-specific actions using proper vtsls commands
    lsp_map("n", "<leader>cI", function()
      -- Use the standard source.organizeImports code action
      vim.lsp.buf.code_action({
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { desc = "Organize Imports" })

    lsp_map("n", "<leader>cR", function()
      local ok, lsp_utils = pcall(require, "utils.lsp")
      if ok then
        lsp_utils.rename_file()
      end
    end, { desc = "Rename File" })

    lsp_map("n", "<leader>cA", function()
      -- Use code action for adding missing imports
      vim.lsp.buf.code_action({
        context = {
          only = { "source.addMissingImports" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { desc = "Add Missing Imports" })

    lsp_map("n", "<leader>cu", function()
      -- Use code action for removing unused imports
      vim.lsp.buf.code_action({
        context = {
          only = { "source.removeUnused" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { desc = "Remove Unused Imports" })
  end
end

-- ============================================================================
-- PLUGIN KEYMAPS (Non-lazy plugins only)
-- ============================================================================

function M.setup_plugin_keymaps()
  local map = vim.keymap.set

  -- Plugin keymaps are now handled via key tables in plugin configs
  -- Only non-lazy keymaps are set up here

  -- Mason (LSP installer)
  if vim.fn.exists(":Mason") == 2 then
    map("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
  end

  -- LazyGit
  if vim.fn.exists(":LazyGit") == 2 then
    map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
  end

  -- Git Blame
  if vim.fn.exists(":GitBlameToggle") == 2 then
    map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle Git Blame" })
  end

  -- Git Conflicts
  if vim.fn.exists(":GitConflictChooseOurs") == 2 then
    map("n", "<leader>gco", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose Ours" })
    map("n", "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose Theirs" })
    map("n", "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose Both" })
    map("n", "<leader>gc0", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose None" })
    map("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Next Conflict" })
    map("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Prev Conflict" })
  end

  -- Diffview
  if vim.fn.exists(":DiffviewOpen") == 2 then
    map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
    map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "File History" })
    map("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current File History" })
  end

  -- Snacks.nvim picker
  if is_available("snacks") then
    local snacks = require("snacks")
    if snacks.picker then
      -- File finding and search - excludes test files by default
      map("n", "<leader><leader>", function()
        require("snacks").picker.files({
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
            "*.test.*",
            "--exclude",
            "*.spec.*",
            "--exclude",
            "*_test.dart",
            "--exclude",
            "*_spec.dart",
          },
        })
      end, { desc = "Find Files" })

      map("n", "<leader>ff", function()
        require("snacks").picker.files({
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
            "*.test.*",
            "--exclude",
            "*.spec.*",
            "--exclude",
            "*_test.dart",
            "--exclude",
            "*_spec.dart",
          },
        })
      end, { desc = "Find Files" })

      map("n", "<leader>fr", function()
        require("snacks").picker.recent()
      end, { desc = "Recent Files" })
      map("n", "<leader>fB", function()
        require("snacks").picker.buffers()
      end, { desc = "Buffers" })
      map("n", "<leader>/", function()
        require("snacks").picker.grep()
      end, { desc = "Grep" })
      map("n", "<leader>sg", function()
        require("snacks").picker.grep()
      end, { desc = "Grep" })
      map("n", "<leader>sw", function()
        require("snacks").picker.grep_string()
      end, { desc = "Grep Word" })
      map("n", "<leader>sc", function()
        require("snacks").picker.commands()
      end, { desc = "Commands" })
      map("n", "<leader>sh", function()
        require("snacks").picker.help()
      end, { desc = "Help Pages" })
      map("n", "<leader>sk", function()
        require("snacks").picker.keymaps()
      end, { desc = "Key Maps" })
      map("n", "<leader>ss", function()
        require("snacks").picker.files()
      end, { desc = "Select Files" })
      map("n", "<leader>sa", function()
        require("snacks").picker.autocmds()
      end, { desc = "Auto Commands" })
      map("n", "<leader>sb", function()
        require("snacks").picker.lines()
      end, { desc = "Buffer Lines" })
      map("n", "<leader>:", function()
        require("snacks").picker.command_history()
      end, { desc = "Command History" })
      map("n", "<leader>sR", function()
        require("snacks").picker.resume()
      end, { desc = "Resume" })

      -- Git status and commits
      map("n", "<leader>gc", function()
        require("snacks").picker.git_log()
      end, { desc = "Git Commits" })
      map("n", "<leader>gs", function()
        require("snacks").picker.git_status()
      end, { desc = "Git Status" })

      -- LSP symbol search (global)
      map("n", "<leader>sS", function()
        require("snacks").picker.lsp_workspace_symbols()
      end, { desc = "Workspace Symbols" })

      -- Test file commands
      map("n", "<leader>ft", function()
        require("snacks").picker.files({
          args = {
            "--hidden",
            "--follow",
            "--exclude",
            "node_modules",
            "--exclude",
            ".git",
            "\\.(test|spec)\\.(js|ts|jsx|tsx)$|_test\\.dart$|_spec\\.dart$",
          },
        })
      end, { desc = "Find Test Files" })

      map("n", "<leader>st", function()
        require("snacks").picker.grep({
          args = {
            "--column",
            "--line-number",
            "--no-heading",
            "--color=never",
            "--smart-case",
            "--with-filename",
            "--glob",
            "*.test.{js,ts,jsx,tsx}",
            "--glob",
            "*.spec.{js,ts,jsx,tsx}",
            "--glob",
            "*_test.dart",
            "--glob",
            "*_spec.dart",
          },
        })
      end, { desc = "Search in Test Files" })

      -- Bloc/Cubit file commands
      map("n", "<leader>fb", function()
        require("snacks").picker.files({
          args = {
            "--hidden",
            "--follow",
            "--exclude",
            "node_modules",
            "--exclude",
            ".git",
            "([Bb]loc|[Cc]ubit)\\.(ts|tsx|js|jsx)$|_bloc\\.dart$|_cubit\\.dart$",
          },
        })
      end, { desc = "Find Bloc/Cubit Files" })

      map("n", "<leader>sB", function()
        require("snacks").picker.grep({
          args = {
            "--column",
            "--line-number",
            "--no-heading",
            "--color=never",
            "--smart-case",
            "--with-filename",
            "--glob",
            "*[Bb]loc.{js,ts,jsx,tsx}",
            "--glob",
            "*[Cc]ubit.{js,ts,jsx,tsx}",
            "--glob",
            "*_bloc.dart",
            "--glob",
            "*_cubit.dart",
          },
        })
      end, { desc = "Search in Bloc/Cubit Files" })

      -- Show all files including tests
      map("n", "<leader>fT", function()
        require("snacks").picker.files({
          args = {
            "--hidden",
            "--follow",
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
            -- Notably NOT excluding test files
          },
        })
      end, { desc = "Find All Files (Including Tests)" })

      -- Feature files (implementation + tests + bloc/cubit for a feature)
      map("n", "<leader>fF", function()
        vim.ui.input({ prompt = "Feature name: " }, function(feature)
          if not feature or feature == "" then
            return
          end
          require("snacks").picker.files({
            args = {
              "--hidden",
              "--follow",
              "--exclude",
              "node_modules",
              "--exclude",
              ".git",
              feature,
            },
          })
        end)
      end, { desc = "Find Feature Files" })

      -- Projects picker
      map("n", "<leader>fp", function()
        require("snacks").picker.files({
          cwd = vim.fn.expand("~/Projects"),
          find_command = { "find", ".", "-type", "d", "-name", ".git" },
          prompt_title = "Projects",
        })
      end, { desc = "Find Projects" })
    end
  end

  -- Harpoon
  if is_available("harpoon") then
    map("n", "<leader>H", function()
      require("harpoon"):list():add()
    end, { desc = "Harpoon File" })
    map("n", "<leader>h", function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon Quick Menu" })

    -- Harpoon file navigation (1-5)
    for i = 1, 5 do
      map("n", "<leader>" .. i, function()
        require("harpoon"):list():select(i)
      end, { desc = "Harpoon to File " .. i })
    end
  end

  -- Flash
  if is_available("flash") then
    map({ "n", "x", "o" }, "s", function()
      require("flash").jump()
    end, { desc = "Flash" })
    map({ "n", "x", "o" }, "S", function()
      require("flash").treesitter()
    end, { desc = "Flash Treesitter" })
    map("o", "r", function()
      require("flash").remote()
    end, { desc = "Remote Flash" })
    map({ "o", "x" }, "R", function()
      require("flash").treesitter_search()
    end, { desc = "Treesitter Search" })
    map("c", "<c-s>", function()
      require("flash").toggle()
    end, { desc = "Toggle Flash Search" })
  end

  -- Comment.nvim
  if is_available("Comment.api") then
    map("n", "gcc", function()
      require("Comment.api").toggle.linewise.current()
    end, { desc = "Comment toggle current line" })
    map({ "n", "o" }, "gc", function()
      require("Comment.api").toggle.linewise()
    end, { desc = "Comment toggle linewise" })
    map("x", "gc", function()
      require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end, { desc = "Comment toggle linewise (visual)" })
    map("n", "gbc", function()
      require("Comment.api").toggle.blockwise.current()
    end, { desc = "Comment toggle current block" })
    map({ "n", "o" }, "gb", function()
      require("Comment.api").toggle.blockwise()
    end, { desc = "Comment toggle blockwise" })
    map("x", "gb", function()
      require("Comment.api").toggle.blockwise(vim.fn.visualmode())
    end, { desc = "Comment toggle blockwise (visual)" })
  end

  -- Mini.surround
  if is_available("mini.surround") then
    map({ "n", "v" }, "gsa", function()
      require("mini.surround").add()
    end, { desc = "Add Surrounding" })
    map("n", "gsd", function()
      require("mini.surround").delete()
    end, { desc = "Delete Surrounding" })
    map("n", "gsf", function()
      require("mini.surround").find()
    end, { desc = "Find Right Surrounding" })
    map("n", "gsF", function()
      require("mini.surround").find_left()
    end, { desc = "Find Left Surrounding" })
    map("n", "gsh", function()
      require("mini.surround").highlight()
    end, { desc = "Highlight Surrounding" })
    map("n", "gsr", function()
      require("mini.surround").replace()
    end, { desc = "Replace Surrounding" })
    map("n", "gsn", function()
      require("mini.surround").update_n_lines()
    end, { desc = "Update `MiniSurround.config.n_lines`" })
  end
end

-- ============================================================================
-- GITSIGNS KEYBINDINGS
-- ============================================================================

function M.setup_gitsigns_keybindings(buffer)
  local gs = package.loaded.gitsigns
  if not gs then
    return
  end

  local function git_map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
  end

  -- Hunk navigation
  git_map("n", "]h", gs.next_hunk, "Next Hunk")
  git_map("n", "[h", gs.prev_hunk, "Prev Hunk")

  -- Hunk actions
  git_map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
  git_map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
  git_map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
  git_map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
  git_map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
  git_map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
  git_map("n", "<leader>ghb", function()
    gs.blame_line({ full = true })
  end, "Blame Line")
  git_map("n", "<leader>ghd", gs.diffthis, "Diff This")
  git_map("n", "<leader>ghD", function()
    gs.diffthis("~")
  end, "Diff This ~")

  -- Text objects
  git_map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
end

-- ============================================================================
-- DEVELOPMENT UTILITIES
-- ============================================================================

function M.setup_dev()
  local map = vim.keymap.set

  -- Modern Neovim development features
  map("n", "<leader>sT", function()
    vim.cmd("!nvim --startuptime /tmp/nvim_startup.log +qa && cat /tmp/nvim_startup.log")
  end, { desc = "Show Startup Time" })

  -- Debug crash issues
  map("n", "<leader>sD", function()
    print("=== Debug Info ===")
    print("LSP clients: " .. #vim.lsp.get_clients())
    print("Buffers: " .. #vim.api.nvim_list_bufs())
    print("Memory: " .. vim.loop.getrusage().maxrss .. " KB")
    print("Autocmds: ")
    vim.cmd("redir => g:autocmd_output | silent autocmd | redir END")
    local autocmd_count = #vim.split(vim.g.autocmd_output, "\n")
    print("  Total autocmds: " .. autocmd_count)
    if autocmd_count > 1000 then
      print("  WARNING: High autocmd count detected!")
    end
  end, { desc = "Debug Crash Info" })
end

-- ============================================================================
-- SETUP FUNCTION
-- ============================================================================

function M.setup()
  M.setup_editor()
  M.setup_windows()
  M.setup_buffers()
  M.setup_tabs()
  M.setup_terminal()
  M.setup_files()
  M.setup_diagnostics()
  M.setup_dev()

  vim.defer_fn(function()
    M.setup_plugin_keymaps()
  end, 100)
end

M.setup()
return M
