-- Options configuration
-- Combining best practices from all configs

local opt = vim.opt
local g = vim.g

-- Leader key
g.mapleader = " "
g.maplocalleader = " "

-- Core editor settings
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.wrap = false
opt.breakindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Visual settings
opt.termguicolors = true
opt.background = "dark"
opt.cursorline = true
opt.laststatus = 3
opt.showmode = false
opt.conceallevel = 2
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 0
opt.redrawtime = 10000
opt.maxmempattern = 20000

-- Undo and backup
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Completion
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0

-- Splits
opt.splitright = true
opt.splitbelow = true

-- File handling
opt.autoread = true
opt.confirm = true
opt.hidden = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Fold settings
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- List characters
opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}

-- Disable some default providers
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0

-- Netrw settings
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1