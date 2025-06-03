-- Keymaps optimized for speed, developer experience, and logical organization
local keymap = vim.keymap.set

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===== CORE SPEED OPTIMIZATIONS =====

-- Lightning-fast escape (most frequent action)
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("i", "kj", "<ESC>", { desc = "Exit insert mode (alternative)" })

-- Ultra-fast save (critical action)
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Clear search highlights - make it easier to reach
keymap("n", "<Esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
keymap("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- ===== ENHANCED WINDOW NAVIGATION =====

-- Better window navigation (most used movements)
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Terminal mode navigation (consistent with normal mode)
keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
keymap("t", "<Esc><Esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- ===== SMART WINDOW RESIZING =====

-- Intuitive resize with arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ===== OPTIMIZED BUFFER NAVIGATION =====

-- Fast buffer switching (very common action)
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
-- Removed: <leader>bd is handled by snacks.bufdelete
keymap("n", "<leader>ba", "<cmd>%bd|e#<CR>", { desc = "Delete all buffers except current" })

-- Buffer toggle functionality - switch between current and previous buffer
local previous_buffer = nil

-- Track the previously used buffer
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    -- Only track normal buffers (not special ones like terminal, help, etc.)
    if vim.bo[current_buf].buflisted and vim.bo[current_buf].buftype == "" then
      if previous_buffer and previous_buffer ~= current_buf then
        -- Store the last buffer only if it's different from current
        vim.g.marvim_last_buffer = previous_buffer
      end
      previous_buffer = current_buf
    end
  end,
})

-- Toggle between current and previous buffer
keymap("n", "<C-.>", function()
  local last_buffer = vim.g.marvim_last_buffer
  if last_buffer and vim.api.nvim_buf_is_valid(last_buffer) and vim.bo[last_buffer].buflisted then
    vim.api.nvim_set_current_buf(last_buffer)
  else
    -- Fallback to alternate buffer if no previous buffer tracked
    local alt_buf = vim.fn.bufnr("#")
    if alt_buf ~= -1 and vim.api.nvim_buf_is_valid(alt_buf) and vim.bo[alt_buf].buflisted then
      vim.api.nvim_set_current_buf(alt_buf)
    else
      vim.notify("No previous buffer available", vim.log.levels.INFO)
    end
  end
end, { desc = "Toggle to previous buffer" })

-- ===== ENHANCED TEXT MANIPULATION =====

-- Better up/down movement (handle word wrap)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- NOTE: Line movement is handled by mini.move plugin with <M-hjkl> keys

-- Smart indenting (stay in visual mode)
keymap("v", "<", "<gv", { desc = "Decrease indent" })
keymap("v", ">", ">gv", { desc = "Increase indent" })

-- Better paste (don't yank replaced text)
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- ===== ENHANCED SEARCH NAVIGATION =====

-- Centered navigation for better focus
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })

-- ===== WINDOW MANAGEMENT (Optimized) =====

-- Quick window operations
keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })

-- Quick splits (even faster access)
keymap("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
keymap("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- ===== TAB MANAGEMENT (Conflict-Free) =====

-- Move tab operations to <leader><tab> prefix to avoid TypeScript conflicts
keymap("n", "<leader><tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader><tab>x", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader><tab>]", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap("n", "<leader><tab>o", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- ===== TYPESCRIPT OPERATIONS (Fixed Conflicts) =====

-- Move TypeScript to <leader>ts prefix for clarity and conflict avoidance
keymap("n", "<leader>tso", "<cmd>TypescriptOrganizeImports<cr>", { desc = "TS: Organize Imports" })
keymap("n", "<leader>tsr", "<cmd>TypescriptRenameFile<cr>", { desc = "TS: Rename File" })
keymap("n", "<leader>tsa", "<cmd>TypescriptAddMissingImports<cr>", { desc = "TS: Add Missing Imports" })
keymap("n", "<leader>tsR", "<cmd>TypescriptRemoveUnused<cr>", { desc = "TS: Remove Unused" })
keymap("n", "<leader>tsf", "<cmd>TypescriptFixAll<cr>", { desc = "TS: Fix All" })
keymap("n", "<leader>tsg", "<cmd>TypescriptGoToSourceDefinition<cr>", { desc = "TS: Go to Source Definition" })

-- ===== TERMINAL OPTIMIZATIONS =====

-- Quick terminal access
keymap("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })
keymap("n", "<leader>th", "<cmd>split | terminal<CR>", { desc = "Terminal horizontal split" })
keymap("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Terminal vertical split" })

-- ===== LSP OPERATIONS =====
-- NOTE: LSP keymaps are defined in lua/plugins/lsp.lua within the on_attach function
-- This ensures they're only active when an LSP server is attached to the buffer

-- ===== FORMATTING & ORGANIZING =====

-- Format current file
keymap("n", "<leader>cf", function()
  -- Try conform.nvim first, fall back to LSP
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Format file" })

-- Format selection in visual mode
keymap("v", "<leader>cf", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Format selection" })

-- Organize imports (TypeScript/JavaScript)
keymap("n", "<leader>co", function()
  -- Check if we're in a TypeScript/JavaScript file
  local ft = vim.bo.filetype
  if ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
    vim.lsp.buf.execute_command({
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) }
    })
  elseif ft == "python" then
    -- For Python, use isort if available
    vim.cmd("!isort %")
  else
    vim.notify("Organize imports not available for " .. ft, vim.log.levels.WARN)
  end
end, { desc = "Organize imports" })

-- LSP info and diagnostics (resolved conflicts)
keymap("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
keymap("n", "<leader>ll", "<cmd>LspLog<cr>", { desc = "LSP Log" })
keymap("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- LSP diagnostics function (no conflict with telescope)
keymap("n", "<leader>lx", function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.WARN)
    return
  end

  print("LSP Clients attached to buffer:")
  for _, client in ipairs(clients) do
    print("- " .. client.name .. " (id: " .. client.id .. ")")
  end

  print("\nBuffer info:")
  print("- Filetype: " .. vim.bo.filetype)
  print("- Buffer: " .. vim.api.nvim_buf_get_name(0))
end, { desc = "LSP Debug Info" })

-- ===== DIAGNOSTIC NAVIGATION =====
-- NOTE: Diagnostic keymaps are defined in lua/plugins/lsp.lua within the on_attach function

-- ===== QUICKFIX & LOCATION LIST =====

keymap("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
keymap("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- ===== QUICK ACCESS & UTILITIES =====

-- Configuration access
keymap("n", "<leader>ce", "<cmd>e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })
keymap("n", "<leader>cr", "<cmd>source ~/.config/nvim/init.lua<CR>", { desc = "Reload config" })

-- Quick quit operations
keymap("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })

-- New file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- ===== ENHANCED SEARCH & REPLACE =====

-- Search for word under cursor
keymap("n", "*", "*N", { desc = "Search word under cursor (stay)" })
keymap("n", "#", "#N", { desc = "Search word under cursor backward (stay)" })

-- Better search and replace
keymap("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", { desc = "Replace word under cursor" })
keymap("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>", { desc = "Replace selected text" })

-- ===== TEXT OBJECTS & MOTIONS =====

-- Select all
keymap("n", "<C-a>", "ggVG", { desc = "Select all" })

-- NOTE: Better j/k movement already handled above with expr = true

-- Better line beginning/end
keymap("n", "H", "^", { desc = "Go to first non-blank character" })
keymap("n", "L", "$", { desc = "Go to end of line" })

-- ===== COMMAND LINE ENHANCEMENTS =====

-- Command line history navigation
keymap("c", "<C-j>", "<Down>", { desc = "Next command" })
keymap("c", "<C-k>", "<Up>", { desc = "Previous command" })

-- ===== VISUAL MODE ENHANCEMENTS =====

-- Keep selection when indenting
keymap("v", "<", "<gv", { desc = "Decrease indent and reselect" })
keymap("v", ">", ">gv", { desc = "Increase indent and reselect" })

-- Move selection up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ===== UTILITY MAPPINGS =====

-- Toggle options
-- Removed toggle mappings: handled by snacks.nvim toggle module

-- Show current file path
keymap("n", "<leader>fp", "<cmd>echo expand('%:p')<CR>", { desc = "Show file path" })

-- Copy file path to clipboard
keymap("n", "<leader>fy", "<cmd>let @+ = expand('%:p')<CR>", { desc = "Copy file path" })

-- ===== UNDO BREAK-POINTS (Better undo granularity) =====

keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- NOTE: Plugin-specific keymaps are defined in their respective plugin files:
-- - Telescope: lua/plugins/telescope.lua (find operations: <leader>f*)
-- - Flash: lua/plugins/flash.lua (s, S for motion)
-- - Leap: REMOVED (using flash.nvim instead)
-- - Git: lua/plugins/git.lua (git operations: <leader>g*, <leader>h*)
-- - Trouble: lua/plugins/utils.lua (diagnostics: <leader>x*)
-- - FZF-lua: REMOVED (using telescope instead)

-- Lazy plugin manager (avoid conflict with LSP)
-- NOTE: Mapped to <leader>L in init.lua

