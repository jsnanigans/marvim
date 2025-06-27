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
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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

-- LSP handlers
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  config = config or {}
  config.border = config.border or "rounded"
  config.winhighlight = config.winhighlight or "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
  if
    not result
    or not result.contents
    or (type(result.contents) == "table" and vim.tbl_isempty(result.contents))
    or (type(result.contents) == "string" and result.contents == "")
  then
    return
  end
  return vim.lsp.handlers.hover(_, result, ctx, config)
end

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
  winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
})

vim.diagnostic.config({
  float = {
    border = "rounded",
    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
  },
})
