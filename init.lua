-- MARVIM: Minimal Awesome Robust Vim
-- A poweruser's dream configuration

-- Performance: Disable some vim defaults early
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Core settings (before plugins)
require("config.options")
require("config.keymaps")

-- Plugin management with optimized lazy configuration
require("lazy").setup("plugins", {
  -- Improved defaults for better performance
  defaults = {
    lazy = true, -- Make plugins lazy by default for better startup
    version = false, -- Don't version lock plugins for latest fixes
  },
  -- Installation settings
  install = {
    missing = true, -- Install missing plugins on startup
    colorscheme = { "catppuccin", "habamax" }, -- Fallback colorschemes
  },
  -- UI configuration
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = "rounded",
    backdrop = 60,
    title = "MARVIM Plugin Manager",
    title_pos = "center",
    icons = {
      cmd = " ",
      config = "",
      event = " ",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = "✔ ",
      list = { "●", "➜", "★", "‒" },
    },
  },
  -- Update checking (disabled by default for performance)
  checker = {
    enabled = false, -- Don't auto-check for updates
    notify = false, -- Don't notify about updates
    frequency = 3600, -- Check every hour when enabled
  },
  -- Performance optimizations
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
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
  -- Development settings
  dev = {
    path = "~/projects",
    patterns = {},
    fallback = false,
  },
  -- Profiling (enable for debugging startup times)
  profiling = {
    loader = false,
    require = false,
  },
})

-- Post-plugin setup
require("config.autocmds")

-- Initialize project utilities for monorepo support
require("config.project-utils").setup()

-- Initialize performance monitoring
require("config.performance").setup()

-- Load LSP debug utilities
require("config.lsp-debug")

-- Add keybinding to open lazy
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" })
