local M = {}

-- Utility functions
local function is_available(module)
  local ok, mod = pcall(require, module)
  return ok and mod ~= nil
end

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

return M