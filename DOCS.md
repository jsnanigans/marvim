# MARVIM Technical Documentation

> *"A sophisticated Neovim configuration that combines the logical precision of Vulcan engineering with the wisdom of Istari craftsmanship."*

## Overview

MARVIM is a high-performance Neovim configuration built on lazy.nvim with a modular, complexity-aware architecture. It emphasizes performance, maintainability, and developer experience through thoughtful abstraction layers and defensive programming patterns.

## Architecture Principles

### 1. Modular Hierarchy
```
lua/
├── config/              # Core configuration layer
│   ├── autocmds.lua     # Event-driven automation
│   ├── lazy.lua         # Plugin manager setup
│   ├── options.lua      # Editor settings
│   ├── keymaps/         # Centralized keymap system
│   │   ├── keymaps.lua  # Main coordinator & exports
│   │   ├── core.lua     # Editor/window/buffer keymaps
│   │   ├── lsp.lua      # LSP & Git callback setups
│   │   ├── plugins.lua  # Plugin key table definitions
│   │   ├── search.lua   # Search-related operations
│   │   └── root.lua     # Root directory operations
│   └── plugins/         # Plugin specifications
│       ├── [category].lua      # Category aggregators
│       └── [category]/         # Complex configurations
├── utils/               # Utility libraries
│   ├── keymaps.lua      # Keymap management & safety
│   ├── lsp.lua          # LSP utilities & formatting
│   ├── root.lua         # Project root detection
│   └── theme.lua        # Color system & utilities
└── init.lua             # Entry point & bootstrap
```

### 2. Cognitive Complexity-Based Organization

Plugin configurations are organized by complexity:

- **LOW Complexity**: Simple `opts` tables → Consolidated in category files
- **MEDIUM Complexity**: Moderate configuration → Judgment call based on importance
- **HIGH Complexity**: Extensive setup, critical functionality → Dedicated files

**Example Structure:**
```
lua/config/plugins/
├── lsp.lua              # Imports and simple LSP plugins
├── lsp/
│   ├── config.lua       # Complex LSP server setup
│   ├── mason.lua        # Tool management
│   └── completion.lua   # Advanced completion config
├── editor.lua           # Consolidates simple editor plugins
└── editor/
    ├── mini.lua         # Complex mini.nvim configurations
    └── oil.lua          # File explorer configuration
```

## Plugin Management System

### Lazy.nvim Integration

**Bootstrap Process:**
```lua
-- init.lua flow
1. Bootstrap lazy.nvim (auto-install if missing)
2. Load core configurations
3. Setup lazy with category imports
4. Lazy loading with performance optimizations
```

**Category Import System:**
```lua
-- lazy.lua setup
{
  { import = "config.plugins.core" },
  { import = "config.plugins.editor" },
  { import = "config.plugins.coding" },
  { import = "config.plugins.lsp" },
  { import = "config.plugins.git" },
  { import = "config.plugins.ui" },
  { import = "config.plugins.testing" },
  { import = "config.plugins.extras" },
}
```

**Performance Optimizations:**
- Disabled built-in plugins: `netrw`, `gzip`, `zipPlugin`, etc.
- Module caching enabled
- Lazy-by-default loading strategy
- Strategic eager loading for critical plugins

### Plugin Categories

#### Core Plugins
- **plenary.nvim**: Lua utilities foundation
- **which-key.nvim**: Keymap discovery and documentation
- **persistence.nvim**: Session management
- **dressing.nvim**: UI enhancement for vim.ui

#### Editor Plugins
- **oil.nvim**: Buffer-based file explorer
- **mini.nvim**: Comprehensive editor enhancements
  - mini.ai: Advanced text objects
  - mini.surround: Surround operations
  - mini.pairs: Auto-pairing
  - mini.comment: Comment operations
- **flash.nvim**: Enhanced navigation and search
- **toggleterm.nvim**: Terminal management

#### LSP & Completion
- **nvim-lspconfig**: LSP client configurations
- **mason.nvim**: Tool installation manager
- **blink.cmp**: High-performance completion engine
- **conform.nvim**: Formatting with fallback chains

#### Git Integration
- **lazygit.nvim**: Git GUI integration
- **gitsigns.nvim**: Git status in gutter
- **diffview.nvim**: Advanced diff views

#### Testing Framework
- **neotest**: Test runner with adapters for:
  - Jest/Vitest (JS/TS)
  - pytest (Python)
  - go test (Go)
  - PHPUnit (PHP)

## Keymap Architecture

### Revolutionary Centralized System

MARVIM implements a **fully centralized keymap system** - the single source of truth for ALL keybindings.

**Core Principle**: Zero `vim.keymap.set` calls exist in plugin files.

### Architecture Components

#### 1. Main Coordinator (`lua/config/keymaps.lua`)
```lua
-- Exports plugin key tables
M.neotest_keys = { ... }
M.oil_keys = { ... }
M.trouble_keys = { ... }

-- Provides setup functions
M.setup_deferred()
M.setup_lsp_keybindings(client, buffer)
```

#### 2. Modular Organization
- **`core.lua`**: Editor, window, buffer, tab, terminal operations
- **`lsp.lua`**: LSP and Git callback setup functions
- **`plugins.lua`**: Plugin-specific key table definitions
- **`search.lua`**: Search and navigation keymaps
- **`root.lua`**: Project root operations

#### 3. Safety Layer (`lua/utils/keymaps.lua`)
```lua
-- Conflict detection and error handling
safe_keymap_set(mode, lhs, rhs, opts)
register_keymap_conflict(key, plugin1, plugin2)
get_keymap_diagnostics()
```

### Plugin Integration Pattern
```lua
-- In keymaps.lua
M.plugin_keys = {
  { "<leader>xx", function() require("plugin").action() end, desc = "Action" },
}

-- In plugin config
{
  "plugin-name",
  keys = function() return require("config.keymaps").plugin_keys end,
  opts = { ... },
}
```

### Safety Features

- **Conflict Detection**: Tracks and warns about keymap collisions
- **Error Handling**: Graceful handling of failed registrations
- **Diagnostic Command**: `:KeymapDiagnostics` shows conflicts
- **Deferred Setup**: Avoids timing issues with plugin loading

## LSP Configuration

### Multi-layered Architecture

#### 1. Utility Layer (`utils/lsp.lua`)
```lua
-- Core LSP utilities
M.get_clients(opts)           -- Enhanced client retrieval
M.on_attach(client, buffer)   -- Standard attachment callback
M.format(opts)                -- Formatting with fallbacks
M.get_root()                  -- Project root detection
```

#### 2. Configuration Layer (`plugins/lsp/config.lua`)
```lua
-- Server setup and capabilities
local servers = {
  vtsls = { ... },      -- TypeScript/JavaScript
  lua_ls = { ... },     -- Lua
  pyright = { ... },    -- Python
  gopls = { ... },      -- Go
  -- Additional servers...
}
```

#### 3. Tool Management (`plugins/lsp/mason.lua`)
```lua
-- Automatic tool installation
ensure_installed = {
  -- LSP servers
  "vtsls", "lua-language-server", "pyright",
  -- Formatters
  "prettier", "stylua", "black",
  -- Linters
  "eslint_d", "ruff",
}
```

### Advanced Features

- **Capabilities Detection**: Auto-detects blink.cmp vs nvim-cmp
- **Graceful Fallbacks**: Handles missing dependencies
- **TypeScript Enhancement**: Advanced vtsls configuration
- **Format Chains**: Multiple formatter fallbacks per filetype

## Utility Systems

### Root Detection (`utils/root.lua`)

**Comprehensive Project Detection:**
```lua
-- 32 different project markers
local root_patterns = {
  ".git", ".hg", ".svn",
  "package.json", "Cargo.toml", "go.mod",
  "pyproject.toml", "setup.py", "requirements.txt",
  -- ... and many more
}
```

**Performance Features:**
- Caching system for repeated lookups
- Auto-setup via autocmds
- Fallback to current directory

### Theme System (`utils/theme.lua`)

**Rose Pine Integration:**
```lua
-- Semantic color mapping
local colors = {
  bg = "#191724",           -- Base background
  fg = "#e0def4",           -- Main foreground
  accent = "#ebbcba",       -- Primary accent
  muted = "#6e6a86",        -- Secondary text
  -- ... complete palette
}
```

**Color Utilities:**
```lua
M.darken(color, amount)     -- Darken color by percentage
M.lighten(color, amount)    -- Lighten color by percentage
M.alpha(color, alpha)       -- Apply alpha transparency
M.setup_highlights()        -- Apply custom highlights
```

### Keymap Safety (`utils/keymaps.lua`)

**Industrial-Grade Keymap Management:**
```lua
-- Conflict detection registry
local keymap_registry = {}
local conflicts = {}
local errors = {}

-- Safe keymap registration
M.safe_keymap_set = function(mode, lhs, rhs, opts)
  -- Validation and conflict detection
  -- Error handling and logging
  -- Registration tracking
end
```

## Performance Optimizations

MARVIM achieves exceptional startup performance (sub-40ms) through aggressive optimization strategies:

### LSP Performance Engineering
- **Cached Capabilities**: LSP capabilities calculated once and cached in `lua/utils/lsp_cache.lua`
- **Lazy Server Configs**: Heavy server configurations extracted to `lua/utils/lsp_servers.lua` and loaded on-demand
- **Deferred Features**: Codelens and inlay hints activate only after cursor activity (`CursorHold`/`CursorHoldI`)
- **Background Setup**: Mason server installation happens asynchronously via `vim.defer_fn()`
- **Optimized Events**: LSP loads on `BufReadPre` instead of `BufReadPost` for faster file opening

### Completion System Optimization
- **Snippet Deferral**: friendly-snippets and LuaSnip load only when `:EnableSnippets` is called
- **Minimal Default Sources**: Completion uses only `lsp`, `path`, and `buffer` by default
- **Event Optimization**: Removed `CmdlineEnter` trigger to eliminate 40ms+ bottleneck
- **Lazy Dependencies**: Heavy completion dependencies marked as `lazy = true`

### Plugin Loading Strategy
- **Strategic Event Triggers**: Plugins load on precise events rather than broad categories
- **Dependency Management**: Heavy dependencies (LuaSnip, friendly-snippets) deferred until needed
- **Deferred Initialization**: Non-critical features initialize after UI is ready via autocmds

### Startup Optimization Metrics
1. **Original Performance**: 201ms startup time
2. **After LSP Optimization**: 41ms startup time (80% improvement)
3. **After Completion Optimization**: 38ms startup time (81% total improvement)
4. **Performance Monitoring**: Use `:Lazy profile` to identify bottlenecks

### Key Performance Utilities
- `lua/utils/lsp_cache.lua` - LSP capability caching system
- `lua/utils/lsp_servers.lua` - Deferred server configuration loading
- Background mason setup with 50ms delay
- CursorHold/CursorHoldI triggered feature loading for non-essential components

### Runtime Performance
1. **Root Caching**: Project root detection cached
2. **Capability Detection**: LSP capabilities cached and reused
3. **Keymap Registry**: Efficient conflict detection
4. **Selective Loading**: Only load what's needed when needed

## Development Workflow

### Essential Commands
```bash
# Health checks
:checkhealth                  # System health
:checkhealth lazy            # Plugin health
:Mason                       # Tool management
:LspInfo                     # LSP status

# Performance & Diagnostics
:Lazy profile               # Plugin performance analysis
:KeymapDiagnostics          # Keymap conflicts
:EnableSnippets             # Load snippet support on-demand

# Performance monitoring
:Lazy profile               # Startup performance breakdown
```

### Key Bindings by Category

#### File Operations
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Browse buffers
- `<leader>fr` - Recent files

#### Git Workflow
- `<leader>gg` - LazyGit
- `<leader>gd` - Diff view
- `<leader>gb` - Git blame
- `<leader>gh` - Git hunks

#### Testing
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>ts` - Test summary
- `<leader>tw` - Watch tests

#### LSP Operations
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `<leader>ca` - Code actions

## Troubleshooting

### Common Issues

1. **Plugin Loading**: Check `:Lazy` for errors
2. **LSP Problems**: Use `:LspInfo` and `:checkhealth lsp`
3. **Keymap Conflicts**: Run `:KeymapDiagnostics`
4. **Performance**: Use `:Lazy profile` for bottlenecks

### Debug Mode
```lua
-- Enable debug logging
vim.g.marvim_debug = true
```

### Health Checks
```bash
:checkhealth                 # Full system check
:checkhealth lazy           # Plugin manager
:checkhealth mason          # Tool manager
:checkhealth lsp            # LSP configuration
```

## Extending MARVIM

### Adding New Plugins

1. **Determine Complexity**: Simple config → category file, complex → separate file
2. **Add Keymaps**: Update `lua/config/keymaps/plugins.lua`
3. **Follow Patterns**: Use existing plugins as templates

### Custom Configurations

1. **User Config**: Create `lua/user/` directory for personal customizations
2. **Override Patterns**: Use lazy.nvim's override system
3. **Maintain Modularity**: Keep changes isolated and reversible

### Contributing

1. **Follow Architecture**: Respect complexity-based organization
2. **Update Documentation**: Keep DOCS.md current
3. **Test Thoroughly**: Verify no regressions
4. **Performance**: Profile changes with `:Lazy profile`

## Conclusion

MARVIM represents a sophisticated approach to Neovim configuration, combining performance optimization with maintainable architecture. The centralized keymap system, complexity-based organization, and defensive programming patterns create a robust foundation for modern development workflows.

*"In the grand tradition of both Starfleet engineering and Istari wisdom, MARVIM demonstrates that true sophistication lies not in complexity, but in the elegant orchestration of simple, well-designed components."*

---

**Version**: 1.0  
**Last Updated**: 2025-06-27  
**Author**: Brendan Mullins  
**Architecture**: Modular, Performance-Optimized  
**Plugin Manager**: lazy.nvim