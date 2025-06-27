return {
  {
    "rest-nvim/rest.nvim",
    enabled = false,
    ft = "http",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup()
    end,
  },
  {
    "tpope/vim-dadbod",
    enabled = false,
    cmd = "DB",
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = false,
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = "vim-dadbod",
    keys = function()
      return require("config.keymaps").dadbod_keys
    end,
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
    end,
  },
}
