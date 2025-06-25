-- MARVIM Ultimate Keybinding System
-- Combining the best keybinding philosophies from all major vim distributions
-- With conflict detection, discovery, and Marvin's touch of organized despair

local M = {}
local config = require("core.config")

-- Keymap registry to track all registered keymaps
M.registry = {}

-- Conflict tracking
M.conflicts = {}

-- Which-key integration
M.which_key_groups = {}

-- Default options for keymaps
local default_opts = { noremap = true, silent = true }

-- Register keymaps with conflict detection and which-key integration
-- @param mappings table Keymap definitions
-- @param opts table Optional default options for all mappings
function M.register(mappings, opts)
  opts = vim.tbl_extend("force", default_opts, opts or {})
  
  for mode, mode_mappings in pairs(mappings) do
    for lhs, mapping in pairs(mode_mappings) do
      local rhs, mapping_opts, desc, group
      
      if type(mapping) == "table" then
        rhs = mapping[1]
        mapping_opts = vim.tbl_extend("force", opts, mapping[2] or {})
        desc = mapping_opts.desc
        group = mapping_opts.group
      else
        rhs = mapping
        mapping_opts = opts
      end
      
      -- Check for conflicts if enabled
      if config.get("keymaps.conflict_detection", true) then
        M._check_conflict(mode, lhs, rhs, mapping_opts)
      end
      
      -- Track the keymap
      M.registry[mode] = M.registry[mode] or {}
      M.registry[mode][lhs] = {
        rhs = rhs,
        opts = mapping_opts,
        desc = desc,
        source = debug.getinfo(2, "S").source,
        timestamp = os.time(),
      }
      
      -- Register with which-key if available and enabled
      if config.get("keymaps.which_key.enabled", true) and desc then
        M._register_which_key(mode, lhs, desc, group)
      end
      
      -- Set the keymap
      vim.keymap.set(mode, lhs, rhs, mapping_opts)
    end
  end
end

-- Check for keymap conflicts
function M._check_conflict(mode, lhs, rhs, opts)
  if M.registry[mode] and M.registry[mode][lhs] then
    local existing = M.registry[mode][lhs]
    local conflict = {
      mode = mode,
      lhs = lhs,
      existing = {
        rhs = existing.rhs,
        source = existing.source,
        desc = existing.desc,
      },
      new = {
        rhs = rhs,
        source = debug.getinfo(3, "S").source,
        desc = opts.desc,
      },
      timestamp = os.time(),
    }
    
    table.insert(M.conflicts, conflict)
    
    -- Warn about conflict
    local utils = require("core.utils")
    utils.notify(
      string.format("Keymap conflict: %s %s already exists", mode, lhs),
      "WARN",
      { title = "MARVIM Keymaps" }
    )
  end
end

-- Register keymap with which-key
function M._register_which_key(mode, lhs, desc, group)
  local has_which_key, wk = pcall(require, "which-key")
  if not has_which_key then
    return
  end
  
  -- Store for later registration
  M.which_key_groups[mode] = M.which_key_groups[mode] or {}
  M.which_key_groups[mode][lhs] = {
    desc = desc,
    group = group,
  }
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
M.picker = require("core.keymaps.picker")
M.editor = require("core.keymaps.editor")
M.window = require("core.keymaps.window")

-- Get conflicts report
function M.get_conflicts()
  return M.conflicts
end

-- Clear conflict history
function M.clear_conflicts()
  M.conflicts = {}
end

-- Register leader group descriptions for which-key (NEW SPEC)
function M.register_leader_groups()
  local leader_groups = {
    { "<leader>f", group = "Find/Files" },
    { "<leader>g", group = "Git" },
    { "<leader>l", group = "LSP" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Toggle/Terminal" },
    { "<leader>w", group = "Window" },
    { "<leader>b", group = "Buffer" },
    { "<leader>d", group = "Diagnostics/Debug" },
    { "<leader>h", group = "Help" },
    { "<leader>c", group = "Code" },
    { "<leader>x", group = "Quickfix/Trouble" },
    { "<leader>u", group = "UI/Toggle" },
    { "<leader>ut", group = "Theme" },
    { "<leader>a", group = "AI" },
    { "<leader>p", group = "Project" },
    { "<leader>r", group = "Replace/Refactor" },
    { "<leader>n", group = "Notes" },
    { "<leader>m", group = "Marks/Bookmarks" },
    { "<leader><tab>", group = "Tabs" },
    { "<leader>G", group = "Go to (Direct)" },
    { "<leader>lm", group = "LSP Management" },
  }
  
  local has_which_key, wk = pcall(require, "which-key")
  if has_which_key then
    wk.add(leader_groups)
  end
end

-- Setup all which-key registrations
function M.setup_which_key()
  local has_which_key, wk = pcall(require, "which-key")
  if not has_which_key then
    return
  end
  
  -- Register leader groups
  M.register_leader_groups()
  
  -- Register collected keymaps (NEW SPEC)
  local all_mappings = {}
  for mode, mappings in pairs(M.which_key_groups) do
    for lhs, info in pairs(mappings) do
      table.insert(all_mappings, { lhs, desc = info.desc, mode = mode })
    end
  end
  if next(all_mappings) then
    wk.add(all_mappings)
  end
end

-- Health check for keymaps
function M.health()
  local total_keymaps = 0
  local mode_counts = {}
  
  for mode, mappings in pairs(M.registry) do
    local count = 0
    for _ in pairs(mappings) do
      count = count + 1
    end
    mode_counts[mode] = count
    total_keymaps = total_keymaps + count
  end
  
  return {
    total = total_keymaps,
    by_mode = mode_counts,
    conflicts = #M.conflicts,
    which_key_enabled = config.get("keymaps.which_key.enabled", true),
    conflict_detection_enabled = config.get("keymaps.conflict_detection", true),
  }
end

-- Initialize ultimate keymaps system
function M.setup()
  -- Set leader keys from config
  local keymaps_config = config.get("keymaps", {})
  vim.g.mapleader = keymaps_config.leader or " "
  vim.g.maplocalleader = keymaps_config.localleader or "\\"
  
  -- Ultimate core keymaps (best of all distributions, conflict-free)
  M.register({
    n = {
      -- Navigation (centered for better visibility)
      ["<C-d>"] = { "<C-d>zz", { desc = "Scroll down and center" } },
      ["<C-u>"] = { "<C-u>zz", { desc = "Scroll up and center" } },
      ["n"] = { "nzzzv", { desc = "Next search result centered" } },
      ["N"] = { "Nzzzv", { desc = "Previous search result centered" } },
      
      -- File operations (streamlined)
      ["<leader>w"] = { ":w<CR>", { desc = "Save file" } },
      ["<leader>W"] = { ":wa<CR>", { desc = "Save all files" } },
      ["<leader>q"] = { ":q<CR>", { desc = "Quit" } },
      ["<leader>Q"] = { ":qa!<CR>", { desc = "Force quit all" } },
      
      -- Search and replace
      ["<Esc>"] = { ":noh<CR><Esc>", { desc = "Clear search highlights" } },
      ["<leader>rw"] = { ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" } },
      
      -- Line management
      ["<leader>o"] = { "o<Esc>", { desc = "Insert line below" } },
      ["<leader>O"] = { "O<Esc>", { desc = "Insert line above" } },
      ["<A-j>"] = { ":m .+1<CR>==", { desc = "Move line down" } },
      ["<A-k>"] = { ":m .-2<CR>==", { desc = "Move line up" } },
      
      -- Quick buffer navigation (muscle memory friendly)
      ["<S-h>"] = { ":bprevious<CR>", { desc = "Previous buffer" } },
      ["<S-l>"] = { ":bnext<CR>", { desc = "Next buffer" } },
      
      -- Tab management
      ["<leader><tab>n"] = { ":tabnew<CR>", { desc = "New tab" } },
      ["<leader><tab>c"] = { ":tabclose<CR>", { desc = "Close tab" } },
      ["<leader><tab>]"] = { ":tabnext<CR>", { desc = "Next tab" } },
      ["<leader><tab>["] = { ":tabprevious<CR>", { desc = "Previous tab" } },
      
      -- Quick actions
      ["<leader>fR"] = { ":e!<CR>", { desc = "Reload file" } },
      
      -- System clipboard operations (y for yank, Y for line)
      ["gy"] = { '"+y', { desc = "Copy to system clipboard" } },
      ["gY"] = { '"+Y', { desc = "Copy line to system clipboard" } },
      ["gp"] = { '"+p', { desc = "Paste from system clipboard" } },
      ["gP"] = { '"+P', { desc = "Paste before from system clipboard" } },
      
      -- Diagnostic navigation (conflicts moved to lsp module)
      ["]e"] = { vim.diagnostic.goto_next, { desc = "Next diagnostic" } },
      ["[e"] = { vim.diagnostic.goto_prev, { desc = "Previous diagnostic" } },
      ["<leader>de"] = { vim.diagnostic.open_float, { desc = "Show line diagnostics" } },
      ["<leader>dq"] = { vim.diagnostic.setloclist, { desc = "Show buffer diagnostics" } },
      
      -- UI toggles (under u for UI)
      ["<leader>uh"] = { ":set hlsearch!<CR>", { desc = "Toggle search highlight" } },
      ["<leader>ul"] = { ":set number!<CR>", { desc = "Toggle line numbers" } },
      ["<leader>ur"] = { ":set relativenumber!<CR>", { desc = "Toggle relative numbers" } },
      ["<leader>uw"] = { ":set wrap!<CR>", { desc = "Toggle word wrap" } },
      ["<leader>us"] = { ":set spell!<CR>", { desc = "Toggle spell check" } },
      ["<leader>ui"] = { ":set list!<CR>", { desc = "Toggle invisible characters" } },
    },
    
    -- Visual mode mappings
    v = {
      -- Indentation (stay in visual mode)
      ["<"] = { "<gv", { desc = "Indent left and reselect" } },
      [">"] = { ">gv", { desc = "Indent right and reselect" } },
      
      -- Move selected lines
      ["J"] = { ":m '>+1<CR>gv=gv", { desc = "Move selection down" } },
      ["K"] = { ":m '<-2<CR>gv=gv", { desc = "Move selection up" } },
      ["<A-j>"] = { ":m '>+1<CR>gv=gv", { desc = "Move selection down" } },
      ["<A-k>"] = { ":m '<-2<CR>gv=gv", { desc = "Move selection up" } },
      
      -- Better paste (doesn't overwrite register)
      ["p"] = { '"_dP', { desc = "Paste without yanking" } },
      
      -- Clipboard operations
      ["gy"] = { '"+y', { desc = "Copy selection to system clipboard" } },
      ["<leader>d"] = { '"_d', { desc = "Delete without yanking" } },
      
      -- Search and replace in selection
      ["<leader>rv"] = { ":s/\\%V", { desc = "Replace in selection" } },
    },
    
    -- Insert mode mappings
    i = {
      -- Quick escape (jk is most ergonomic)
      ["jk"] = { "<Esc>", { desc = "Exit insert mode" } },
      
      -- Navigation in insert mode
      ["<C-h>"] = { "<Left>", { desc = "Move left" } },
      ["<C-l>"] = { "<Right>", { desc = "Move right" } },
      ["<C-j>"] = { "<Down>", { desc = "Move down" } },
      ["<C-k>"] = { "<Up>", { desc = "Move up" } },
      
      -- Word navigation
      ["<C-b>"] = { "<C-Left>", { desc = "Move word backward" } },
      ["<C-f>"] = { "<C-Right>", { desc = "Move word forward" } },
      
      -- Line operations
      ["<C-a>"] = { "<C-o>^", { desc = "Go to line start" } },
      ["<C-e>"] = { "<C-o>$", { desc = "Go to line end" } },
    },
    
    -- Terminal mode mappings
    t = {
      ["<Esc><Esc>"] = { "<C-\\><C-n>", { desc = "Exit terminal mode" } },
      ["<C-h>"] = { "<C-\\><C-n><C-w>h", { desc = "Navigate left from terminal" } },
      ["<C-j>"] = { "<C-\\><C-n><C-w>j", { desc = "Navigate down from terminal" } },
      ["<C-k>"] = { "<C-\\><C-n><C-w>k", { desc = "Navigate up from terminal" } },
      ["<C-l>"] = { "<C-\\><C-n><C-w>l", { desc = "Navigate right from terminal" } },
      ["<C-w>"] = { "<C-\\><C-n><C-w>", { desc = "Window commands" } },
    },
    
    -- Command mode mappings
    c = {
      ["<C-a>"] = { "<Home>", { desc = "Go to beginning" } },
      ["<C-e>"] = { "<End>", { desc = "Go to end" } },
      ["<C-h>"] = { "<Left>", { desc = "Move left" } },
      ["<C-l>"] = { "<Right>", { desc = "Move right" } },
      ["<C-j>"] = { "<Down>", { desc = "Next command" } },
      ["<C-k>"] = { "<Up>", { desc = "Previous command" } },
    },
  })
  
  -- Load specialized keymap modules
  M.window.setup()
  M.editor.setup()
  M.picker.setup()
  M.lsp.setup()
  
  -- Set up which-key integration after all keymaps are registered
  vim.defer_fn(function()
    M.setup_which_key()
  end, 100)
end

return M