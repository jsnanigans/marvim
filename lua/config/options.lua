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

-- Modern Neovim features from documentation discoveries
opt.jumpoptions = "view" -- Preserve viewport when jumping
opt.mousescroll = "ver:3,hor:2" -- Fine-tuned mouse scrolling
opt.mouse = "nvi" -- Enable mouse in normal, visual, and insert modes
opt.cmdheight = 1 -- Restore command line height to see LSP messages

-- Modern Neovim already uses filetype.lua by default, no need to set explicitly

-- Configure statuscolumn for advanced gutter features
-- This gives us clickable fold indicators, sign column, and line numbers
opt.statuscolumn = "%C%s%{v:relnum?v:relnum:v:lnum} "

-- Improved diff mode with better line matching
opt.diffopt:append("linematch:60")

-- Live command preview for substitute and other commands
opt.inccommand = "split"

-- Configure floating window borders globally
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { 
  border = "rounded",
  winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { 
  border = "rounded",
  winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
})
vim.diagnostic.config({ 
  float = { 
    border = "rounded",
    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
  } 
})

-- Better modifier key support (distinguish Tab from Ctrl-I, etc.)
-- This is automatically supported in modern Neovim

-- Enhanced session data handling (uses XDG_STATE_HOME by default)
-- This is automatically handled by modern Neovim