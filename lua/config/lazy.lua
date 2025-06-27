local plugins = require("plugins")

require("lazy").setup({
  spec = plugins.generate_spec(),
  
  defaults = {
    lazy = true,
    version = false,
  },
  
  install = { 
    colorscheme = { "rose-pine", "habamax" } 
  },
  
  checker = { 
    enabled = true, 
    notify = false 
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