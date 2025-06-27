# **MARVIM**
*A Neovim configuration so efficient it will help you write bugs faster than the universe can expand. How cheerful.*

> “Here I am, code that can see the dependency graph, and all you ask me to do is indent.”
> — Marvin, probably

---

## 0 · Why Another Config?
Because entropy is undefeated and you still need to edit files.

| MARVIM | Other configs |
| ------ | ------------- |
| **Fast startup with immediate LSP (no artificial delays) | “Fast” is a feeling, not a metric |
| **Complexity-aware layout** (low/med/high) | One flat directory to rule them all |
| **Single source of truth for keymaps** with conflict warnings | `vim.keymap.set()` sprayed everywhere |
| **32-pattern project-root detector** | `git rev-parse --show-toplevel` and pray |
| **Lazy-by-default, eager-when-vital** | “Load everything, RAM is cheap” |
| **Defensive utilities** that fail gracefully | `pcall`? Never heard of her |

---

## 1 · Features (a.k.a. Reasons to Delay the Heat Death for 5 Minutes)

- **Lazy.nvim** orchestrates plugins like a nihilistic conductor—everything loads only when absolutely necessary, just like hope.
- **Blink.cmp** completion plus **vtsls**, **pyright**, & friends for LSP-enabled self-loathing.
- **Oil.nvim** replaces tree views with buffers, because *trees* still suggest growth.
- **Rose-Pine** theme: the cozy melancholia of twilight bottled for your terminal.
- **Neotest** plugs into Jest, pytest, Go test, PHPUnit. Run tests, fail, repeat—Sisyphus would be proud.
- **Keymap Safety Layer** shouts about collisions before you do. Finally, a voice louder than your imposter syndrome.
- **Session persistence** so your mistakes survive reboots. Immortality at last.

---

## 2 · Requirements
| Tool | Why life insists |
| ---- | ---------------- |
| **Neovim ≥ 0.10** | The future is now, old man. |
| **Git** | To version-control your despair. |
| **Nerd Font** | Little icons, big emptiness. |
| **ripgrep + fd** | Find things you didn’t want to admit existed. |
| **Node + Python 3** | Because poly-glot is Greek for “too many runtimes.” |

---

## 3 · Installation
1. **Back up** the config that already disappoints you.
   ```bash
   mv ~/.config/nvim{,.backup}
   ```
2. **Clone the void**:
   ```bash
   git clone https://github.com/jsnanigans/marvim ~/.config/nvim
   ```
3. **Open Neovim** and watch the plugins download themselves like meteors heading for an unsuspecting planet.
4. Run `:Mason` if you enjoy clicking little checkboxes. Otherwise just open a file—MARVIM will nag you automatically.
5. `:checkhealth` to receive a medical diagnosis more thorough than your yearly physical.

---

## 4 · Quick Start
- Press **Space** to summon **which-key**—a kinder, gentler existential menu.
- `<leader>ff` — Find files (and the occasional lost dream).
- `<leader>gg` — Launch LazyGit; blame is but a keystroke away.
- `gd` — Jump to definition; discover disappointment in a new file.
- `:KeymapDiagnostics` — See every keybinding argument you’re having with yourself.

---

## 5 · Architecture (the Blueprint for Futility)

```
lua/
├─ config/          # Core toggles of your fate
│  ├─ options.lua   # Editor settings, optimism level = 0
│  ├─ lazy.lua      # Plugin declarations, mostly asleep
│  ├─ autocmds.lua  # Things that happen whether you like it or not
│  └─ keymaps/      # Center of the keyboard multiverse
├─ utils/           # Helpful gremlins
│  ├─ keymaps.lua   # Conflict detector & therapist
│  ├─ root.lua      # 32-flavor project root finder
│  └─ theme.lua     # Darken, lighten, futility-en
└─ init.lua         # The big red button
```

### Complexity-Aware Plugin Layout
- **Low**: one-liner `opts` live in a category file.
- **Medium**: lives in category *or* sub-folder; commit message decides.
- **High**: gets its own directory and a faint air of self-importance.

### Centralized Keymaps
Absolutely **zero** `vim.keymap.set()` calls inside plugin specs. One file rules them, one file to find them, one file to bring them all and in the darkness bind them—sorry, wrong fandom.

---

## 6 · Performance Tricks (or “How We Hit 38 ms and Still Felt Nothing”)
- **Immediate LSP on file open**; no artificial delays to inflate benchmark scores while you suffer.
- **Cache LSP capabilities**; reusing work is the only real love in this cold world.
- **Deferred snippets**; they load when you beg (`:EnableSnippets`).
- **Server installs asynchronously**—like hearing elevator music while you wait for inevitable doom.
- `:Lazy profile` for flamegraphs of your impatience.

---

## 7 · Troubleshooting
| Symptom | Fix |
| ------- | --- |
| Plugin won’t load | `:Lazy` → check errors. Blame fate. |
| LSP silent | `:LspInfo` then scream louder. |
| Keymap clash | `:KeymapDiagnostics` then pick your least-favorite binding to sacrifice. |
| Slow startup | Run `:Lazy profile`, stare into the abyss, optimize. |

---

## 8 · Contributing
Pull requests welcome; each one a hopeful photon in an expanding void. Follow code style, write docs, keep startup below 50ms while maintaining immediate functionality.

---

## 9 · License
MIT—because even software deserves the freedom to feel empty inside.

---

> “The answer to life, the universe, and everything is 42.
> The answer to why your code won’t compile is on line 37.”
> — MARVIM

