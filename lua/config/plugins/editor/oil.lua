return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    opts = {
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
      default_file_explorer = false,
    },
    keys = function() return require("config.keymaps").oil_keys end,
  },
}