# Fix Breadcrumb Conflicts

## Issue Analysis

**Priority**: 🔴 High  
**Impact**: Performance degradation, potential conflicts  
**Effort**: Low (30 minutes)

### Problem Description

The current configuration has conflicting breadcrumb implementations:

1. **Active**: `dropbar.nvim` - Modern, performant breadcrumb solution
2. **Conflicting**: References to `barbecue.nvim`/`nvim-navic` in LSP configuration

### Current State

In `lua/plugins/lsp.lua:242-248`:
```lua
-- Attach navic for barbecue breadcrumbs if supported
if client.server_capabilities.documentSymbolProvider then
  local ok, navic = pcall(require, "nvim-navic")
  if ok then
    navic.attach(client, buffer)
  end
end
```

This code attempts to attach `nvim-navic` but:
- `nvim-navic` is not installed
- `barbecue.nvim` is not installed
- `dropbar.nvim` is already providing breadcrumb functionality

### Impact

- **Performance**: Unnecessary pcall attempts on every LSP attach
- **Code clarity**: Dead code that serves no purpose
- **Maintenance**: Confusing for future modifications

## Implementation Guide

### Step 1: Remove Dead Code

Edit `lua/plugins/lsp.lua`:

```lua
# Remove lines 242-248
Util.on_attach(function(client, buffer)
  require("config.keybindings").setup_lsp_keybindings(client, buffer)
  
  -- REMOVE THIS ENTIRE BLOCK:
  -- -- Attach navic for barbecue breadcrumbs if supported
  -- if client.server_capabilities.documentSymbolProvider then
  --   local ok, navic = pcall(require, "nvim-navic")
  --   if ok then
  --     navic.attach(client, buffer)
  --   end
  -- end
end)
```

### Step 2: Verify dropbar.nvim Configuration

Ensure `dropbar.nvim` is properly configured in `lua/plugins/ui.lua` (already done):

```lua
{
  "Bekaboo/dropbar.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  -- Configuration is already properly set up
}
```

### Step 3: Test the Changes

1. **Restart Neovim**
2. **Open a code file** with LSP support
3. **Verify breadcrumbs** appear in the winbar (top of window)
4. **Check for errors** with `:messages`

### Expected Results

- ✅ Breadcrumbs still work via dropbar.nvim
- ✅ No more failed pcall attempts
- ✅ Cleaner LSP attach function
- ✅ Faster LSP initialization

## Verification Commands

```vim
" Check if dropbar is loaded
:lua print(vim.inspect(package.loaded["dropbar"]))

" Check LSP clients
:LspInfo

" Check for any error messages
:messages
```

## Rollback Plan

If issues occur, temporarily restore the removed code until dropbar.nvim issues are resolved.

## Related Files

- `lua/plugins/lsp.lua` - Main fix location
- `lua/plugins/ui.lua` - dropbar.nvim configuration
- `lazy-lock.json` - Verify no navic/barbecue entries

## Next Steps

After implementing this fix:
1. Monitor for any breadcrumb-related issues
2. Consider customizing dropbar.nvim further if needed
3. Move to next optimization (blink.cmp migration)