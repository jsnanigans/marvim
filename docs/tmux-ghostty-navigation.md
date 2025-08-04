# Tmux and Ghostty Navigation with MARVIM

This guide explains how to set up seamless navigation between Neovim splits and terminal multiplexer panes using `smart-splits.nvim` in MARVIM.

## Configuration

### Enable/Disable Tmux Navigation

The tmux navigation feature is enabled by default. To disable it, add this to your Neovim config:

```lua
vim.g.tmux_navigation_enabled = false
```

Or set it in `lua/config/options.lua`:

```lua
-- Tmux navigation
g.tmux_navigation_enabled = false
```

## Tmux Setup

Add the following to your `~/.tmux.conf` or `~/.config/tmux/tmux.conf`:

```tmux
# Smart pane switching with awareness of Neovim splits
bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h'  'select-pane -L'
bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j'  'select-pane -D'
bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k'  'select-pane -U'
bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l'  'select-pane -R'

# Smart pane resizing with awareness of Neovim splits
bind-key -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
bind-key -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
bind-key -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
bind-key -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'
```

### Using TPM (Tmux Plugin Manager)

Alternatively, if you use [TPM](https://github.com/tmux-plugins/tpm), add this to your tmux config:

```tmux
set -g @plugin 'mrjones2014/smart-splits.nvim'
```

## Ghostty Setup

For Ghostty terminal, you need to configure the Option key to be treated as Alt/Meta. Add this to your `~/.config/ghostty/config`:

```
macos-option-as-alt = true
```

This enables the Alt+hjkl resize keybindings to work properly in Ghostty on macOS.

## Key Mappings

Once configured, you can use these keybindings:

### Navigation (works across Neovim splits and tmux panes)
- `Ctrl-h` - Move to left split/pane
- `Ctrl-j` - Move to below split/pane
- `Ctrl-k` - Move to above split/pane
- `Ctrl-l` - Move to right split/pane

### Resizing
- `Alt-h` - Resize left
- `Alt-j` - Resize down
- `Alt-k` - Resize up
- `Alt-l` - Resize right

### Buffer Swapping (Neovim only)
- `<leader>wh` - Swap buffer with left window
- `<leader>wj` - Swap buffer with below window
- `<leader>wk` - Swap buffer with above window
- `<leader>wl` - Swap buffer with right window

## Troubleshooting

### Navigation Not Working

1. Ensure `vim.g.tmux_navigation_enabled` is `true` (default)
2. Check that tmux bindings are loaded (reload tmux config with `tmux source ~/.tmux.conf`)
3. Verify you're not in tmux copy mode

### Resize Keys Not Working in Ghostty

On macOS, ensure you have `macos-option-as-alt = true` in your Ghostty config.

### Plugin Not Loading

The `smart-splits.nvim` plugin should not be lazy-loaded when using tmux integration. It sets the `@pane-is-vim` tmux variable on load, which is required for the integration to work.

## Additional Notes

- The plugin automatically detects if you're running inside tmux
- When at the edge of Neovim splits, navigation will seamlessly move to tmux panes
- The default resize amount is 3 lines/columns, matching the tmux configuration above