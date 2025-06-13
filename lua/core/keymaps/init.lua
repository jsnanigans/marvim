local M = {}

-- Keymap registry to track all registered keymaps
M.registry = {}

-- Default options for keymaps
local default_opts = { noremap = true, silent = true }

-- Register keymaps with consistent options and tracking
-- @param mappings table Keymap definitions
-- @param opts table Optional default options for all mappings
function M.register(mappings, opts)
  opts = vim.tbl_extend("force", default_opts, opts or {})
  
  for mode, mode_mappings in pairs(mappings) do
    for lhs, mapping in pairs(mode_mappings) do
      local rhs, mapping_opts
      
      if type(mapping) == "table" then
        rhs = mapping[1]
        mapping_opts = vim.tbl_extend("force", opts, mapping[2] or {})
      else
        rhs = mapping
        mapping_opts = opts
      end
      
      -- Track the keymap
      M.registry[mode] = M.registry[mode] or {}
      M.registry[mode][lhs] = {
        rhs = rhs,
        opts = mapping_opts,
        source = debug.getinfo(2, "S").source,
      }
      
      -- Set the keymap
      vim.keymap.set(mode, lhs, rhs, mapping_opts)
    end
  end
end

-- Get all registered keymaps for a specific mode
-- @param mode string The mode to query (n, i, v, etc.)
-- @return table List of registered keymaps
function M.get_mappings(mode)
  return M.registry[mode] or {}
end

-- Check if a keymap is already registered
-- @param mode string The mode to check
-- @param lhs string The left-hand side of the mapping
-- @return boolean Whether the keymap exists
function M.exists(mode, lhs)
  return M.registry[mode] and M.registry[mode][lhs] ~= nil
end

-- Remove a keymap
-- @param mode string|table The mode(s) to remove the mapping from
-- @param lhs string The left-hand side of the mapping
function M.unregister(mode, lhs)
  if type(mode) == "table" then
    for _, m in ipairs(mode) do
      M.unregister(m, lhs)
    end
    return
  end
  
  if M.registry[mode] and M.registry[mode][lhs] then
    vim.keymap.del(mode, lhs)
    M.registry[mode][lhs] = nil
  end
end

-- Load keymap modules
M.lsp = require("core.keymaps.lsp")
M.telescope = require("core.keymaps.telescope")
M.editor = require("core.keymaps.editor")
M.window = require("core.keymaps.window")

-- Initialize core keymaps
function M.setup()
  -- Leader key
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"
  
  -- Core navigation and editing keymaps
  M.register({
    n = {
      -- Better navigation
      ["<C-d>"] = { "<C-d>zz", { desc = "Scroll down and center" } },
      ["<C-u>"] = { "<C-u>zz", { desc = "Scroll up and center" } },
      ["n"] = { "nzzzv", { desc = "Next search result centered" } },
      ["N"] = { "Nzzzv", { desc = "Previous search result centered" } },
      
      -- Quick save and quit
      ["<leader>w"] = { ":w<CR>", { desc = "Save file" } },
      ["<leader>q"] = { ":q<CR>", { desc = "Quit" } },
      ["<leader>Q"] = { ":qa<CR>", { desc = "Quit all" } },
      
      -- Clear search highlighting
      ["<Esc>"] = { ":noh<CR><Esc>", { desc = "Clear search highlights" } },
      
      -- Better line management
      ["<leader>o"] = { "o<Esc>", { desc = "Insert line below" } },
      ["<leader>O"] = { "O<Esc>", { desc = "Insert line above" } },
    },
    
    -- Visual mode mappings
    v = {
      -- Stay in visual mode when indenting
      ["<"] = { "<gv", { desc = "Indent left and reselect" } },
      [">"] = { ">gv", { desc = "Indent right and reselect" } },
      
      -- Move selected lines
      ["J"] = { ":m '>+1<CR>gv=gv", { desc = "Move selection down" } },
      ["K"] = { ":m '<-2<CR>gv=gv", { desc = "Move selection up" } },
      
      -- Better paste in visual mode
      ["p"] = { '"_dP', { desc = "Paste without yanking" } },
    },
    
    -- Insert mode mappings
    i = {
      -- Quick escape
      ["jk"] = { "<Esc>", { desc = "Exit insert mode" } },
      ["jj"] = { "<Esc>", { desc = "Exit insert mode" } },
    },
    
    -- Terminal mode mappings
    t = {
      ["<Esc><Esc>"] = { "<C-\\><C-n>", { desc = "Exit terminal mode" } },
      ["<C-h>"] = { "<C-\\><C-n><C-w>h", { desc = "Navigate left from terminal" } },
      ["<C-j>"] = { "<C-\\><C-n><C-w>j", { desc = "Navigate down from terminal" } },
      ["<C-k>"] = { "<C-\\><C-n><C-w>k", { desc = "Navigate up from terminal" } },
      ["<C-l>"] = { "<C-\\><C-n><C-w>l", { desc = "Navigate right from terminal" } },
    },
  })
  
  -- Load module keymaps
  M.window.setup()
  M.editor.setup()
end

return M