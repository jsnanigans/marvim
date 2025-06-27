-- UI enhancement plugins
-- Plugin files with 18+ lines get their own file, smaller ones are consolidated here

return {
  -- All UI plugins are complex enough to warrant separate files
  { import = "config.plugins.ui.theme" },
  { import = "config.plugins.ui.statusline" },
  { import = "config.plugins.ui.notifications" },
  { import = "config.plugins.ui.dashboard" },
  { import = "config.plugins.ui.indentation" },
  { import = "config.plugins.ui.breadcrumbs" },
}