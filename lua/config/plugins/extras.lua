-- Extra/optional plugins for enhanced functionality
-- Plugin files with 18+ lines get their own file, smaller ones are consolidated here

return {
  -- All extras plugins are complex enough to warrant separate files
  { import = "config.plugins.extras.ai" },
  { import = "config.plugins.extras.languages" },
  { import = "config.plugins.extras.terminal" },
  { import = "config.plugins.extras.tools" },
}