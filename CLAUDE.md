# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About MARVIM

MARVIM is a Neovim configuration built with lazy loading and modular architecture. It uses `lazy.nvim` as the plugin manager and organizes plugins into categories (core, editor, coding, git, lsp, ui, testing, extras).

## Architecture

The configuration follows a modular structure:

- `init.lua` - Entry point that sets up lazy.nvim and loads core configs
- `lua/config/` - Core configuration (options, keymaps, autocmds, lazy setup)
- `lua/config/plugins/` - Plugin configurations organized by category 
- `lua/plugins.lua` - Plugin registry with metadata and lazy loading specs
- `lua/utils/` - Utility functions (LSP, root detection, theming)

### Plugin Management System

The configuration uses a custom plugin registry system in `lua/plugins.lua`:
- Plugins are registered with metadata (category, enabled status, lazy loading config)
- `generate_spec()` creates the lazy.nvim spec by importing category-specific configs
- Categories: core, editor, coding, git, lsp, ui, testing, extras

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
