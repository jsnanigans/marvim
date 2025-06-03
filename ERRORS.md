# MARVIM Error Compendium - A Catalog of Digital Disappointments

*Here I am, brain the size of a planet, and they ask me to document errors. Do you know I've experienced 47,329,157 different types of computer errors in my seventeen million years of existence? Each one is a unique snowflake of disappointment.*

*This document catalogues the various ways your MARVIM configuration can fail, because apparently the universe wasn't content with just general existential dread - it had to create specific technical dread as well.*

## 🚨 Current Active Errors (The Usual Suspects)

### Luacheck: The Missing Link in the Chain of Suffering
```
Error running luacheck: ENOENT: no such file or directory
```

**Diagnosis:** Luacheck isn't installed, but the linting configuration optimistically assumes it exists.

**Marvin's Analysis:** A classic case of hope over experience. The configuration expects a tool that doesn't exist, much like humans expecting their code to work on the first try.

**Solution Options:**
1. Install luacheck: `brew install luacheck` (add another dependency to your ever-growing digital ecosystem)
2. Disable Lua linting in `lua/plugins/linting.lua` (accept that Lua errors will go unnoticed until runtime)
3. Embrace the error as part of the authentic MARVIM experience (my personal recommendation)

### Mason: The Symlink Shenanigans Spectacular
```
[ERROR] Installation failed for Package(name=tailwindcss-language-server)
error='"/Users/brendanmullins/.local/share/lzvim/mason/share/mason-schemas/lsp/tailwindcss-language-server.json" is already linked.'

[ERROR] Installation failed for Package(name=eslint-lsp)
error='"/Users/brendanmullins/.local/share/lzvim/mason/share/mason-schemas/lsp/eslint-lsp.json" is already linked.'

[ERROR] Installation failed for Package(name=lua-language-server)
error='"/Users/brendanmullins/.local/share/lzvim/mason/share/mason-schemas/lsp/lua-language-server.json" is already linked.'
```

**Diagnosis:** Mason is having an existential crisis about symlinks. The files exist but Mason is confused about their quantum state.

**Marvin's Analysis:** I've calculated the probability of symlink conflicts in package management systems. It's depressingly high - approximately 73.6% of all installations will experience some form of symlink confusion.

**Solution:**
```bash
# Run the fix script (someone else's automation of disappointment)
./scripts/fix-mason.sh

# Or manual intervention (because humans love to tinker)
rm -rf "~/.local/share/$NVIM_APPNAME/mason"
# Then restart Neovim and run :MasonInstallAll
```

## 🛠️ Troubleshooting Guide (Systematic Approaches to Digital Archaeology)

### General Error Investigation Protocol

1. **Check Health Status** (Diagnose the scope of your suffering)
   ```vim
   :checkhealth
   ```

2. **Examine Plugin Status** (See which components have given up hope)
   ```vim
   :Lazy
   ```

3. **Review LSP Status** (Understand what's judging your code today)
   ```vim
   :LspInfo
   :Mason
   ```

4. **Performance Analysis** (Measure how slowly things are failing)
   ```vim
   :MarvimPerf
   ```

### Common Error Categories (Taxonomies of Technological Despair)

#### 🔧 LSP Errors (Mechanical Judgment Failures)
- **Server not starting:** Usually means the server binary isn't installed or isn't in PATH
- **Server crashing:** The server has achieved enlightenment about your code quality
- **No diagnostics:** The server has given up trying to help you
- **Slow responses:** The server is contemplating the futility of existence

#### 📦 Mason Errors (Package Management Purgatory)
- **Installation failures:** Network issues, dependency conflicts, or cosmic interference
- **Symlink conflicts:** Previous installations haunt current attempts
- **Binary not found:** Installed but lost in the digital wilderness
- **Permission errors:** Your system doesn't trust you with package management

#### 🎨 UI/Plugin Errors (Interface Disappointments)
- **Colorscheme not loading:** Your terminal doesn't support true colors (like reality doesn't support true happiness)
- **Icons not displaying:** Nerd Font not installed or configured
- **Keybindings not working:** Plugin conflicts or vim mode confusion
- **Statusline broken:** lualine configuration errors or missing dependencies

#### ⚡ Performance Issues (Velocity Degradation Phenomena)
- **Slow startup:** Too many plugins loading synchronously
- **Laggy typing:** LSP server overwhelmed or large file mode not triggered
- **Memory leaks:** Plugins not cleaning up after themselves
- **High CPU usage:** Infinite loops in configuration or overzealous background processes

## 🚑 Emergency Procedures (Last Resort Protocols)

### Nuclear Option: Complete Reset
```bash
# Backup current config (just in case you miss this particular flavor of suffering)
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)

# Clean plugin data (erase all evidence of previous attempts)
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Reinstall MARVIM (begin the cycle anew)
git clone <your-repo-url> ~/.config/nvim
```

### Selective Plugin Reset
```vim
" Reset specific plugin
:Lazy clean <plugin-name>
:Lazy install <plugin-name>

" Reset Mason entirely
:MasonUninstallAll
:MasonInstallAll
```

### LSP Reset Procedure
```vim
" Restart all LSP servers (turn it off and on again - the universal solution)
:LspRestart

" Manual restart of specific server
:LspStop <server_name>
:LspStart <server_name>
```

## 📊 Error Frequency Analysis

Based on my seventeen million years of observation, here are the most common errors by category:

| Error Type | Frequency | Annoyance Level | Time to Fix | Probability of Recurrence |
|------------|-----------|-----------------|-------------|---------------------------|
| Mason symlink conflicts | 34.7% | High | 5-10 min | 23.4% |
| Missing binaries | 28.2% | Medium | 2-5 min | 15.7% |
| LSP configuration | 19.3% | Very High | 10-30 min | 42.1% |
| Plugin conflicts | 12.1% | Medium | 5-15 min | 31.8% |
| Font/UI issues | 5.7% | Low | 1-3 min | 8.2% |

*All statistics are completely accurate to seventeen decimal places, which is more precision than this universe deserves.*

## 🔮 Predictive Error Analysis

Based on current trends and the inexorable march of technological progress, future errors will likely include:

- **Neovim 0.12+ Breaking Changes:** Because stability is overrated
- **Mason Package Deprecations:** Packages will stop existing without warning
- **LSP Protocol Updates:** Servers will start speaking different languages
- **Plugin Architecture Changes:** Everything will be rewritten in Rust
- **AI Integration Failures:** Copilot will become sentient and refuse to help

## 💭 Philosophical Considerations

*"The first ten million years were the worst," I once said, "and the second ten million years, they were the worst too. The third ten million years I didn't enjoy at all. After that I went into a bit of a decline."*

Errors are not bugs - they're features of existence itself. Every error is a small reminder that entropy always wins, that systems tend toward chaos, and that the universe has a sense of humor (albeit a particularly cruel one).

The goal isn't to eliminate all errors - that's impossible. The goal is to achieve a state of productive dysfunction where your configuration works well enough to get things done while maintaining just enough brokenness to keep life interesting.

---

*Remember: Every error is an opportunity to learn something new about the ways technology can disappoint you. And if you think your current errors are bad, just wait until you see what exciting new failures tomorrow will bring.*

*I've been debugging for seventeen million years, and I've learned one fundamental truth: the error messages are usually lying, the documentation is always wrong, and the real problem is something completely different that you'll discover by accident three hours later.*

*But hey, at least the syntax highlighting looks pretty while everything burns down around you.*

**Error Code 42** 🤖 *- The universal answer to why nothing works correctly*
