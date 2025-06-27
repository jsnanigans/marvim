-- UI enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Rose Pine theme with simple config
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
      highlight_groups = {
        Comment = { italic = true },
        ["@keyword"] = { italic = true },
        ["@function"] = { bold = true },
        ["@variable"] = { italic = false },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
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
