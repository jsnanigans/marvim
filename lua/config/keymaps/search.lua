local M = {}

-- Configuration constants
local COMMON_EXCLUDES = {
  "node_modules",
  ".git",
  "dist",
  "build",
  ".next",
  "coverage",
}

local TEST_PATTERNS = {
  "*.test.*",
  "*.spec.*",
  "*_test.dart",
  "*_spec.dart",
}

local BLOC_PATTERNS = {
  "([Bb]loc|[Cc]ubit)\\.(ts|tsx|js|jsx)$",
  "_bloc\\.dart$",
  "_cubit\\.dart$",
}

local GREP_ARGS = {
  "--column",
  "--line-number",
  "--no-heading",
  "--color=never",
  "--smart-case",
  "--with-filename",
}

-- Utility function
local function is_available(module)
  local ok, mod = pcall(require, module)
  return ok and mod ~= nil
end

-- Helper function to build file find args
local function build_file_args(excludes, patterns)
  local args = {
    "--type=file",
    "--hidden",
    "--follow",
  }
  
  for _, exclude in ipairs(excludes or COMMON_EXCLUDES) do
    table.insert(args, "--exclude")
    table.insert(args, exclude)
  end
  
  if patterns then
    for _, pattern in ipairs(patterns) do
      table.insert(args, pattern)
    end
  end
  
  return args
end

-- Helper function to build grep args
local function build_grep_args(globs)
  local args = vim.list_extend({}, GREP_ARGS)
  
  if globs then
    for _, glob in ipairs(globs) do
      table.insert(args, "--glob")
      table.insert(args, glob)
    end
  end
  
  return args
end

-- ============================================================================
-- SEARCH AND PICKER KEYMAPS
-- ============================================================================

function M.setup_search_keymaps()
  if not is_available("snacks") then
    return
  end

  local snacks = require("snacks")
  if not snacks.picker then
    return
  end

  local map = vim.keymap.set

  -- File finding and search - excludes test files by default
  local standard_file_args = build_file_args(vim.list_extend({}, COMMON_EXCLUDES), TEST_PATTERNS)
  
  map("n", "<leader><leader>", function()
    snacks.picker.files({ args = standard_file_args })
  end, { desc = "Find Files" })

  map("n", "<leader>ff", function()
    snacks.picker.files({ args = standard_file_args })
  end, { desc = "Find Files" })

  -- Recent files and buffers
  map("n", "<leader>fr", function()
    snacks.picker.recent()
  end, { desc = "Recent Files" })
  
  map("n", "<leader>fB", function()
    snacks.picker.buffers()
  end, { desc = "Buffers" })

  -- Search functionality
  map("n", "<leader>/", function()
    snacks.picker.grep()
  end, { desc = "Grep" })
  
  map("n", "<leader>sg", function()
    snacks.picker.grep()
  end, { desc = "Grep" })
  
  map("n", "<leader>sw", function()
    snacks.picker.grep_string()
  end, { desc = "Grep Word" })

  -- Command and help search
  map("n", "<leader>sc", function()
    snacks.picker.commands()
  end, { desc = "Commands" })
  
  map("n", "<leader>sh", function()
    snacks.picker.help()
  end, { desc = "Help Pages" })
  
  map("n", "<leader>sk", function()
    snacks.picker.keymaps()
  end, { desc = "Key Maps" })
  
  map("n", "<leader>ss", function()
    snacks.picker.files()
  end, { desc = "Select Files" })
  
  map("n", "<leader>sa", function()
    snacks.picker.autocmds()
  end, { desc = "Auto Commands" })
  
  map("n", "<leader>sb", function()
    snacks.picker.lines()
  end, { desc = "Buffer Lines" })
  
  map("n", "<leader>:", function()
    snacks.picker.command_history()
  end, { desc = "Command History" })
  
  map("n", "<leader>sR", function()
    snacks.picker.resume()
  end, { desc = "Resume" })

  -- Git integration
  map("n", "<leader>gc", function()
    snacks.picker.git_log()
  end, { desc = "Git Commits" })
  
  map("n", "<leader>gs", function()
    snacks.picker.git_status()
  end, { desc = "Git Status" })

  -- LSP symbol search (global)
  map("n", "<leader>sS", function()
    snacks.picker.lsp_workspace_symbols()
  end, { desc = "Workspace Symbols" })

  -- Test file commands
  map("n", "<leader>ft", function()
    snacks.picker.files({
      args = build_file_args({ "node_modules", ".git" }, { "\\.(test|spec)\\.(js|ts|jsx|tsx)$|_test\\.dart$|_spec\\.dart$" })
    })
  end, { desc = "Find Test Files" })

  map("n", "<leader>st", function()
    snacks.picker.grep({
      args = build_grep_args({
        "*.test.{js,ts,jsx,tsx}",
        "*.spec.{js,ts,jsx,tsx}",
        "*_test.dart",
        "*_spec.dart",
      })
    })
  end, { desc = "Search in Test Files" })

  -- Bloc/Cubit file commands
  map("n", "<leader>fb", function()
    snacks.picker.files({
      args = build_file_args({ "node_modules", ".git" }, BLOC_PATTERNS)
    })
  end, { desc = "Find Bloc/Cubit Files" })

  map("n", "<leader>sB", function()
    snacks.picker.grep({
      args = build_grep_args({
        "*[Bb]loc.{js,ts,jsx,tsx}",
        "*[Cc]ubit.{js,ts,jsx,tsx}",
        "*_bloc.dart",
        "*_cubit.dart",
      })
    })
  end, { desc = "Search in Bloc/Cubit Files" })

  -- Show all files including tests
  map("n", "<leader>fT", function()
    snacks.picker.files({
      args = build_file_args(COMMON_EXCLUDES)
    })
  end, { desc = "Find All Files (Including Tests)" })

  -- Feature files (implementation + tests + bloc/cubit for a feature)
  map("n", "<leader>fF", function()
    vim.ui.input({ prompt = "Feature name: " }, function(feature)
      if not feature or feature == "" then
        return
      end
      snacks.picker.files({
        args = build_file_args({ "node_modules", ".git" }, { feature })
      })
    end)
  end, { desc = "Find Feature Files" })

  -- Projects picker
  map("n", "<leader>fp", function()
    snacks.picker.files({
      cwd = vim.fn.expand("~/Projects"),
      find_command = { "find", ".", "-type", "d", "-name", ".git" },
      prompt_title = "Projects",
    })
  end, { desc = "Find Projects" })
end

return M