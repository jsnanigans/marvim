local M = {}
local keymap_utils = require("utils.keymaps")
local constants = require("config.keymap_constants")

-- These functions are now available in constants module
-- Keeping local aliases for backward compatibility
local build_file_args = constants.build_file_args
local build_grep_args = constants.build_grep_args

-- ============================================================================
-- SEARCH AND PICKER KEYMAPS
-- ============================================================================

function M.setup_search_keymaps()
  -- Validate dependencies
  local deps_ok, missing = keymap_utils.validate_dependencies(constants.PLUGIN_DEPS.SEARCH, "search_keymaps")
  if not deps_ok then
    return false
  end

  local available, snacks = keymap_utils.is_available("snacks")
  if not available or not snacks.picker then
    vim.notify("Snacks picker not available for search keymaps", vim.log.levels.WARN)
    return false
  end

  local map = keymap_utils.create_safe_mapper("search")

  -- File finding and search - excludes test files by default
  local standard_file_args = build_file_args(constants.COMMON_EXCLUDES, constants.TEST_PATTERNS)

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
      args = {
        "--type=file",
        "--hidden",
        "--follow",
        "--exclude",
        "node_modules",
        "--exclude",
        ".git",
        "\\.(test|spec)\\.(js|ts|jsx|tsx)$|_test\\.dart$|_spec\\.dart$",
      },
    })
  end, { desc = "Find Test Files" })

  map("n", "<leader>st", function()
    snacks.picker.grep({
      args = build_grep_args({
        "*.test.{js,ts,jsx,tsx}",
        "*.spec.{js,ts,jsx,tsx}",
        "*_test.dart",
        "*_spec.dart",
      }),
    })
  end, { desc = "Search in Test Files" })

  -- Bloc/Cubit file commands
  map("n", "<leader>fb", function()
    snacks.picker.files({
      args = {
        "--type=file",
        "--hidden",
        "--follow",
        "--exclude",
        "node_modules",
        "--exclude",
        ".git",
        "([Bb]loc|[Cc]ubit)\\.(ts|tsx|js|jsx)$|_bloc\\.dart$|_cubit\\.dart$",
      },
    })
  end, { desc = "Find Bloc/Cubit Files" })

  map("n", "<leader>sB", function()
    snacks.picker.grep({
      args = build_grep_args({
        "*[Bb]loc.{js,ts,jsx,tsx}",
        "*[Cc]ubit.{js,ts,jsx,tsx}",
        "*_bloc.dart",
        "*_cubit.dart",
      }),
    })
  end, { desc = "Search in Bloc/Cubit Files" })

  -- Show all files including tests
  map("n", "<leader>fT", function()
    snacks.picker.files({
      args = build_file_args(constants.COMMON_EXCLUDES),
    })
  end, { desc = "Find All Files (Including Tests)" })

  -- Feature files (implementation + tests + bloc/cubit for a feature)
  map("n", "<leader>fF", function()
    vim.ui.input({ prompt = "Feature name: " }, function(feature)
      if not feature or feature == "" then
        return
      end
      snacks.picker.files({
        args = {
          "--type=file",
          "--hidden",
          "--follow",
          "--exclude",
          "node_modules",
          "--exclude",
          ".git",
          feature,
        },
      })
    end)
  end, { desc = "Find Feature Files" })

  return true
end

return M
