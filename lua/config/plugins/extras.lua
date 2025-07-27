-- Extra/optional plugins for enhanced functionality
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Complex plugins kept in separate files
  { import = "config.plugins.extras.ai" },
  { import = "config.plugins.extras.languages" },
  { import = "config.plugins.extras.debugging" },
}
