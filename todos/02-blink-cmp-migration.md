# Migrate to blink.cmp

## Issue Analysis

**Priority**: 🔴 High  
**Impact**: Significant performance improvement, modern features  
**Effort**: Medium (2-3 hours)

### Problem Description

Current completion setup uses `nvim-cmp` which, while stable, has performance limitations and is being superseded by more modern alternatives.

**Current Stack**:
- `hrsh7th/nvim-cmp` - Main completion engine
- `hrsh7th/cmp-nvim-lsp` - LSP source
- `hrsh7th/cmp-buffer` - Buffer source  
- `hrsh7th/cmp-path` - Path source
- `saadparwaiz1/cmp_luasnip` - Snippet source

**Issues**:
- Slower completion rendering
- Higher memory usage
- Complex configuration
- Maintenance overhead with multiple plugins

### Benefits of blink.cmp

- **Performance**: 2-3x faster completion
- **Memory**: Lower memory footprint
- **Simplicity**: Single plugin vs 5+ plugins
- **Modern**: Built with latest Neovim features
- **Maintenance**: Active development, modern codebase

## Implementation Guide

### Step 1: Backup Current Configuration

```bash
# Create backup
cp lua/plugins/lsp.lua lua/plugins/lsp.lua.backup
```

### Step 2: Remove Old Completion Plugins

Edit `lua/plugins/lsp.lua` and remove/comment out:

```lua
-- REMOVE THIS ENTIRE SECTION:
-- {
--   "hrsh7th/nvim-cmp",
--   version = false,
--   event = "InsertEnter",
--   dependencies = {
--     "hrsh7th/cmp-nvim-lsp",
--     "hrsh7th/cmp-buffer", 
--     "hrsh7th/cmp-path",
--     "b0o/schemastore.nvim",
--   },
--   opts = function()
--     -- ... entire nvim-cmp configuration
--   end,
-- },
```

### Step 3: Add blink.cmp

Add to `lua/plugins/lsp.lua`:

```lua
-- Modern completion engine
{
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",
  
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = { preset = "default" },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing and ensures icons are aligned
      nerd_font_variant = "mono"
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- optionally disable cmdline completions
      -- cmdline = {},
    },

    -- experimental signature help support
    signature = { enabled = true },

    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        border = "rounded",
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        -- Keep the cursor X lines away from the top/bottom of the window
        scrolloff = 2,
        -- Note that the gutter will be disabled when border ~= 'none'
        scrollbar = true,
        -- Which directions to show the window,
        -- falling back to the next direction when there's not enough space
        direction_priority = { "s", "n" },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        treesitter_highlighting = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
      },
      -- Display a preview of the selected item on the current line
      ghost_text = {
        enabled = vim.g.ai_cmp ~= false,
      },
    },
  },
  opts_extend = { "sources.default" }
},
```

### Step 4: Update LuaSnip Integration

Edit `lua/plugins/coding.lua` to update LuaSnip configuration:

```lua
-- Update LuaSnip configuration
{
  "L3MON4D3/LuaSnip",
  build = (function()
    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
      return
    end
    return "make install_jsregexp"
  end)(),
  dependencies = {
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    -- REMOVE nvim-cmp dependency block
  },
  opts = {
    history = true,
    delete_check_events = "TextChanged",
  },
  keys = {
    {
      "<tab>",
      function()
        return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      end,
      expr = true, silent = true, mode = "i",
    },
    { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  },
},
```

### Step 5: Update LSP Capabilities

In `lua/plugins/lsp.lua`, update the capabilities section:

```lua
local servers = opts.servers
local has_blink, blink = pcall(require, "blink.cmp")
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  has_blink and blink.get_lsp_capabilities() or {},
  opts.capabilities or {}
)
```

### Step 6: Clean Up Package Lock

```bash
# Remove old completion plugins from lock file
# This will happen automatically on next :Lazy sync
```

### Step 7: Test the Migration

1. **Restart Neovim completely**
2. **Run `:Lazy sync`** to install blink.cmp and remove old plugins
3. **Test completion** in various file types:
   - LSP completion in code files
   - Path completion when typing file paths
   - Buffer completion
   - Snippet expansion

### Step 8: Verify Performance

```vim
" Check startup time improvement
:Lazy profile

" Test completion responsiveness
" Type in a large file and observe completion speed
```

## Expected Results

- ✅ Faster completion rendering (2-3x improvement)
- ✅ Lower memory usage
- ✅ Simplified plugin management (5 plugins → 1)
- ✅ Modern completion features
- ✅ Better integration with LSP

## Troubleshooting

### Common Issues

1. **Completion not working**:
   ```vim
   :lua print(vim.inspect(require("blink.cmp").get_lsp_capabilities()))
   ```

2. **Snippets not expanding**:
   ```vim
   :lua print(package.loaded["luasnip"] and "LuaSnip loaded" or "LuaSnip not loaded")
   ```

3. **LSP integration issues**:
   ```vim
   :LspInfo
   ```

### Rollback Plan

If issues occur:

1. **Restore backup**:
   ```bash
   cp lua/plugins/lsp.lua.backup lua/plugins/lsp.lua
   ```

2. **Sync plugins**:
   ```vim
   :Lazy sync
   ```

3. **Restart Neovim**

## Configuration Customization

### Custom Keymaps

```lua
keymap = {
  preset = "none", -- disable preset
  ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
  ["<C-e>"] = { "hide" },
  ["<CR>"] = { "accept", "fallback" },
  ["<Tab>"] = { "snippet_forward", "fallback" },
  ["<S-Tab>"] = { "snippet_backward", "fallback" },
  ["<Up>"] = { "select_prev", "fallback" },
  ["<Down>"] = { "select_next", "fallback" },
  ["<C-p>"] = { "select_prev", "fallback" },
  ["<C-n>"] = { "select_next", "fallback" },
  ["<C-u>"] = { "scroll_documentation_up", "fallback" },
  ["<C-d>"] = { "scroll_documentation_down", "fallback" },
}
```

### Custom Sources

```lua
sources = {
  default = { "lsp", "path", "snippets", "buffer" },
  providers = {
    buffer = {
      min_keyword_length = 2,
      max_items = 5,
    },
    path = {
      min_keyword_length = 2,
    },
  },
}
```

## Related Files

- `lua/plugins/lsp.lua` - Main completion configuration
- `lua/plugins/coding.lua` - LuaSnip integration
- `lazy-lock.json` - Plugin versions (auto-updated)

## Next Steps

After successful migration:
1. Monitor completion performance and adjust settings
2. Customize keymaps if needed
3. Move to theme loading optimization