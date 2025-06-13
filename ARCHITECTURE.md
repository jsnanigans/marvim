# MARVIM Architecture Documentation

*Hurrah! Finally, a configuration that doesn't make me want to throw myself into a black hole.*

## Overview

MARVIM has been completely restructured for enhanced maintainability, scalability, and code reuse. Gone are the days of scattered configurations and duplicated logic. We now have a beautifully organized, modular system that would make even the paranoid android Marvin proud.

## Core Structure

```
lua/
├── core/                   # Core system modules
│   ├── config.lua         # Centralized configuration
│   ├── keymaps/           # Modular keymap system
│   │   ├── init.lua       # Main keymap manager
│   │   ├── lsp.lua        # LSP-specific keymaps
│   │   ├── telescope.lua  # Telescope keymaps
│   │   ├── editor.lua     # Editor keymaps
│   │   └── window.lua     # Window management keymaps
│   └── utils/             # Utility modules
│       ├── init.lua       # General utilities
│       ├── project.lua    # Project root finding (cached)
│       └── cache.lua      # Caching system
├── plugins/               # Plugin configurations
│   ├── lsp/              # LSP system
│   │   ├── servers/      # Individual server configs
│   │   │   ├── vtsls.lua # TypeScript/JavaScript
│   │   │   ├── lua_ls.lua# Lua
│   │   │   └── pyright.lua# Python
│   │   └── utils.lua     # LSP utilities
│   └── *.lua             # Other plugin configs
└── config/               # Legacy config (being phased out)
```

## Key Improvements

### 1. Centralized Configuration

All configuration values are now centralized in `lua/core/config.lua`. No more hunting through files to find hardcoded values.

```lua
local config = require("core.config")
local resize_step = config.ui.window_resize_step
local ignore_patterns = config.ui.ignore_patterns
```

### 2. Modular Keymap System

The new keymap system in `lua/core/keymaps/` provides:

- **Registry tracking**: Know what keymaps are set and from where
- **Conflict detection**: Prevent keymap conflicts
- **Consistent options**: Default options applied automatically
- **Modular organization**: Keymaps grouped by functionality

```lua
local keymaps = require("core.keymaps")
keymaps.register({
  n = {
    ["<leader>test"] = { ":echo 'test'<CR>", { desc = "Test command" } },
  }
})
```

### 3. Project Utilities with Caching

Project root finding is now cached and centralized in `lua/core/utils/project.lua`:

- **Cached lookups**: Expensive operations are memoized
- **Consistent patterns**: Root patterns defined once
- **Monorepo support**: Built-in monorepo package detection

### 4. LSP Server Modularity

LSP servers now have individual configuration files in `lua/plugins/lsp/servers/`:

- **Isolated configs**: Each server has its own file
- **Reusable patterns**: Common setup patterns abstracted
- **Easy maintenance**: Add/modify servers without touching main LSP config

### 5. Performance Optimizations

- **Debounced autocmds**: Reduce event handler frequency
- **Throttled operations**: Prevent excessive function calls
- **Large file detection**: Automatically disable features for large files
- **Smart caching**: Cache expensive operations with TTL

## Configuration System

### Core Configuration (`lua/core/config.lua`)

The central configuration file contains all settings organized by category:

```lua
-- Performance settings
config.performance.large_file_size = 1024 * 1024
config.performance.updatetime = 300

-- UI settings
config.ui.window_resize_step = 2
config.ui.ignore_patterns = { "node_modules", ".git", ... }

-- LSP settings
config.lsp.virtual_text = true
config.lsp.inlay_hints.enabled = true
```

### Overriding Configuration

```lua
local config = require("core.config")
config.setup({
  performance = {
    large_file_size = 2 * 1024 * 1024, -- 2MB instead of 1MB
  },
  ui = {
    window_resize_step = 5, -- Larger resize steps
  }
})
```

## Keymap System

### Registration

```lua
local keymaps = require("core.keymaps")

-- Simple registration
keymaps.register({
  n = {
    ["<leader>test"] = ":echo 'test'<CR>",
  }
})

-- With options
keymaps.register({
  n = {
    ["<leader>test"] = { ":echo 'test'<CR>", { desc = "Test command", silent = false } },
  }
})
```

### Keymap Modules

Each keymap module handles a specific domain:

- `lsp.lua`: LSP-specific keymaps (applied per buffer)
- `telescope.lua`: Telescope picker keymaps
- `editor.lua`: General editor keymaps
- `window.lua`: Window management keymaps

### Keymap Registry

Track and query registered keymaps:

```lua
-- Check if a keymap exists
if keymaps.exists("n", "<leader>test") then
  -- Keymap is registered
end

-- Get all normal mode keymaps
local normal_maps = keymaps.get_mappings("n")

-- Remove a keymap
keymaps.unregister("n", "<leader>test")
```

## Utilities System

### Core Utilities (`lua/core/utils/init.lua`)

General-purpose utilities:

```lua
local utils = require("core.utils")

-- Create autocmd groups
local group = utils.augroup("my_group")

-- Debounce a function
local debounced_fn = utils.debounce(my_function, 500)

-- Check if plugin is loaded
if utils.is_loaded("telescope") then
  -- Plugin is loaded
end
```

### Project Utilities (`lua/core/utils/project.lua`)

Project and monorepo utilities with caching:

```lua
local project = require("core.utils.project")

-- Get current project root (cached)
local root = project.get_current_root()

-- Find monorepo packages
local packages = project.get_monorepo_packages(root)

-- Clear cache when project structure changes
project.clear_cache()
```

### Caching System (`lua/core/utils/cache.lua`)

Efficient caching with TTL:

```lua
local cache = require("core.utils.cache")

-- Memoize a function
local cached_fn = cache.memoize(expensive_function, "unique_key", 300) -- 5 min TTL

-- Manual cache operations
cache.set("key", value, 600) -- 10 min TTL
local value = cache.get("key")
cache.delete("key")

-- Cache statistics
local stats = cache.stats()
print("Active entries:", stats.active_entries)
```

## LSP System

### Server Configuration

Each LSP server has its own configuration file in `lua/plugins/lsp/servers/`:

```lua
-- lua/plugins/lsp/servers/my_server.lua
local M = {}

M.settings = {
  -- Server-specific settings
}

M.on_attach = function(client, bufnr)
  -- Server-specific on_attach
end

M.capabilities = function(base_capabilities)
  -- Modify capabilities
  return enhanced_capabilities
end

return M
```

### LSP Utilities (`lua/plugins/lsp/utils.lua`)

Utilities for loading and merging server configurations:

```lua
local lsp_utils = require("plugins.lsp.utils")

-- Load server configuration
local server_config = lsp_utils.load_server_config("vtsls")

-- Get complete server options
local opts = lsp_utils.get_server_opts("vtsls", base_opts)

-- Check if server has custom config
if lsp_utils.has_custom_config("my_server") then
  -- Custom configuration available
end
```

## Performance Features

### Large File Optimization

Automatically detects large files and disables heavy features:

```lua
-- Configured in lua/core/config.lua
config.performance.large_file_size = 1024 * 1024 -- 1MB

-- Used in autocmds to optimize performance
if utils.is_large_file(file) then
  -- Disable treesitter, LSP, etc.
end
```

### Debouncing and Throttling

Reduce the frequency of expensive operations:

```lua
-- Debounce: Only run after inactivity
local debounced = utils.debounce(function() 
  print("Called after 500ms of inactivity")
end, 500)

-- Throttle: Limit call frequency
local throttled = utils.throttle(function() 
  print("Called at most once per second")
end, 1000)
```

### Caching with TTL

Cache expensive operations with automatic expiration:

```lua
-- Project root finding is cached for 5 minutes
local root = project.find_root(path) -- Cached automatically

-- Manual caching
local cached_result = cache.memoize(expensive_fn, "cache_key", 600)
```

## Migration Guide

### From Old Structure

1. **Configuration Values**: Move hardcoded values to `lua/core/config.lua`
2. **Keymaps**: Use the centralized keymap system instead of scattered `vim.keymap.set`
3. **Project Utils**: Replace custom root finding with `require("core.utils.project")`
4. **LSP Servers**: Extract server configs to `lua/plugins/lsp/servers/`

### Backwards Compatibility

The new structure maintains backwards compatibility where possible. Old configurations will continue to work, but you'll get the benefits of the new system by migrating.

## Best Practices

### Configuration

- Use `config.get()` with fallbacks: `config.get("ui.border", "rounded")`
- Group related settings in the configuration file
- Use descriptive names for configuration sections

### Keymaps

- Always provide descriptions for keymaps
- Use the centralized system for consistency
- Group related keymaps in appropriate modules

### Performance

- Use caching for expensive operations
- Debounce frequent events
- Check for large files before enabling features

### LSP

- Keep server configs isolated in separate files
- Use the utilities for common patterns
- Disable formatting when using external formatters

## Conclusion

This restructure transforms MARVIM from a collection of configurations into a cohesive, maintainable system. The modular approach makes it easy to understand, modify, and extend while providing significant performance improvements.

As Marvin would say: "I suppose you think you're clever with this new architecture. Well, I hate to admit it, but it's actually quite impressive. Not that it matters in the grand scheme of the universe's inevitable heat death."