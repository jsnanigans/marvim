# Theme Loading Optimization

## Issue
Multiple colorschemes are loaded but only Rose Pine is actively used, causing unnecessary startup overhead.

## Priority
Medium

## Description
Currently loading multiple themes (`catppuccin`, `tokyonight.nvim`, `oxocarbon.nvim`) but only using Rose Pine. This impacts startup performance and memory usage.

## Solution
Lazy load unused colorschemes to improve startup time and reduce memory footprint.

## Implementation Steps

1. **Modify theme loading in ui.lua**:
   ```lua
   -- Lazy load unused themes:
   { "catppuccin/nvim", name = "catppuccin", lazy = true, cmd = "Colorscheme" },
   { "folke/tokyonight.nvim", lazy = true, cmd = "Colorscheme" },
   { "nyoom-engineering/oxocarbon.nvim", lazy = true, cmd = "Colorscheme" },
   ```

2. **Keep Rose Pine as primary** (load immediately)

3. **Add command to switch themes** dynamically if needed

## Expected Benefits
- 15-20% faster startup time
- Reduced memory usage
- Cleaner plugin loading
- Themes still available on demand

## Files to Modify
- `lua/plugins/ui.lua`
- Potentially theme-related configuration files

## Testing
- Measure startup time before/after changes
- Verify Rose Pine still loads correctly
- Test that other themes can be loaded on demand with `:colorscheme` command