local M = {}

function M.setup()
  local keymaps = require("core.keymaps")
  
  keymaps.register({
    n = {
      -- Buffer management
      ["<leader>bd"] = { ":bd<CR>", { desc = "Delete buffer" } },
      ["<leader>bD"] = { ":bd!<CR>", { desc = "Force delete buffer" } },
      ["<leader>bn"] = { ":bnext<CR>", { desc = "Next buffer" } },
      ["<leader>bp"] = { ":bprevious<CR>", { desc = "Previous buffer" } },
      ["<leader>bb"] = { ":b#<CR>", { desc = "Toggle last buffer" } },
      ["<leader>ba"] = { ":%bd|e#|bd#<CR>", { desc = "Delete all buffers except current" } },
      
      -- Quickfix and location list
      ["<leader>co"] = { ":copen<CR>", { desc = "Open quickfix" } },
      ["<leader>cc"] = { ":cclose<CR>", { desc = "Close quickfix" } },
      ["<leader>cn"] = { ":cnext<CR>", { desc = "Next quickfix item" } },
      ["<leader>cp"] = { ":cprev<CR>", { desc = "Previous quickfix item" } },
      ["<leader>lo"] = { ":lopen<CR>", { desc = "Open location list" } },
      ["<leader>lc"] = { ":lclose<CR>", { desc = "Close location list" } },
      
      -- Text manipulation
      ["<leader>sa"] = { "ggVG", { desc = "Select all" } },
      ["<leader>y"] = { '"+y', { desc = "Yank to system clipboard" } },
      ["<leader>Y"] = { '"+Y', { desc = "Yank line to system clipboard" } },
      ["<leader>p"] = { '"+p', { desc = "Paste from system clipboard" } },
      ["<leader>P"] = { '"+P', { desc = "Paste before from system clipboard" } },
      
      -- Diagnostic navigation
      ["[d"] = { vim.diagnostic.goto_prev, { desc = "Previous diagnostic" } },
      ["]d"] = { vim.diagnostic.goto_next, { desc = "Next diagnostic" } },
      ["<leader>e"] = { vim.diagnostic.open_float, { desc = "Show diagnostic" } },
      ["<leader>dl"] = { vim.diagnostic.setloclist, { desc = "Diagnostics to location list" } },
      
      -- Toggle options
      ["<leader>tw"] = { ":set wrap!<CR>", { desc = "Toggle word wrap" } },
      ["<leader>tn"] = { ":set number!<CR>", { desc = "Toggle line numbers" } },
      ["<leader>tr"] = { ":set relativenumber!<CR>", { desc = "Toggle relative numbers" } },
      ["<leader>ts"] = { ":set spell!<CR>", { desc = "Toggle spell check" } },
      ["<leader>th"] = { ":set hlsearch!<CR>", { desc = "Toggle search highlight" } },
      ["<leader>ti"] = { ":set list!<CR>", { desc = "Toggle invisible characters" } },
    },
    
    v = {
      -- Visual mode system clipboard
      ["<leader>y"] = { '"+y', { desc = "Yank to system clipboard" } },
      ["<leader>p"] = { '"+p', { desc = "Paste from system clipboard" } },
      ["<leader>P"] = { '"+P', { desc = "Paste before from system clipboard" } },
      
      -- Search for selected text
      ["//"] = { 'y/<C-R>"<CR>', { desc = "Search for selection" } },
    },
    
    x = {
      -- Visual block mode clipboard operations
      ["<leader>y"] = { '"+y', { desc = "Yank to system clipboard" } },
      ["<leader>p"] = { '"+p', { desc = "Paste from system clipboard" } },
    }
  })
end

return M