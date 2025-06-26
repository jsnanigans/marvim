# MARVIM - Masterfully Assembled Revolutionary Vim

A modern Neovim configuration that combines the best features from popular configurations with a unified design system and enhanced developer experience.

## ✨ Features

### 🚀 Performance
- Fast startup times with lazy loading and modern Neovim features
- Optimized plugin management with lazy.nvim
- Performance-first configuration choices
- Modern filetype detection with filetype.lua

### 🎨 Unified Rose Pine Theme System
- **Unified Theme Architecture**: Centralized theming system in `utils/theme.lua`
- **Semantic Color Mapping**: Consistent colors across all UI components
- **Rose Pine Integration**: Deep integration with Rose Pine color palette
- **Dynamic Theming**: Automatic theme reapplication on colorscheme changes
- **Plugin Consistency**: All plugins styled with unified color system

### 🛠️ Enhanced Developer Experience
- **Modern LSP Integration**: Full language server support with Mason and enhanced features
- **AI Assistance**: GitHub Copilot integration with `<C-l>` to accept suggestions
- **Smart ESLint**: Only activates when ESLint config is present in project
- **Lua Development**: lazydev.nvim for enhanced Lua/Neovim development with smart project detection
- **Intelligent Completion**: nvim-cmp with transparent floating windows and proper borders
- **Smart Breadcrumbs**: dropbar.nvim showing filename and code symbols
- **Enhanced Navigation**: Snacks picker, Harpoon, and Oil.nvim for file management
- **Word Highlighting**: vim-illuminate for highlighting same words under cursor
- **Silent LSP Hover**: No "No information available" popups for better UX
- **Advanced Options**: Modern Neovim features like jumpoptions, mousescroll, statuscolumn
- **Crash Protection**: Improved autocmd management and LSP stability

### 📦 Plugin Highlights
- **AI**: GitHub Copilot for intelligent code suggestions
- **Navigation**: dropbar.nvim breadcrumbs, Snacks Picker, Harpoon, Oil.nvim
- **LSP**: Mason, nvim-lspconfig, vtsls for TypeScript, lazydev.nvim for Lua
- **Completion**: nvim-cmp with transparent borders and smart floating windows
- **Formatting**: conform.nvim with prettier, stylua, and more
- **UI**: Unified Rose Pine theming, Lualine, Noice, nvim-notify
- **Editing**: Treesitter, Flash motions, Mini.surround, Comments
- **Highlighting**: vim-illuminate for word highlighting under cursor
- **Testing**: Neotest with enhanced status icons and specialized test file navigation
- **Session**: Persistence for session management
- **Modern Features**: Advanced Neovim capabilities like statuscolumn, improved diff mode

## 📁 Structure

```
MARVIM/
├── init.lua                 # Entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keybindings.lua # Comprehensive key mappings
│   │   ├── keymaps.lua     # Additional key mappings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   └── options.lua     # Vim options
│   ├── plugins/            # Plugin specifications
│   │   ├── core.lua        # Essential plugins
│   │   ├── editor.lua      # Editor enhancements
│   │   ├── coding.lua      # Coding features
│   │   ├── lsp.lua         # LSP configuration
│   │   ├── ui.lua          # UI and theming
│   │   ├── testing.lua     # Testing framework
│   │   └── extras.lua      # Optional features
│   └── utils/              # Utility functions
│       ├── lsp.lua         # LSP utilities
│       ├── root.lua        # Root detection utilities
│       ├── theme.lua       # Unified theming system
│       └── lsp/            # LSP utilities
│           └── keymaps.lua # LSP keymaps
└── README.md
```

## 🚀 Installation

1. **Backup your existing config:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone MARVIM:**
   ```bash
   git clone /path/to/MARVIM ~/.config/nvim
   ```

3. **Start Neovim:**
   ```bash
   nvim
   ```

4. **Wait for plugins to install** - Lazy.nvim will automatically install all plugins on first run.

5. **Set up Copilot (optional):**
   ```
   :Copilot setup
   ```
   Follow the authentication flow to enable AI assistance.

## ⌨️ Key Mappings

### General
- `<Space>` - Leader key
- `<C-s>` - Save file
- `U` - Redo (instead of Ctrl-r)
- `<Esc>` - Clear search highlighting

### File Navigation
- `<leader><leader>` - Find files (excludes tests)
- `<leader>ff` - Find files (excludes tests)
- `<leader>fr` - Recent files
- `<leader>fB` - Buffers (capital B)
- `<leader>/` - Live grep
- `<leader>sg` - Grep
- `<leader>sw` - Grep word under cursor
- `-` - Open Oil file explorer
- `<leader>h` - Harpoon quick menu
- `<leader>H` - Add file to Harpoon
- `<leader>1-5` - Navigate to Harpoon file 1-5
- `<leader>fp` - Find projects

### Specialized File Search
- `<leader>ft` - Find test files
- `<leader>st` - Search (grep) in test files
- `<leader>fb` - Find bloc/cubit files
- `<leader>sb` - Search (grep) in bloc/cubit files

### Word Highlighting & Navigation
- `]]i` - Jump to next highlighted word
- `[[i` - Jump to previous highlighted word
- Word under cursor is automatically highlighted (200ms delay)

### LSP & AI
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format code
- `<leader>cF` - Format injected languages
- `<leader>uh` - Toggle inlay hints (current buffer)
- `<leader>uH` - Toggle inlay hints (global)
- `<C-l>` - Accept Copilot suggestion (insert mode)

### Git
- `<leader>gc` - Git commits
- `<leader>gs` - Git status

### Buffers & Tabs
- `<S-h>` / `<S-l>` - Previous/next buffer
- `<leader>bd` - Delete buffer
- `<leader><tab><tab>` - New tab

### Testing
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>ta` - Run all tests
- `<leader>ts` - Toggle test summary
- `<leader>to` - Show test output
- Enhanced test status icons: ✔ (passed), ✖ (failed), ● (running), ○ (skipped)

### Debug & Troubleshooting
- `<leader>sD` - Show debug info (LSP clients, memory, autocmds)
- `<leader>sT` - Show startup time analysis

## 🎨 Customization

### Adding Plugins
Add new plugins to the appropriate file in `lua/plugins/`:
```lua
return {
  {
    "author/plugin-name",
    opts = {},
    keys = { ... },
  }
}
```

### Customizing Theme
MARVIM uses a unified theming system in `utils/theme.lua`. To customize:

**Change colors globally:**
```lua
-- Edit utils/theme.lua
M.colors = {
  base = "#your_bg_color",
  love = "#your_accent_color",
  -- ... other colors
}
```

**Change semantic mappings:**
```lua
-- Edit utils/theme.lua
M.semantic = {
  error = M.colors.love,     -- Use love for errors
  warning = M.colors.gold,   -- Use gold for warnings
  -- ... other mappings
}
```

**Switch colorschemes** (edit `lua/plugins/ui.lua`):
```lua
vim.cmd.colorscheme("rose-pine") -- or catppuccin, tokyonight, oxocarbon
```

### LSP Servers
Add new language servers in `lua/plugins/lsp.lua`:
```lua
servers = {
  your_language_server = {},
}
```

## 🔧 Modern Neovim Features

MARVIM implements cutting-edge Neovim capabilities:

### Advanced Editor Features
- **statuscolumn**: Clickable fold indicators and enhanced gutter
- **jumpoptions**: Preserve viewport when jumping between locations
- **mousescroll**: Fine-tuned mouse scrolling (3 vertical, 2 horizontal)
- **inccommand**: Live preview for substitute and other commands
- **diffopt**: Enhanced diff mode with better line matching

### Enhanced LSP Experience
- **Transparent Floating Windows**: Clean borders without background bleeding
- **Silent Hover**: No "No information available" popups
- **Smart Project Detection**: Automatic Lua project recognition for lazydev.nvim
- **Rounded Borders**: Consistent styling across all LSP floating windows
- **Word Highlighting**: Multiple providers (LSP, Treesitter, regex) for comprehensive coverage

### UI Improvements
- **Unified Theming**: Centralized Rose Pine color system
- **Smart Breadcrumbs**: Filename + code symbols via dropbar.nvim
- **Enhanced Notifications**: Better styling and positioning
- **Global Statusline**: Single statusline for all windows
- **Improved Test Icons**: Clear visual indicators for test status (✔✖●○) with proper Unicode support

## 🤝 Philosophy

MARVIM follows these principles:
- **Modern First**: Leverages latest Neovim features and capabilities
- **Unified Design**: Consistent theming and visual language across all components
- **Performance First**: Fast startup and responsive editing experience
- **Developer Focused**: Tools and features that enhance productivity
- **Elegant Simplicity**: Beautiful UI without sacrificing functionality

## 🔧 Troubleshooting

### Common Issues

**Neovim Crashes or Infinite Loops:**
- Use `<leader>sD` to check system health (memory, LSP clients, autocmds)
- If autocmd count > 1000, restart Neovim
- Run `:luafile debug_crashes.lua` for detailed monitoring

**ESLint "Unable to find library" Error:**
- Fixed! ESLint now only starts in projects with ESLint config files
- Ensure you have `.eslintrc.*` or `eslint.config.*` in your project

**Formatting Not Working:**
- Fixed! Updated conform.nvim to use new API with `stop_after_first`
- Use `<leader>cf` for LSP formatting, `<leader>cF` for injected languages

**Keymap Race Conditions:**
- Fixed! Resolved which-key conflicts with multi-character keymaps
- `<leader>ft` and `<leader>fb` now work consistently regardless of typing speed
- Diagnostic quickfix moved to `<leader>qc` to avoid conflicts

**Test Status Icons Not Visible:**
- Fixed! Updated Neotest icons to use standard Unicode characters
- New icons: ✔ (passed), ✖ (failed), ● (running), ○ (skipped), ? (unknown)
- Icons are now clearly visible in all terminal environments

**Copilot Not Working:**
- Ensure it's enabled: check `lua/plugins/extras.lua`
- Run `:Copilot setup` for authentication
- Use `<C-l>` in insert mode to accept suggestions

### Performance Optimization

If you experience slow startup or high memory usage:

1. **Check startup time:**
   ```
   <leader>sT
   ```

2. **Disable unused features:**
   ```lua
   -- In lua/plugins/extras.lua, set enabled = false for unused plugins
   -- In lua/plugins/lsp.lua, disable codelens or inlay hints if not needed
   ```

3. **Monitor system resources:**
   ```
   <leader>sD
   ```

## 📚 Learning Resources

- Check out the original configurations this is based on:
  - [LazyVim](https://github.com/LazyVim/LazyVim)
  - [AstroNvim](https://github.com/AstroNvim/AstroNvim)
  - [NvChad](https://github.com/NvChad/NvChad)
  - [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

## 🚀 Make it so!

*"The things you own end up owning you. But a good Neovim config? That's freedom."*

Boldly configure where no one has configured before! 🖖