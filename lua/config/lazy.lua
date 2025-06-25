-- Lazy.nvim setup
-- Plugin management with performance optimizations

require("lazy").setup({
  spec = {
    -- Core functionality
    { import = "plugins.core" },
    
    -- Editor enhancements
    { import = "plugins.editor" },
    
    -- Coding features
    { import = "plugins.coding" },
    
    -- LSP and completion
    { import = "plugins.lsp" },
    
    -- UI and theming
    { import = "plugins.ui" },
    
    -- Optional extras (LazyVim style)
    { import = "plugins.extras" },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  install = { colorscheme = { "rose-pine", "habamax" } },
  checker = { enabled = true, notify = false },
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