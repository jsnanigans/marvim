local opt = vim.opt
local g = vim.g

-- Leaders
g.mapleader = " "
g.maplocalleader = " "

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- Text display
opt.wrap = false
opt.breakindent = true
opt.cursorline = true
opt.conceallevel = 2
opt.list = true
opt.listchars = {
  tab = "▸ ",
  trail = "·",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"

-- Colors and appearance
opt.termguicolors = true
opt.background = "dark"
opt.laststatus = 3
opt.showmode = false
opt.statuscolumn = "%C%s%{v:relnum?v:relnum:v:lnum} "

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mousescroll = "ver:3,hor:2"
opt.mouse = "nvi"
opt.jumpoptions = "view"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 0
opt.redrawtime = 10000
opt.maxmempattern = 20000

-- File handling
opt.undofile = true
opt.undolevels = 1000 -- Reduced from 10000 for better memory usage
opt.undoreload = 5000 -- Reduced from 10000
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.autoread = true
opt.confirm = true
opt.hidden = true

-- Filetype detection
vim.cmd("filetype plugin indent on")

-- Completion
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Folding
opt.foldmethod = "manual" -- Start with manual, set to expr per-buffer when treesitter loads
opt.foldexpr = ""
opt.foldenable = false
opt.foldlevel = 99

-- Diff
opt.diffopt:append("linematch:60")

-- Command line
opt.cmdheight = 1

-- Disable providers
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0

-- Netrw
g.netrw_banner = 0
g.netrw_winsize = 25

-- Tmux navigation
g.tmux_navigation_enabled = true
