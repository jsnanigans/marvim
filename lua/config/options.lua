local opt = vim.opt
local g = vim.g
g.mapleader = " "
g.maplocalleader = " "
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
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.termguicolors = true
opt.background = "dark"
opt.cursorline = true
opt.laststatus = 3
opt.showmode = false
opt.conceallevel = 2
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 0
opt.redrawtime = 10000
opt.maxmempattern = 20000
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0
opt.splitright = true
opt.splitbelow = true
opt.autoread = true
opt.confirm = true
opt.hidden = true
opt.clipboard = "unnamedplus"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = false
opt.foldlevel = 99
opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.netrw_banner = 0
g.netrw_winsize = 25
opt.jumpoptions = "view" -- Preserve viewport when jumping
opt.mousescroll = "ver:3,hor:2" -- Fine-tuned mouse scrolling
opt.mouse = "nvi" -- Enable mouse in normal, visual, and insert modes
opt.cmdheight = 1 -- Restore command line height to see LSP messages
opt.statuscolumn = "%C%s%{v:relnum?v:relnum:v:lnum} "
opt.diffopt:append("linematch:60")
opt.inccommand = "split"
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  config = config or {}
  config.border = config.border or "rounded"
  config.winhighlight = config.winhighlight or "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
  if not result or not result.contents or 
     (type(result.contents) == "table" and vim.tbl_isempty(result.contents)) or
     (type(result.contents) == "string" and result.contents == "") then
    return
  end
  return vim.lsp.handlers.hover(_, result, ctx, config)
end
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
