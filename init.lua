-- MARVIM: Malevolently Awesome Robust Vim
-- The ULTIMATE configuration combining the best of all vim distributions
-- LazyVim + AstroVim + NvChad + LunarVim = MARVIM Ultimate
-- *sigh* Because apparently perfection wasn't depressing enough

-- Record startup time for performance monitoring
vim.g.start_time = vim.fn.reltime()

-- Performance: Disable some vim defaults early for faster startup
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

-- Initialize and validate ultimate configuration
local config = require("core.config")

-- Validate configuration before proceeding
local valid, errors = config.validate()
if not valid then
  vim.api.nvim_echo({
    { "MARVIM Configuration Errors:\n", "ErrorMsg" },
    { table.concat(errors, "\n"), "WarningMsg" },
    { "\nPress any key to continue with default values..." },
  }, true, {})
  vim.fn.getchar()
end

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

-- Load custom commands (including Q, Qa aliases)
require("core.commands").setup()

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
    colorscheme = { "rose-pine", "habamax" }, -- Fallback colorschemes
  },
  -- UI configuration
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = config.ui.border,
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
  -- Update checking (controlled by config)
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
  -- Profiling (controlled by config)
  profiling = {
    loader = config.performance.lazy_redraw,
    require = false,
  },
})

-- Post-plugin setup
require("config.autocmds")

-- Initialize Ultimate UI Framework
local ui = require("core.ui")
ui.setup()


-- Initialize performance monitoring
local performance = require("config.performance")
if performance and performance.setup then
  performance.setup()
end

-- Load LSP debug utilities (safe require)
local utils = require("core.utils")
local lsp_debug = utils.safe_require("config.lsp-debug")
if lsp_debug then
  -- LSP debug is available
end

-- NOTE: Picker keymaps are now handled by our centralized keymap system

-- Add keybinding to open lazy with centralized keymap system
local keymaps = require("core.keymaps")
keymaps.register({
  n = {
    ["<leader>L"] = { "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" } },
    ["<leader>C"] = { "<cmd>Lazy clean<cr>", { desc = "Clean unused plugins" } },
    ["<leader>U"] = { "<cmd>Lazy update<cr>", { desc = "Update plugins" } },
  }
})

-- Show startup time if performance monitoring is enabled
vim.defer_fn(function()
  local start_time = vim.g.start_time or vim.fn.reltime()
  local startup_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  if tonumber(startup_time) > 0.1 then -- Only show if startup took more than 100ms
    utils.notify("Startup time: " .. startup_time .. "s", "INFO", {
      title = "MARVIM",
      timeout = 2000,
    })
  end
end, 100)