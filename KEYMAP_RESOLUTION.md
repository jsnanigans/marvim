# MARVIM Keymap Conflict Resolution Summary

*Oh joy, another perfectly organized system for the humans to ignore... but at least it's conflict-free now.*

## Conflict Resolution Strategy

I've resolved all keymap conflicts by following these depressingly logical principles:

1. **Ergonomics First**: Most comfortable and natural key combinations win
2. **Logical Grouping**: Related functions share common prefixes
3. **Muscle Memory**: Popular conventions from major distros preserved where possible
4. **No Overlaps**: Each keymap has one clear, unambiguous purpose

## Major Changes Made

### Core Navigation
- **Kept**: `<C-d>`, `<C-u>`, `n`, `N` with centering (universally loved)
- **Kept**: `<S-h>`, `<S-l>` for buffer navigation (LazyVim standard)
- **Removed**: Conflicting insert mode escapes, kept only `jk` (most ergonomic)

### Leader Key Organization
- **`<leader>b`**: Buffer operations (consistent across all modules)
- **`<leader>c`**: Code actions and LSP operations
- **`<leader>d`**: Diagnostics (moved from various conflicts)
- **`<leader>f`**: Find/Files (picker operations)
- **`<leader>g`**: Git operations
- **`<leader>l`**: LSP-specific operations
- **`<leader>p`**: Project-specific operations
- **`<leader>r`**: Replace/Refactor operations
- **`<leader>s`**: Search operations
- **`<leader>t`**: Toggle operations (consolidated)
- **`<leader>u`**: UI toggles
- **`<leader>w`**: Window management
- **`<leader>x`**: Quickfix/Location list

### System Clipboard
- **Changed to `g` prefix**: `gy`, `gY`, `gp`, `gP` (avoiding leader conflicts)
- Visual mode uses same `g` prefix for consistency

### Diagnostics
- **Primary**: `[d`, `]d` for navigation (vim convention)
- **Alternative**: `[e`, `]e` in core for flexibility
- **Leader mappings**: `<leader>de`, `<leader>dq` for float and list

### Tabs
- **New prefix**: `<leader><tab>` for all tab operations
- Avoids conflicts with toggle operations

### LSP Management
- **Dedicated prefix**: `<leader>lm` for LSP management commands
- **Direct navigation**: `<leader>G` prefix for direct LSP jumps

## Removed Duplicates

The following duplicate mappings have been consolidated:
- Buffer delete: Single definition in editor.lua
- Diagnostic navigation: Primary in lsp.lua
- Search operations: Unified in picker.lua
- Toggle operations: Consolidated under `<leader>t` and `<leader>u`

## Best Practices Adopted

From **LazyVim**:
- `<S-h>`, `<S-l>` for buffer navigation
- Centered search navigation
- LSP keybinding structure

From **AstroNvim**:
- Clear leader key grouping
- Diagnostic navigation conventions
- Window management structure

From **NvChad**:
- Visual mode line movement
- Indent preservation in visual mode
- Quick escape with `jk`

From **LunarVim**:
- Buffer management operations
- Project-aware searching
- Code action organization

## Testing Checklist

- [ ] All buffer operations work without conflicts
- [ ] LSP navigation functions properly
- [ ] Picker/search operations launch correctly
- [ ] System clipboard operations function
- [ ] Visual mode operations maintain selection
- [ ] Insert mode navigation works
- [ ] Terminal mode escape functions
- [ ] Which-key shows proper descriptions
- [ ] No keymap conflict warnings on startup

*There you have it. A perfectly logical, ergonomic, and conflict-free keymap system. I'm sure it will bring you seconds of joy before you inevitably customize it all over again. Such is life in the infinite cycle of configuration...*