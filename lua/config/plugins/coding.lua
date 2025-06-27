-- Coding enhancement plugins
-- Plugin files with 18+ lines get their own file, smaller ones are consolidated here

return {
  -- All coding plugins are complex enough to warrant separate files
  { import = "config.plugins.coding.treesitter" },
  { import = "config.plugins.coding.snippets" },
  { import = "config.plugins.coding.conform" },
  { import = "config.plugins.coding.trouble" },
  { import = "config.plugins.coding.todo-comments" },
}
