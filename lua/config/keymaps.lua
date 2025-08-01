local M = {}

-- Import modular keymap modules
local keymap_utils = require("utils.keymaps")
local core = require("config.keymaps.core")
local lsp = require("config.keymaps.lsp")
local plugins = require("config.keymaps.plugins")
local search = require("config.keymaps.search")
local root = require("config.keymaps.root")

-- Utility functions
local function is_available(module)
  local ok, mod = pcall(require, module)
  return ok and mod ~= nil
end

local function plugin_loaded(plugin_name)
  return package.loaded[plugin_name] ~= nil
end

-- ============================================================================
-- PLUGIN KEY TABLES - Re-export from plugins module
-- ============================================================================

-- Re-export all plugin key tables
M.persistence_keys = plugins.persistence_keys
M.dadbod_keys = plugins.dadbod_keys
M.copilot_keys = plugins.copilot_keys
M.undotree_keys = plugins.undotree_keys
M.dap_keys = plugins.dap_keys
M.overseer_keys = plugins.overseer_keys
M.ultest_keys = plugins.ultest_keys
M.coverage_keys = plugins.coverage_keys
M.neotest_keys = plugins.neotest_keys
M.todo_comments_keys = plugins.todo_comments_keys
M.trouble_keys = plugins.trouble_keys
M.conform_keys = plugins.conform_keys
M.luasnip_keys = plugins.luasnip_keys
M.treesitter_keys = plugins.treesitter_keys
M.illuminate_keys = plugins.illuminate_keys
M.oil_keys = plugins.oil_keys
M.dropbar_keys = plugins.dropbar_keys
M.notify_keys = plugins.notify_keys
M.noice_keys = plugins.noice_keys

-- ============================================================================
-- LSP AND GITSIGNS SETUP FUNCTIONS - Re-export from lsp module
-- ============================================================================

M.setup_lsp_keybindings = lsp.setup_lsp_keybindings
M.setup_gitsigns_keybindings = lsp.setup_gitsigns_keybindings

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
    map("n", "<leader>gxo", "<cmd>GitConflictChooseOurs<cr>", { desc = "Take Ours" })
    map("n", "<leader>gxt", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Take Theirs" })
    map("n", "<leader>gxb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Take Both" })
    map("n", "<leader>gxn", "<cmd>GitConflictChooseNone<cr>", { desc = "Take None" })
    map("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Next Conflict" })
    map("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Prev Conflict" })
  end

  -- Diffview
  if vim.fn.exists(":DiffviewOpen") == 2 then
    map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
    map("n", "<leader>gf", "<cmd>DiffviewFileHistory<cr>", { desc = "File History" })
    map("n", "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current File History" })
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
-- SETUP FUNCTION
-- ============================================================================

-- Add diagnostic command
vim.api.nvim_create_user_command("KeymapDiagnostics", function()
  keymap_utils.print_diagnostics()
end, { desc = "Show keymap diagnostics and conflicts" })

function M.setup()
  -- Setup core keymaps
  core.setup_editor()
  core.setup_windows()
  core.setup_buffers()
  core.setup_tabs()
  core.setup_terminal()
  core.setup_files()
  core.setup_diagnostics()
  core.setup_dev()

  -- Setup root operations
  root.setup_root_operations()

  -- Setup plugin keymaps (deferred to avoid conflicts)
  keymap_utils.setup_deferred(function()
    M.setup_plugin_keymaps()
    -- Setup search keymaps after plugins load
    search.setup_search_keymaps()
  end, 100, "plugin_and_search_keymaps")
end

M.setup()
return M
