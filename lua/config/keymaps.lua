-- Initialize the centralized keymap system
local keymaps = require("core.keymaps")

-- Setup all keymaps through the centralized system
keymaps.setup()

-- Additional keymaps specific to this config
keymaps.register({
  n = {
    -- Quick quit
    ["<leader>qq"] = { ":qa<CR>", { desc = "Quit all" } },

    -- Better join lines
    ["J"] = { "mzJ`z", { desc = "Join lines without moving cursor" } },

    -- Center screen after navigation
    ["<C-d>"] = { "<C-d>zz", { desc = "Scroll down and center" } },
    ["<C-u>"] = { "<C-u>zz", { desc = "Scroll up and center" } },
    ["n"] = { "nzzzv", { desc = "Next search result centered" } },
    ["N"] = { "Nzzzv", { desc = "Previous search result centered" } },

    -- Quick macro execution
    ["Q"] = { "@q", { desc = "Execute macro q" } },

    -- Navigate buffers
    ["<S-l>"] = { ":bnext<CR>", { desc = "Next buffer" } },
    ["<S-h>"] = { ":bprevious<CR>", { desc = "Previous buffer" } },

    -- Save file
    ["<C-s>"] = { "<cmd>w<cr>", { desc = "Save file" } },
  },

  v = {
    -- Better paste behavior
    ["p"] = { '"_dP', { desc = "Paste without yanking" } },

    -- Stay in indent mode
    ["<"] = { "<gv", { desc = "Indent left and reselect" } },
    [">"] = { ">gv", { desc = "Indent right and reselect" } },

    -- Move text up and down
    ["J"] = { ":m '>+1<CR>gv=gv", { desc = "Move selection down" } },
    ["K"] = { ":m '<-2<CR>gv=gv", { desc = "Move selection up" } },
  },

  x = {
    -- Better paste in visual block mode
    ["p"] = { '"_dP', { desc = "Paste without yanking" } },

    -- Move text up and down in visual block mode
    ["J"] = { ":move '>+1<CR>gv-gv", { desc = "Move block down" } },
    ["K"] = { ":move '<-2<CR>gv-gv", { desc = "Move block up" } },
  },

  i = {
    -- Quick escape alternatives
    ["jk"] = { "<ESC>", { desc = "Exit insert mode" } },
    ["kj"] = { "<ESC>", { desc = "Exit insert mode (alternative)" } },
    -- Save file
    ["<C-s>"] = { "<cmd>w<cr><esc>", { desc = "Save file" } },
  },

})

-- Plugin-specific keymaps that don't belong in plugin configs
keymaps.register({
  n = {
    -- Flash.nvim integration
    ["s"] = { function() require("flash").jump() end, { desc = "Flash" } },
    ["S"] = { function() require("flash").treesitter() end, { desc = "Flash Treesitter" } },

    -- Git conflict resolution
    ["<leader>gco"] = { ":diffget //2<CR>", { desc = "Get from left (ours)" } },
    ["<leader>gct"] = { ":diffget //3<CR>", { desc = "Get from right (theirs)" } },

    -- Snacks.nvim integration
    ["<leader>bd"] = { function() Snacks.bufdelete() end, { desc = "Delete buffer" } },
    ["<leader>bD"] = { function() Snacks.bufdelete.other() end, { desc = "Delete other buffers" } },
  },

  v = {
    -- Flash.nvim in visual mode
    ["s"] = { function() require("flash").jump() end, { desc = "Flash" } },
    ["S"] = { function() require("flash").treesitter() end, { desc = "Flash Treesitter" } },
  },

  o = {
    -- Flash.nvim in operator mode
    ["s"] = { function() require("flash").jump() end, { desc = "Flash" } },
    ["S"] = { function() require("flash").treesitter() end, { desc = "Flash Treesitter" } },
    ["r"] = { function() require("flash").remote() end, { desc = "Remote Flash" } },
    ["R"] = { function() require("flash").treesitter_search() end, { desc = "Treesitter Search" } },
  },

  x = {
    -- Flash.nvim in visual block mode
    ["R"] = { function() require("flash").treesitter_search() end, { desc = "Treesitter Search" } },
  },

  c = {
    -- Flash.nvim in command mode
    ["<c-s>"] = { function() require("flash").toggle() end, { desc = "Toggle Flash Search" } },
  }
})

-- NOTE: Telescope keymaps are handled in lua/core/keymaps/telescope.lua
-- NOTE: LSP keymaps are handled in lua/core/keymaps/lsp.lua
-- NOTE: DAP keymaps are handled in plugins/debug.lua
