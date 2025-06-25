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
- Intelligent completion with nvim-cmp
- Advanced file navigation with Telescope and Harpoon
- Git integration with Gitsigns
- Format on save with conform.nvim

### 📦 Plugin Highlights
- **File Navigation**: Oil.nvim, Telescope, Harpoon
- **LSP**: Full language server support with Mason
- **Completion**: nvim-cmp with multiple sources
- **UI**: Noice.nvim, nvim-notify, dashboard
- **Editing**: Treesitter, Flash motions, auto-pairs
- **Git**: Gitsigns with comprehensive keymaps
- **Extras**: Optional AI completion, Java/Flutter support

## 📁 Structure

```
MARVIM/
├── init.lua                 # Entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   └── options.lua     # Vim options
│   ├── plugins/            # Plugin specifications
│   │   ├── core.lua        # Essential plugins
│   │   ├── editor.lua      # Editor enhancements
│   │   ├── coding.lua      # Coding features
│   │   ├── lsp.lua         # LSP configuration
│   │   ├── ui.lua          # UI and theming
│   │   └── extras.lua      # Optional features
│   └── utils/              # Utility functions
│       └── lsp/            # LSP utilities
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
- `<leader><leader>` - Find files
- `<leader>fr` - Recent files
- `<leader>/` - Live grep
- `-` - Open Oil file explorer
- `<leader>h` - Harpoon quick menu
- `<leader>H` - Add file to Harpoon

### LSP
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format code

### Git
- `]h` / `[h` - Next/previous hunk
- `<leader>ghs` - Stage hunk
- `<leader>ghr` - Reset hunk
- `<leader>ghp` - Preview hunk

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
Edit `lua/plugins/ui.lua` and modify the colorscheme setup:
```lua
vim.cmd.colorscheme("your-theme")
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
- AI completion (Supermaven/Copilot)
- Java development (nvim-java)
- Flutter development
- Terminal integration
- Database tools

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