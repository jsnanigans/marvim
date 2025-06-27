local M = {}

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
  "target",
  "vendor",
  "__pycache__",
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

-- File operation templates
M.FILE_FIND_ARGS_TEMPLATE = {
  "--type=file",
  "--hidden",
  "--follow",
}

-- Plugin dependencies for validation
M.PLUGIN_DEPS = {
  SEARCH = { "snacks" },
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
