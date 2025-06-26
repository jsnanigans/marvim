# Neovim Documentation Discoveries for MARVIM Enhancement

This document contains cool, useful, and interesting Neovim features discovered from the official documentation that could enhance the MARVIM configuration.

## 🚀 UI/UX Enhancements

### Global Statusline
- **Feature**: `set laststatus=3` - One statusline shared across all windows
- **MARVIM Benefit**: Cleaner UI with centralized information display

### Winbar
- **Feature**: `set winbar=%f` - Extra statusline at the top of each window
- **MARVIM Benefit**: Display buffer-specific info (file path, git status, diagnostics)

### Statuscolumn
- **Feature**: `'statuscolumn'` option with full control over the gutter
- **Supports**: Click events, custom rendering
- **MARVIM Benefit**: Interactive gutter with git signs, diagnostics, and fold indicators

### Zero-height Command Line
- **Feature**: `set cmdheight=0` (experimental)
- **MARVIM Benefit**: More screen real estate for editing

### Mouse Click Regions
- **Feature**: Clickable areas in statusline, winbar, and tabline
- **MARVIM Benefit**: Interactive UI elements for quick actions

## ✨ Advanced Editing Features

### Highlight on Yank
```lua
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({higroup="IncSearch", timeout=150, on_visual=true})
  end
})
```
- **MARVIM Benefit**: Visual feedback when yanking text

### Improved Diff Mode
- **Feature**: `set diffopt+=linematch:60` - Better same-line diff rendering
- **MARVIM Benefit**: More accurate diff visualization

### Write with Parent Creation
- **Feature**: `:write ++p` - Creates parent directories if needed
- **MARVIM Benefit**: Smoother workflow when creating files in new directories

### Live Command Preview
- **Feature**: Extends 'inccommand' to custom commands
- **MARVIM Benefit**: Real-time feedback for custom commands

## ⚡ Performance Optimizations

### Lua-based Filetype Detection
- **Feature**: `filetype.lua` - 7x faster than Vimscript version
- **Implementation**: Table-based lookup (O(1) time complexity)
- **MARVIM Benefit**: Faster startup times

### Mouse Scroll Control
```vim
set mousescroll=ver:5,hor:2
```
- **MARVIM Benefit**: Fine-tuned scrolling behavior

### Jump Options
```vim
set jumpoptions=view
```
- **MARVIM Benefit**: Preserves viewport when jumping through locations

## 🔧 LSP Enhancements

### Advanced Client Queries
```lua
-- Get clients by various filters
vim.lsp.get_active_clients({id=42})
vim.lsp.get_active_clients({bufnr=99})
vim.lsp.get_active_clients({name='tsserver'})
```

### LSP Events
- **LspAttach/LspDetach** - Better lifecycle management
- **TCP connection support** - Connect to remote language servers

## 🎯 Lua API Improvements

### Modern Key Mapping
```lua
vim.keymap.set('n', '<leader>f', function()
  -- Lua function directly as mapping
end, { desc = "Find files" })
```
- **Default**: `noremap` is true by default
- **MARVIM Benefit**: Cleaner, more maintainable keymaps

### Command API
```lua
-- Commands as functions
vim.cmd.colorscheme('nightfox')
vim.cmd.edit('file.txt')
```

### Filesystem Module
```lua
-- Find project root
local root = vim.fs.find({'.git', 'package.json'}, {upward = true})[1]
```
- **MARVIM Benefit**: Better project detection and file operations

## 🌳 Treesitter Features

### Built-in Parsers
- C, Lua, and Vimscript parsers included
- **MARVIM Benefit**: Basic syntax highlighting without external dependencies

### Advanced Features
- Incremental parsing
- Error-resilient parsing
- Mixed-language file support
- Spellcheck constrained to specific regions

## 🎨 Decorations & Virtual Text

### Extmarks
- Invisible text anchors that follow text changes
- **MARVIM Benefit**: Foundation for advanced UI plugins

### Virtual Text
- Text rendered at any position without modifying buffer
- **MARVIM Benefit**: Inline hints, documentation, type information

### Floating Window Enhancements
- Z-index support for layering
- Border support with customizable styles

## 🛠️ Developer Features

### Startup Time Analysis
```bash
nvim --startuptime startup.log
```
- Now includes Lua `require()` times
- **MARVIM Benefit**: Better performance debugging

### Better Modifier Key Support
- Distinguishes `<Tab>` from `<C-I>`, `<CR>` from `<C-M>`
- **MARVIM Benefit**: More key combinations available

### Standard Paths
```lua
vim.fn.stdpath('log')  -- Log file location
vim.fn.stdpath('state') -- Session data (not in cache)
```

## 📋 Recommended MARVIM Implementations

### High Priority
1. **Enable highlight on yank** - Immediate visual improvement
2. **Switch to filetype.lua** - Performance boost
3. **Implement global statusline** - Modern UI approach
4. **Add winbar configuration** - Better buffer information display
5. **Use vim.keymap.set** - Cleaner configuration

### Medium Priority
6. **Configure statuscolumn** - Advanced gutter features
7. **Set up mouse scrolling** - Better scrolling experience
8. **Enable jumpoptions=view** - Better navigation
9. **Implement vim.fs.find** for root detection
10. **Add live command preview** for custom commands

### Future Considerations
- Experiment with zero-height command line
- Implement clickable UI regions
- Explore virtual text for inline hints
- Add floating window borders for better UI

## 🎯 Quick Wins for MARVIM

```lua
-- Add to init.lua for immediate improvements

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({higroup="IncSearch", timeout=150})
  end
})

-- Better jump behavior
vim.opt.jumpoptions = "view"

-- Modern statusline
vim.opt.laststatus = 3

-- Mouse scrolling
vim.opt.mousescroll = "ver:3,hor:2"

-- Enable mouse by default (Neovim default)
vim.opt.mouse = "nvi"
```

These features represent the cutting edge of Neovim development and would make MARVIM a more modern, performant, and user-friendly configuration.