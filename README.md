# MARVIM - Masterfully Assembled Revolutionary Vim

A modern Neovim configuration that combines the best features from popular configurations:
- **bvim** - Performance and developer workflow optimizations
- **AstroNvim** - Community-driven plugin architecture
- **LazyVim** - Extras system and beginner-friendly approach
- **NvChad** - Beautiful UI and theming system
- **kickstart.nvim** - Educational clarity and simplicity

## ✨ Features

### 🚀 Performance
- Fast startup times with lazy loading
- Optimized plugin management with lazy.nvim
- Performance-first configuration choices

### 🎨 Beautiful UI
- Rose Pine theme by default with alternatives
- Modern status line with lualine
- Dashboard with ASCII art
- Enhanced notifications and command palette

### 🛠️ Developer Experience
- Comprehensive LSP support with auto-installation
- **TypeScript inlay hints enabled** for inline type information
- Intelligent completion with nvim-cmp and ghost text
- Advanced file navigation with Telescope and Harpoon
- Git integration with Gitsigns
- Format on save with conform.nvim

### 📦 Plugin Highlights
- **File Navigation**: Oil.nvim, Snacks Picker, Harpoon
- **LSP**: Full language server support with Mason
- **Completion**: nvim-cmp with multiple sources and ghost text
- **UI**: Rose Pine theme, Lualine, Which-key, Dressing
- **Editing**: Treesitter, Flash motions, Mini.surround, Comments
- **Session**: Persistence for session management
- **Extras**: Optional AI completion, testing framework

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
- `<leader>fb` - Buffers
- `<leader>/` - Live grep
- `<leader>sg` - Grep
- `<leader>sw` - Grep word under cursor
- `-` - Open Oil file explorer
- `<leader>h` - Harpoon quick menu
- `<leader>H` - Add file to Harpoon
- `<leader>1-5` - Navigate to Harpoon file 1-5
- `<leader>ftf` - Find test files
- `<leader>fbf` - Find Bloc/Cubit files
- `<leader>fp` - Find projects

### LSP
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format code
- `<leader>uh` - Toggle inlay hints (current buffer)
- `<leader>uH` - Toggle inlay hints (global)

### Git
- `<leader>gc` - Git commits
- `<leader>gs` - Git status

### Buffers & Tabs
- `<S-h>` / `<S-l>` - Previous/next buffer
- `<leader>bd` - Delete buffer
- `<leader><tab><tab>` - New tab

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

### Changing Theme
Edit `lua/plugins/ui.lua` and modify the colorscheme setup. Rose Pine is default, with alternatives:
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

## 🔧 Optional Features

Enable optional features in `lua/plugins/extras.lua`:
- AI completion and development tools
- Database integration
- Additional language support
- Testing framework (in `lua/plugins/testing.lua`)

## 🤝 Philosophy

MARVIM follows these principles:
- **Performance First**: Fast startup and responsive editing
- **Developer Focused**: Tools that enhance productivity
- **Beautiful**: Aesthetically pleasing without sacrificing function
- **Modular**: Easy to understand and customize
- **Community Driven**: Best practices from popular configurations

## 📚 Learning Resources

- Check out the original configurations this is based on:
  - [LazyVim](https://github.com/LazyVim/LazyVim)
  - [AstroNvim](https://github.com/AstroNvim/AstroNvim)
  - [NvChad](https://github.com/NvChad/NvChad)
  - [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

## 🚀 Make it so!

*"The things you own end up owning you. But a good Neovim config? That's freedom."*

Boldly configure where no one has configured before! 🖖