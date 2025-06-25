-- Initialize the centralized keymap system
local keymaps = require("core.keymaps")

-- Setup all keymaps through the centralized system
keymaps.setup()

-- Additional keymaps specific to this config (NON-CONFLICTING ONLY)
keymaps.register({
  n = {
    -- Quick quit (unique)
    ["<leader>qq"] = { ":qa<CR>", { desc = "Quit all" } },

    -- Better join lines (unique)
    ["J"] = { "mzJ`z", { desc = "Join lines without moving cursor" } },

    -- Quick macro execution (unique)
    ["Q"] = { "@q", { desc = "Execute macro q" } },

    -- Save file with Ctrl+S (unique)
    ["<C-s>"] = { "<cmd>w<cr>", { desc = "Save file" } },

    -- Flash.nvim integration (unique)
    ["s"] = { function() require("flash").jump() end, { desc = "Flash" } },
    ["S"] = { function() require("flash").treesitter() end, { desc = "Flash Treesitter" } },

    -- Git conflict resolution (unique)
    ["<leader>gco"] = { ":diffget //2<CR>", { desc = "Get from left (ours)" } },
    ["<leader>gct"] = { ":diffget //3<CR>", { desc = "Get from right (theirs)" } },

    -- Snacks.nvim integration (unique mappings only)
    ["<leader>un"] = { function() require("snacks").notifier.hide() end, { desc = "Dismiss All Notifications" } },
    ["<leader>gg"] = { function() require("snacks").lazygit() end, { desc = "Lazygit" } },
    ["<leader>gB"] = { function() require("snacks").gitbrowse() end, { desc = "Git Browse" } },
    ["<leader>gl"] = { function() require("snacks").lazygit.log() end, { desc = "Lazygit Log (cwd)" } },
    ["<leader>gF"] = { function() require("snacks").lazygit.log_file() end, { desc = "Lazygit Current File History" } },
    ["<leader>cR"] = { function() require("snacks").rename.rename_file() end, { desc = "Rename File" } },
    
    -- Grug-far (search and replace) integration (unique prefixes)
    ["<leader>rr"] = { function() require("grug-far").open() end, { desc = "Search and replace" } },
    ["<leader>rW"] = { function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, { desc = "Search and replace current word" } },
    ["<leader>rf"] = { function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end, { desc = "Search and replace in current file" } },
    
    -- Git commands (fugitive) (unique)
    ["<leader>gp"] = { "<cmd>Git push<cr>", { desc = "Git push" } },
    ["<leader>gP"] = { "<cmd>Git pull<cr>", { desc = "Git pull" } },
    ["<leader>gE"] = { "<cmd>Git fetch<cr>", { desc = "Git fetch" } },
    
    -- Terminal toggle (unique)
    ["<c-/>"] = { function() require("snacks").terminal() end, { desc = "Toggle Terminal" } },
    ["<c-_>"] = { function() require("snacks").terminal() end, { desc = "Toggle Terminal (which_key_ignore)" } },
    
    -- Word navigation (unique)
    ["]]"] = { function() require("snacks").words.jump(vim.v.count1) end, { desc = "Next Reference" } },
    ["[["] = { function() require("snacks").words.jump(-vim.v.count1) end, { desc = "Prev Reference" } },
    
    -- Rosé Pine theme switching
    ["<leader>utm"] = { "<cmd>RosePineMain<cr>", { desc = "Rosé Pine Main" } },
    ["<leader>utn"] = { "<cmd>RosePineMoon<cr>", { desc = "Rosé Pine Moon" } },
    ["<leader>utd"] = { "<cmd>RosePineDawn<cr>", { desc = "Rosé Pine Dawn" } },
    ["<leader>utt"] = { "<cmd>RosePineToggleTransparency<cr>", { desc = "Toggle transparency" } },
    ["<leader>uta"] = { "<cmd>colorscheme habamax<cr>", { desc = "Switch to Habamax" } },
  },

  v = {
    -- Flash.nvim in visual mode (unique)
    ["s"] = { function() require("flash").jump() end, { desc = "Flash" } },
    ["S"] = { function() require("flash").treesitter() end, { desc = "Flash Treesitter" } },
    
    -- Grug-far in visual mode (unique)
    ["<leader>rr"] = { function() require("grug-far").with_visual_selection() end, { desc = "Search and replace selection" } },
  },

  o = {
    -- Flash.nvim in operator mode (unique)
    ["s"] = { function() require("flash").jump() end, { desc = "Flash" } },
    ["S"] = { function() require("flash").treesitter() end, { desc = "Flash Treesitter" } },
    ["r"] = { function() require("flash").remote() end, { desc = "Remote Flash" } },
    ["R"] = { function() require("flash").treesitter_search() end, { desc = "Treesitter Search" } },
  },

  x = {
    -- Flash.nvim in visual block mode (unique)
    ["R"] = { function() require("flash").treesitter_search() end, { desc = "Treesitter Search" } },
  },

  c = {
    -- Flash.nvim in command mode (unique)
    ["<c-s>"] = { function() require("flash").toggle() end, { desc = "Toggle Flash Search" } },
  },
  
  t = {
    -- Word navigation in terminal mode (unique)
    ["]]"] = { function() require("snacks").words.jump(vim.v.count1) end, { desc = "Next Reference" } },
    ["[["] = { function() require("snacks").words.jump(-vim.v.count1) end, { desc = "Prev Reference" } },
  },

  i = {
    -- Save file with Ctrl+S (unique)
    ["<C-s>"] = { "<cmd>w<cr><esc>", { desc = "Save file" } },
  },
})

-- NOTE: Core keymaps are handled in lua/core/keymaps/
-- NOTE: Snacks Picker keymaps are handled in lua/core/keymaps/picker.lua
-- NOTE: LSP keymaps are handled in lua/core/keymaps/lsp.lua
-- NOTE: DAP keymaps are handled in plugins/debug.lua