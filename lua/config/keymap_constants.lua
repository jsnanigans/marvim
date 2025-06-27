local M = {}

-- ============================================================================
-- KEYMAP CONFIGURATION CONSTANTS
-- ============================================================================

-- Common file excludes for search operations
M.COMMON_EXCLUDES = {
  "node_modules",
  ".git",
  "dist",
  "build",
  ".next",
  "coverage",
  ".svelte-kit",
  ".nuxt",
  "target", -- Rust
  "vendor", -- Go/PHP
  "__pycache__", -- Python
  ".pytest_cache",
  ".mypy_cache",
  ".tox",
  "venv",
  ".venv",
}

-- Test file patterns
M.TEST_PATTERNS = {
  "*.test.*",
  "*.spec.*",
  "*_test.dart",
  "*_spec.dart",
  "*Test.java",
  "*_test.go",
  "*_test.py",
  "test_*.py",
}

-- Bloc/Cubit patterns for Flutter/Dart projects
M.BLOC_PATTERNS = {
  "([Bb]loc|[Cc]ubit)\\.(ts|tsx|js|jsx)$",
  "_bloc\\.dart$",
  "_cubit\\.dart$",
}

-- Common grep arguments
M.GREP_ARGS = {
  "--column",
  "--line-number",
  "--no-heading",
  "--color=never",
  "--smart-case",
  "--with-filename",
}

-- Leader key prefixes for organization
M.LEADER_PREFIXES = {
  -- Core operations
  BUFFER = "<leader>b", -- Buffer operations
  WINDOW = "<leader>w", -- Window operations
  TAB = "<leader><tab>", -- Tab operations
  FILE = "<leader>f", -- File operations (fp=projects in root module)

  -- Search and navigation
  SEARCH = "<leader>s", -- Search operations
  GOTO = "g", -- Go-to operations
  JUMP = "]", -- Forward jumps
  JUMP_BACK = "[", -- Backward jumps

  -- Code operations
  CODE = "<leader>c", -- Code actions
  LSP = "<leader>l", -- LSP management
  WORKSPACE = "<leader>w", -- Workspace operations

  -- Testing
  TEST = "<leader>t", -- Test operations

  -- Git operations
  GIT = "<leader>g", -- Git operations
  GIT_HUNK = "<leader>gh", -- Git hunk operations
  GIT_CONFLICT = "<leader>gc", -- Git conflict resolution

  -- UI toggles
  UI = "<leader>u", -- UI toggles

  -- Diagnostics and troubleshooting
  DIAGNOSTIC = "<leader>x", -- Diagnostics
  QUICKFIX = "<leader>q", -- Quickfix operations

  -- Session management
  SESSION = "<leader>q", -- Session operations

  -- Terminal
  TERMINAL = "<leader>T", -- Terminal operations

  -- Extras
  DATABASE = "<leader>D", -- Database operations
  OVERSEER = "<leader>to", -- Task operations
}

-- File operation templates
M.FILE_FIND_ARGS_TEMPLATE = {
  "--type=file",
  "--hidden",
  "--follow",
}

-- Diagnostic severity levels
M.DIAGNOSTIC_SEVERITY = {
  ERROR = vim.diagnostic.severity.ERROR,
  WARN = vim.diagnostic.severity.WARN,
  INFO = vim.diagnostic.severity.INFO,
  HINT = vim.diagnostic.severity.HINT,
}

-- Key modes for documentation
M.KEY_MODES = {
  NORMAL = "n",
  INSERT = "i",
  VISUAL = "v",
  VISUAL_LINE = "V",
  VISUAL_BLOCK = "<C-v>",
  SELECT = "s",
  OPERATOR = "o",
  TERMINAL = "t",
  COMMAND = "c",
  MULTIPLE = { "n", "v" },
  MULTIPLE_INSERT = { "i", "s" },
  MULTIPLE_VISUAL = { "x", "o" },
}

-- Common keymap options
M.KEYMAP_OPTS = {
  SILENT = { silent = true },
  NOREMAP = { noremap = true },
  EXPR = { expr = true },
  SILENT_NOREMAP = { silent = true, noremap = true },
  BUFFER_LOCAL = function(buffer)
    return { buffer = buffer }
  end,
  WITH_DESC = function(desc)
    return { desc = desc }
  end,
  SILENT_WITH_DESC = function(desc)
    return { silent = true, desc = desc }
  end,
}

-- Plugin dependencies for validation
M.PLUGIN_DEPS = {
  SEARCH = { "snacks" },
  LSP = { "lspconfig" },
  TREESITTER = { "nvim-treesitter" },
  COMPLETION = { "blink.cmp" },
  GIT = { "gitsigns" },
  TESTING = { "neotest" },
  TERMINAL = { "toggleterm" },
  HARPOON = { "harpoon" },
  FLASH = { "flash" },
  COMMENT = { "Comment" },
  SURROUND = { "mini.surround" },
  BUFREMOVE = { "mini.bufremove" },
}

-- Timeout values (in milliseconds)
M.TIMEOUTS = {
  KEYMAP_DEFER = 100,
  FORMAT_TIMEOUT = 3000,
  LSP_TIMEOUT = 5000,
}

-- Project-specific paths
M.PATHS = {
  PROJECTS_DIR = vim.fn.expand("~/Projects"),
  TEMP_DIR = "/tmp",
  STARTUP_LOG = "/tmp/nvim_startup.log",
}

-- Error message templates
M.ERROR_TEMPLATES = {
  MODULE_LOAD_FAILED = "Failed to load module '%s': %s",
  KEYMAP_CONFLICT = "Keymap conflict: %s already bound to %s",
  PLUGIN_NOT_AVAILABLE = "Plugin '%s' not available for %s functionality",
  INVALID_KEYMAP_TABLE = "Invalid keymap table provided by %s",
  DEPENDENCY_MISSING = "Missing dependencies for %s: %s",
}

-- Helper function to build file args with excludes
function M.build_file_args(excludes, extra_excludes)
  local args = vim.deepcopy(M.FILE_FIND_ARGS_TEMPLATE)

  -- Add common excludes
  for _, exclude in ipairs(excludes or M.COMMON_EXCLUDES) do
    table.insert(args, "--exclude")
    table.insert(args, exclude)
  end

  -- Add extra excludes (like test patterns)
  if extra_excludes then
    for _, exclude in ipairs(extra_excludes) do
      table.insert(args, "--exclude")
      table.insert(args, exclude)
    end
  end

  return args
end

-- Helper function to build grep args with globs
function M.build_grep_args(globs)
  local args = vim.deepcopy(M.GREP_ARGS)

  if globs then
    for _, glob in ipairs(globs) do
      table.insert(args, "--glob")
      table.insert(args, glob)
    end
  end

  return args
end

-- Helper to get error message with formatting
function M.get_error_message(template_key, ...)
  local template = M.ERROR_TEMPLATES[template_key]
  if not template then
    return string.format("Unknown error template: %s", template_key)
  end
  return string.format(template, ...)
end

return M
