-- Testing framework plugins
-- Plugin files with 18+ lines get their own file, smaller ones are consolidated here

return {
  -- All testing plugins are complex enough to warrant separate files
  { import = "config.plugins.testing.neotest" },
  { import = "config.plugins.testing.coverage" },
  { import = "config.plugins.testing.ultest" },
  { import = "config.plugins.testing.overseer" },
}
