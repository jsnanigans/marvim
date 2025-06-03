-- Core Neovim options optimized for power users
local opt = vim.opt

-- General
opt.mouse = "a"                       -- Enable mouse for all modes
opt.clipboard = "unnamedplus"         -- Use system clipboard
opt.swapfile = false                  -- Disable swap files
opt.completeopt = "menu,menuone,noselect,noinsert"
opt.wildmode = "longest:full,full"    -- Better command line completion
opt.wildoptions = "pum"               -- Show completion in popup menu
opt.pumblend = 10                     -- Slightly transparent popup menu
opt.winblend = 10                     -- Slightly transparent floating windows

-- UI
opt.number = true                     -- Show line numbers
opt.relativenumber = true             -- Relative line numbers
opt.cursorline = true                 -- Highlight current line
opt.signcolumn = "yes"                -- Always show sign column
opt.colorcolumn = "100"               -- Show column at 100 chars
opt.scrolloff = 8                     -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8                 -- Keep 8 columns left/right of cursor
opt.termguicolors = true              -- True color support
opt.pumheight = 10                    -- Popup menu height

-- Indentation
opt.tabstop = 2                       -- Tab width
opt.shiftwidth = 2                    -- Indent width
opt.expandtab = true                  -- Use spaces instead of tabs
opt.smartindent = true                -- Smart auto-indenting
opt.breakindent = true                -- Maintain indent on wrapped lines

-- Search
opt.ignorecase = true                 -- Ignore case in search
opt.smartcase = true                  -- Case-sensitive if uppercase present
opt.incsearch = true                  -- Incremental search
opt.hlsearch = false                  -- Don't highlight search results

-- Performance optimizations
opt.updatetime = 250                  -- Faster completion (was 4000)
opt.timeoutlen = 300                  -- Faster key sequence timeout
opt.ttimeoutlen = 0                   -- No delay for escape sequences
opt.lazyredraw = false                -- Don't lazy redraw (can cause issues)
opt.ttyfast = true                    -- Fast terminal connection
opt.synmaxcol = 300                   -- Limit syntax highlighting column (increased from 200)
opt.maxmempattern = 20000             -- Increase pattern memory for large files
opt.regexpengine = 1                  -- Use old regexp engine (faster for some patterns)

-- Splits
opt.splitright = true                 -- Split vertical windows to right
opt.splitbelow = true                 -- Split horizontal windows below

-- Backup and undo
opt.backup = false                    -- No backup files
opt.writebackup = false               -- No backup during write
opt.undofile = true                   -- Persistent undo
opt.undolevels = 10000               -- More undo levels

-- Folding (using treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false                -- Don't fold by default
opt.foldlevel = 99                    -- High fold level by default

-- Miscellaneous
opt.conceallevel = 0                  -- Show concealed text
opt.fileencoding = "utf-8"            -- File encoding
opt.cmdheight = 1                     -- Command line height
opt.showmode = false                  -- Don't show mode (status line shows it)
opt.showtabline = 0                   -- Never show tabline
opt.wrap = false                      -- Don't wrap lines
opt.linebreak = true                  -- Break lines at word boundaries
opt.formatoptions:remove({ "c", "r", "o" }) -- Disable auto-commenting

-- Session and view options
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.viewoptions = "cursor,folds,slash,unix"

-- Fill characters
opt.fillchars = {
  eob = " ",                          -- Empty line at end of buffer
  fold = " ",                         -- Fold character
  foldsep = " ",                      -- Fold separator
  foldopen = "▾",                     -- Fold open
  foldclose = "▸",                    -- Fold close
  diff = "╱",                         -- Diff character
  vert = "│",                         -- Vertical split character
}

-- List characters (when 'list' is set)
opt.listchars = {
  tab = "» ",                         -- Tab character
  trail = "·",                        -- Trailing spaces
  nbsp = "␣",                         -- Non-breaking space
  extends = "❯",                      -- Character to show when line extends beyond screen
  precedes = "❮",                     -- Character to show when line precedes screen
}

-- Diff options
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("indent-heuristic")
opt.diffopt:append("vertical")

-- Search options
opt.inccommand = "split"              -- Show incremental command preview
opt.grepprg = "rg --vimgrep"          -- Use ripgrep for :grep
opt.grepformat = "%f:%l:%c:%m"        -- Format for ripgrep output 