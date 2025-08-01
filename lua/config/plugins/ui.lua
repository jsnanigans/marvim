-- UI enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Nord theme
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Set nord options before loading
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true

      -- Load colorscheme
      vim.cmd.colorscheme("nord")

      -- Apply custom theme utilities
      vim.schedule(function()
        local ok, theme = pcall(require, "utils.theme")
        if ok then
          theme.setup()
        end
      end)
    end,
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.ui.statusline" },
  { import = "config.plugins.ui.notifications" },
  { import = "config.plugins.ui.indentation" },
  { import = "config.plugins.ui.breadcrumbs" },
}
