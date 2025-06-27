# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About MARVIM

MARVIM is a Neovim configuration built with lazy loading and modular architecture. It uses `lazy.nvim` as the plugin manager and organizes plugins into categories (core, editor, coding, git, lsp, ui, testing, extras).

## Architecture

The configuration follows a modular structure:

- `init.lua` - Entry point that sets up lazy.nvim and loads core configs
- `lua/config/` - Core configuration (options, keymaps, autocmds, lazy setup)
- `lua/config/plugins/` - Plugin configurations organized by category with subdirectories
- No separate plugin registry - uses lazy.nvim's import system directly
- `lua/utils/` - Utility functions (LSP, root detection, theming)

### Plugin Management System

The configuration uses lazy.nvim's standard import system with a streamlined structure:
- Plugin specs are organized into category modules under `lua/config/plugins/`
- Each category (core, editor, coding, git, lsp, ui, testing, extras) has its own subdirectory
- **18-Line Rule**: Plugins with fewer than 18 lines are consolidated into the main category file; larger configs get separate files
- Individual plugin configurations are isolated in separate files for better maintainability when they exceed the line threshold
- The main lazy.nvim setup imports from each category directly (e.g., `config.plugins.core`, `config.plugins.editor`)

Example structure:
```
lua/config/plugins/
├── core.lua         # Contains small plugins + imports larger ones
├── core/
│   └── which-key.lua  # 18+ lines, gets own file
├── lsp.lua          # Imports from lsp/*
├── lsp/
│   ├── config.lua   # Large LSP config
│   ├── mason.lua
│   └── completion.lua
└── ...
```

## Essential Commands

### Health & Diagnostics
- `:checkhealth` - Check Neovim health
- `:Mason` - Manage LSP servers, formatters, linters
- `:LspInfo` - Show LSP client information
- `:Lazy` - Plugin manager interface

## Key Features

- **Lazy Loading**: Most plugins load on-demand for fast startup
- **Multi-language Support**: LSP, testing, and formatting for JS/TS, Python, Go, Lua, etc.
- **Modern UI**: Uses noice.nvim, lualine, rose-pine theme
- **Git Workflow**: Comprehensive git integration with LazyGit, gitsigns, diffview
- **Testing**: Neotest with adapters for Jest, Vitest, pytest, Go testing
- **Code Intelligence**: Treesitter, LSP with Mason auto-install, blink.cmp completion
- **File Management**: Oil.nvim (buffer-based file explorer) instead of traditional tree

## Development Workflow

1. Use `:checkhealth` to verify setup
2. `:Mason` to install language servers
3. `<leader>ff` for file navigation
4. `<leader>gg` for git operations
5. `<leader>tt` for running tests
6. `<leader>cf` for code formatting

The configuration prioritizes performance and developer experience with thoughtful defaults and discoverable keybindings via which-key.nvim.

## Keymap Management

**MARVIM uses a fully centralized keymap system** where `lua/config/keymaps.lua` is the **single source of truth** for ALL keybindings:

### Architecture
- **Core keymaps**: Editor, window, buffer, tab, terminal, file operations, diagnostics, and LSP bindings
- **Plugin keymaps**: Exported as key tables (e.g., `M.neotest_keys`, `M.oil_keys`) and imported by plugin configs
- **No scattered keymaps**: Zero `vim.keymap.set` calls exist in plugin files

### Implementation Pattern
```lua
-- In keymaps.lua:
M.neotest_keys = {
  { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
  { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
  -- ... more keys
}

-- In plugin config:
{
  "nvim-neotest/neotest",
  keys = function() return require("config.keymaps").neotest_keys end,
  opts = { ... },
}
```

### Available Key Tables
- `M.persistence_keys` - Session management
- `M.toggleterm_keys` - Terminal management  
- `M.neotest_keys` - Test runner
- `M.trouble_keys` - Diagnostics
- `M.oil_keys` - File explorer
- `M.copilot_keys` - AI completion
- And many more...

### Benefits
- **Single source of truth**: All keybindings in one file
- **Easy maintenance**: Change any keymap in one place
- **Better discoverability**: See all keybindings at a glance
- **Consistent organization**: Standardized pattern across all plugins
- **No duplication**: Eliminates scattered keymap definitions

### Special Keymaps
- **LSP keymaps**: Set up via `M.setup_lsp_keybindings(client, buffer)` callback
- **Gitsigns keymaps**: Set up via `M.setup_gitsigns_keybindings(buffer)` callback
- **Global keymaps**: Non-plugin specific bindings handled in setup functions
