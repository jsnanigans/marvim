local M = {}

function M.setup()
  local keymaps = require("core.keymaps")
  
  keymaps.register({
    n = {
      -- Buffer management (consolidated and conflict-free)
      ["<leader>bd"] = { ":bdelete<CR>", { desc = "Delete buffer" } },
      ["<leader>bD"] = { ":bdelete!<CR>", { desc = "Force delete buffer" } },
      ["<leader>bn"] = { ":bnext<CR>", { desc = "Next buffer" } },
      ["<leader>bp"] = { ":bprevious<CR>", { desc = "Previous buffer" } },
      ["<leader>bb"] = { ":b#<CR>", { desc = "Toggle last buffer" } },
      ["<leader>ba"] = { ":%bd|e#|bd#<CR>", { desc = "Delete all buffers except current" } },
      ["<leader>bl"] = { ":buffers<CR>", { desc = "List buffers" } },
      ["<leader>bs"] = { ":w<CR>", { desc = "Save current buffer" } },
      ["<leader>bS"] = { ":wa<CR>", { desc = "Save all buffers" } },
      
      -- Quickfix and location list
      ["<leader>xo"] = { ":copen<CR>", { desc = "Open quickfix" } },
      ["<leader>xc"] = { ":cclose<CR>", { desc = "Close quickfix" } },
      ["<leader>xn"] = { ":cnext<CR>", { desc = "Next quickfix item" } },
      ["<leader>xp"] = { ":cprev<CR>", { desc = "Previous quickfix item" } },
      ["<leader>xl"] = { ":lopen<CR>", { desc = "Open location list" } },
      ["<leader>xL"] = { ":lclose<CR>", { desc = "Close location list" } },
      
      -- Text manipulation
      ["<leader>sa"] = { "ggVG", { desc = "Select all" } },
      
      -- Toggle options (moved to avoid conflicts)
      ["<leader>ti"] = { ":set list!<CR>", { desc = "Toggle invisible characters" } },
      ["<leader>tc"] = { ":set cursorline!<CR>", { desc = "Toggle cursor line" } },
      ["<leader>tC"] = { ":set cursorcolumn!<CR>", { desc = "Toggle cursor column" } },
      
      -- Enhanced search
      ["<leader>/"] = { "/<C-r><C-w><CR>", { desc = "Search word under cursor" } },
      ["<leader>?"] = { "?<C-r><C-w><CR>", { desc = "Search word backwards" } },
      
      -- Marks and jumps
      ["<leader>mm"] = { ":marks<CR>", { desc = "Show marks" } },
      ["<leader>mj"] = { ":jumps<CR>", { desc = "Show jumps" } },
      ["<leader>mc"] = { ":delmarks!<CR>", { desc = "Clear all marks" } },
    },
    
    v = {
      -- Visual mode enhancements
      ["//"] = { 'y/<C-R>"<CR>', { desc = "Search for selection" } },
      ["<leader>sa"] = { "<Esc>ggVG", { desc = "Select all" } },
    },
    
    -- NOTE: Visual block clipboard operations are handled in core/keymaps/init.lua
  })
end

return M