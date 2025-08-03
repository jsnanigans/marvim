-- UI enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Rose Pine theme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,

        groups = {
          background = "base",
          background_nc = "_experimental_nc",
          panel = "surface",
          panel_nc = "base",
          border = "highlight_med",
          comment = "muted",
          link = "iris",
          punctuation = "subtle",

          error = "love",
          hint = "iris",
          info = "foam",
          warn = "gold",

          headings = {
            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
          },
        },

        highlight_groups = {
          -- Transparent background if desired
          -- Normal = { bg = "none" },
          -- NormalFloat = { bg = "none" },
        },
      })

      -- Load colorscheme
      vim.cmd.colorscheme("rose-pine")

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
