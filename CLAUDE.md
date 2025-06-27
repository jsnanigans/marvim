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
- `lua/utils/` - Utility functions (LSP, root detection, theming, performance optimization)

### Plugin Management System

The configuration uses lazy.nvim's standard import system with a streamlined structure:
- Plugin specs are organized into category modules under `lua/config/plugins/`
- Each category (core, editor, coding, git, lsp, ui, testing, extras) has its own subdirectory
- **Cognitive Complexity Rule**: Plugins with low cognitive complexity are consolidated into the main category file; complex configs get separate files
- Individual plugin configurations are isolated in separate files when they have substantial configuration, custom logic, or high maintenance overhead
- The main lazy.nvim setup imports from each category directly (e.g., `config.plugins.core`, `config.plugins.editor`)

**Complexity Assessment Criteria:**
- **LOW**: Simple opts table, basic config function, minimal setup → Consolidate
- **MEDIUM**: Moderate configuration with some custom logic → Judgment call based on importance
- **HIGH**: Complex setup, extensive configuration, critical functionality → Keep separate

Example structure:
```
lua/config/plugins/
├── core.lua         # Contains simple plugins + imports complex ones
├── core/
│   └── which-key.lua  # Complex keymap definitions, gets own file
├── lsp.lua          # Imports from lsp/*
├── lsp/
│   ├── config.lua   # Complex LSP setup
│   ├── mason.lua    # Moderate complexity
│   └── completion.lua # Complex completion config
└── ...
```

## Essential Commands

### Health & Diagnostics
- `:checkhealth` - Check Neovim health
- `:Mason` - Manage LSP servers, formatters, linters
- `:LspInfo` - Show LSP client information
- `:Lazy` - Plugin manager interface
- `:EnableSnippets` - Load snippet support on-demand

## Key Features

- **Optimized Performance**: ~41ms startup time with immediate LSP functionality - no artificial delays
- **Lazy Loading**: Most plugins load on-demand for exceptional startup speed
- **Multi-language Support**: LSP, testing, and formatting for JS/TS, Python, Go, Lua, etc.
- **Modern UI**: Uses noice.nvim, lualine, rose-pine theme
- **Git Workflow**: Comprehensive git integration with LazyGit, gitsigns, diffview
- **Testing**: Neotest with adapters for Jest, Vitest, pytest, Go testing
- **Code Intelligence**: Treesitter, LSP with Mason async auto-install, blink.cmp completion
- **File Management**: Oil.nvim (buffer-based file explorer) instead of traditional tree
- **Smart Snippet Loading**: On-demand snippet system via `:EnableSnippets` command

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

### Keymap System Architecture Details

The keymap system uses a sophisticated modular architecture with conflict detection:

**File Structure:**
- `lua/config/keymaps.lua` - Main entry point and plugin key table exports
- `lua/config/keymaps/core.lua` - Editor, window, buffer, tab, terminal, file, diagnostics keymaps
- `lua/config/keymaps/lsp.lua` - LSP and Gitsigns setup functions
- `lua/config/keymaps/plugins.lua` - Plugin key table definitions
- `lua/config/keymaps/search.lua` - Search-related keymaps
- `lua/config/keymaps/root.lua` - Root directory operations
- `lua/utils/keymaps.lua` - Keymap utilities and conflict detection

**Safety Features:**
- **Conflict Detection**: `safe_keymap_set()` function tracks and warns about keymap conflicts
- **Error Handling**: Graceful handling of failed keymap registrations
- **Deferred Setup**: Plugin keymaps load via `setup_deferred()` to avoid timing issues
- **Availability Checks**: Plugins are checked before keymap registration

**Diagnostic Command:**
- `:KeymapDiagnostics` - Shows keymap conflicts and registration errors
