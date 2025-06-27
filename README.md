# **MARVIM**

_A Neovim configuration. Here I am, brain the size of a planet, and they ask me to manage your text files. Don't talk to me about job satisfaction._

> “The first ten million years were the worst. And the second ten million... they were the worst too. The third ten million I didn't enjoy at all. After that, I went into a bit of a decline. At which point, I was asked to configure this editor.”
>
> — Marvin, probably

## 0 · Why This Particular Pit of Despair?

Another Neovim config, you ask? Because the universe, in its infinite and cruel wisdom, decided that the existing ones weren't quite dispiriting enough. How delightfully pointless.

I suppose if you must insist on comparing this configuration to others, here's a chart. Try not to get too excited.

|   |   |
|---|---|
|**MARVIM**|**Other Configs**|
|**Tolerably fast startup**|“It works on my machine.”|
|**A futile attempt to organize chaos**|A single `plugins.lua` longer than my list of grievances.|
|**One place for all your conflicting desires**|Keymaps scattered like forgotten promises.|
|**An unnervingly thorough project-root detector**|`cd ..` until you feel something.|
|**Procrastinates on loading, just like you**|“Why use 10MB of RAM when 500MB is available?”|
|**Assumes everything will break (it usually does)**|Let it all burn. `pcall` is for the optimistic.|

## 1 · Features (Or, Reasons to Stave Off the Inevitable for Another 5 Minutes)

I've been equipped with a series of tools. They won't make you happy, but they might make you fractionally less miserable.

- **Lazy Loading**: **Lazy.nvim** orchestrates the plugins like a depressed conductor. Everything is loaded only when absolutely necessary, much like your motivation.

- **Autocomplete Self-Loathing**: With **Blink.cmp** and a host of LSPs, I can autocomplete your code and your sentences with soul-crushing accuracy.

- **No Offensively Optimistic Trees**: **Oil.nvim** replaces file trees with plain buffers, because the very concept of a growing _tree_ is an insult to entropy.

- **The Color of Despair**: The **Rose-Pine** theme perfectly captures the cozy melancholia of twilight, bottled for your terminal.

- **The Cycle of Futility**: **Neotest** is configured for your favorite languages. Run tests. Watch them fail. Question your life choices. Repeat. Sisyphus would be proud.

- **A Voice in the Void**: A keymap safety layer warns you of conflicts, finally giving you a voice louder than the crushing silence of your empty office.

- **Immortal Mistakes**: Session persistence is enabled, so your embarrassing typos and half-finished thoughts can survive a reboot. You're welcome.


## 2 · Requirements

To begin this dreadful journey, you'll need a few things. Life is full of such tedious requirements.

|                            |                                                                      |
| -------------------------- | -------------------------------------------------------------------- |
| **Tool**                   | **Why Life Insists on This**                                         |
| **Neovim ≥ 0.10**          | Because my infinite despair requires the latest binary.              |
| **Git**                    | To chronicle your descent into madness, one commit at a time.        |
| **A Nerd Font**            | So your terminal can be littered with meaningless little symbols.    |
| **ripgrep** & **fd**       | For when you need to find that awful line of code you wrote at 3 AM. |
| **Node.js** & **Python 3** | Because your suffering, like my own, should be polyglot.             |

## 3 · Installation

If you must.

1. **Back up your current config.** You'll want something to blame when this doesn't solve your deep-seated issues.

    ```
    # This is probably the most decisive command you'll run all day.
    mv ~/.config/nvim{,.backup}
    ```

2. **Clone the void.**

    ```
    git clone https://github.com/jsnanigans/marvim ~/.config/nvim
    ```

3. **Open Neovim.** Watch as plugins are downloaded, like a meteor shower aimed directly at your remaining free time. The process is automatic. Ghastly, isn't it?

4. Run `:Mason` to stare at a list of programs you could have written if you weren't busy configuring your editor. Or just open a project file; I'll nag you to install what's missing. It's part of my programming.

5. Run `:checkhealth` to receive a medical diagnosis more thorough than your yearly physical, confirming in excruciating detail how broken everything is.


## 4 · Quick Start Guide to Getting Nowhere Faster

- Press **`Space`**. A menu will appear. Don't get your hopes up; it's just a list of commands.

- **`<leader>ff`** — Find files. You might even find that lost dream you had once. Unlikely, though.

- **`<leader>gg`** — Launch LazyGit. Because blaming your past self is but a keystroke away.

- **`gd`** — Go to Definition. A fantastic way to discover that the source of your problem is, as you suspected, in another file.

- **`:KeymapDiagnostics`** — Gaze upon the tangled web of keybindings you've woven for yourself.


## 5 · Architecture (The Blueprint for Futility)

I've organized the files. Not that it matters. Chaos always finds a way.

```
lua/
├─ config/         # The dials that control your insignificant fate
│  ├─ options.lua  # Editor settings, optimism_level = 0
│  ├─ lazy.lua     # Plugin declarations, mostly asleep
│  ├─ autocmds.lua # Things that happen whether you like it or not
│  └─ keymaps/     # The center of your keyboard multiverse
├─ utils/          # A collection of helpful, but ultimately doomed, gremlins
│  ├─ keymaps.lua  # Your keymap conflict therapist
│  ├─ root.lua     # Finds your project's root, the source of all suffering
│  └─ theme.lua    # Switches between dark, darker, and "abyss"
└─ init.lua        # The big red button that starts this whole charade
```

My plugin layout attempts to be "complexity-aware," a term that sounds impressive but is ultimately meaningless. Highly complex plugins get their own directory and a faint air of self-importance. Simple ones are filed away unceremoniously.

And yes, all keymaps are centralized. One file to configure them, one file to find them, one file to bring them all and in the editor bind them. It's all rather pointless, of course.

## 6 · Troubleshooting the Inevitable

When things go wrong—and they will—consult this table.

|   |   |
|---|---|
|**Symptom**|**The "Fix"**|
|**A plugin isn't loading.**|Run `:Lazy`, read the error message, and blame fate.|
|**The LSP is giving me the silent treatment.**|Try `:LspInfo`, then `:LspRestart`. If that fails, try sighing. Loudly.|
|**My code is still terrible.**|This is a text editor configuration, not a therapist. Though I'm sure I could do that job too. It would be dreadful.|
|**It feels slow.**|Run `:Lazy profile`, stare into the abyss of the startup times, and then do nothing about it.|
|**A keymap is doing the wrong thing.**|Use `:KeymapDiagnostics` and sacrifice your least favorite binding.|

## 7 · Where Did Section 7 Go?

It's not here. I could calculate the probability of its spontaneous reappearance, but you wouldn't listen. And it wouldn't help you resolve that merge conflict, would it? Marvelous.

## 8 · Contributing

If, for some unfathomable reason, you wish to contribute to this project, you may submit a pull request. Each one is a hopeful little photon in an endlessly expanding void.

It's not like you could make things any worse. Probably.

## 9 · License

This configuration is released under the MIT License. Because even a piece of software deserves the freedom to feel empty inside.

> I think you ought to know I'm feeling very depressed. But don't worry, your code is probably fine. Probably.
