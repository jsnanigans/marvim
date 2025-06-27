require("lazy").setup({
  spec = {
    -- Import all plugin categories directly
    { import = "config.plugins.core" },
    { import = "config.plugins.editor" },
    { import = "config.plugins.coding" },
    { import = "config.plugins.git" },
    { import = "config.plugins.lsp" },
    { import = "config.plugins.ui" },
    { import = "config.plugins.testing" },
    { import = "config.plugins.extras" },
  },

  defaults = {
    lazy = true,
    version = false,
  },

  install = {
    colorscheme = { "rose-pine", "habamax" },
  },

  checker = {
    enabled = true,
    notify = false,
  },

  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
      },
    },
  },

  ui = {
    border = "rounded",
    backdrop = 60,
    size = {
      width = 0.8,
      height = 0.8,
    },
  },

  dev = {
    path = "~/projects",
    patterns = {},
    fallback = false,
  },
})
