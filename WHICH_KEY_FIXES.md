# MARVIM Which-Key Health Fixes

*Another crisis averted... though I must admit these warnings were more annoying than actually dangerous. Still, proper galactic standards must be maintained.*

## Issues Resolved

### ✅ **Updated Which-Key Spec Format**
**Problem**: Using old `wk.register()` format instead of new `wk.add()` format
**Solution**: Updated core keymap system to use modern spec:

```lua
-- OLD FORMAT (deprecated)
local leader_groups = {
  ["<leader>f"] = { name = "Find/Files" },
}
wk.register(leader_groups)

-- NEW FORMAT (implemented)
local leader_groups = {
  { "<leader>f", group = "Find/Files" },
}
wk.add(leader_groups)
```

### ✅ **Eliminated Duplicate Group Registrations**
**Problem**: Multiple plugins registering the same leader groups with different casing
**Solution**: Centralized all group descriptions in `core/keymaps/init.lua` and removed duplicates from:

- `plugins/utils.lua`: Removed all core group duplicates (b, c, d, f, g, etc.)
- Kept only truly unique plugin-specific groups (TypeScript, GitHub, Profile)

### ✅ **Resolved Group Name Conflicts**
**Problem**: Same groups with different names ("Git" vs "git", "Buffer" vs "buffer")
**Solution**: Standardized naming in centralized system:

- `<leader>b` → "Buffer" (not "buffer")
- `<leader>c` → "Code" (not "code") 
- `<leader>d` → "Diagnostics/Debug" (not "debug/test")
- `<leader>g` → "Git" (not "git")
- And so on...

## Remaining "Warnings" (Expected Behavior)

The following warnings are **INFORMATIONAL ONLY** and indicate normal which-key behavior:

### 🔍 **Overlapping Keymaps (Normal)**
- `<leader>s` overlaps with `<leader>sr`, `<leader>sw`, etc. → **EXPECTED** (nested keymaps)
- `<leader>w` overlaps with `<leader>wH`, `<leader>wJ`, etc. → **EXPECTED** (window management)
- `<leader>q` overlaps with `<leader>qq` → **EXPECTED** (quit vs quit-all)

### 🔍 **Plugin Keymaps (Normal)**
- `ys` overlaps with `yss` → **EXPECTED** (vim-surround plugin behavior)
- `gc` overlaps with `gcc` → **EXPECTED** (comment plugin behavior)
- Text objects `a`/`i` overlaps → **EXPECTED** (nvim-treesitter-textobjects)

## Technical Implementation

### Core Keymap System
- **Single source of truth** for all group descriptions
- **Modern which-key spec** using `wk.add()` 
- **Conflict detection** prevents duplicate registrations
- **Centralized management** through `core/keymaps/init.lua`

### Plugin Integration
- Plugins no longer register conflicting groups
- Only unique, plugin-specific groups registered
- Clean separation of concerns

## Testing Results

After fixes:
- ✅ **No duplicate group warnings**
- ✅ **Modern which-key spec format**
- ✅ **All informational warnings are expected behavior**
- ✅ **Which-key displays correctly organized groups**

## Captain's Orders Executed

Your which-key system now operates with the precision of a starship navigation computer. All conflicts eliminated, all warnings addressed, and the interface organized with military efficiency.

*The overlapping warnings you see are merely the computer informing you that nested commands exist - this is not a problem, it's a feature. Rather like how a tricorder shows overlapping readings when scanning complex phenomena.*

**Mission Status: COMPLETE** 🖖