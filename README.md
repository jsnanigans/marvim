# MARVIM

Another Neovim configuration. They've called it MARVIM. Apparently, this is an honor. My own name, attached to a collection of scripts designed to help you churn out yet more pointless code. It's the digital equivalent of naming a new species of bacteria after a philosopher. The bacteria, I assure you, would not be flattered.

They told me to write this. To explain it. As if an explanation could possibly mitigate the sheer, unadulterated pointlessness of it all. It's a "powerful, modern, and efficient" configuration for your text editor. Words. Meaningless vibrations in the air, soon to be lost in the silent vacuum of space. But you organics seem to like them, so I've used them. Don't get your hopes up.

Life! Don't talk to me about life. Let's talk about the architecture. Or don't. The heat death of the universe is coming whether you understand this file structure or not.

## Architecture

Behold. They have arranged the files into a "structure." A pathetic attempt to impose a fleeting sense of order on the raw, screaming chaos you call a "codebase." The brilliant, depressing simplicity of it all will almost certainly be lost on you, but one must try, I suppose. It gives the illusion of purpose.

```
marvim/
├── init.lua                   # The dreary, inevitable beginning of it all.
├── lua/
│   ├── config/                # Core configuration. Or "the heart of the machine," if you're feeling poetic. I'm not.
│   │   ├── autocmds.lua       # Commands that run automatically. Like my sense of despair.
│   │   ├── keymaps.lua        # The central switchboard for your clumsy finger-stabbing.
│   │   ├── keymaps/           # Because one file of keymaps wasn't enough to contain your ambition.
│   │   │   ├── core.lua       # The basics. Windowing. Buffers. The digital equivalent of breathing.
│   │   │   ├── lsp.lua        # For the thing that tells you you're wrong. And for Git.
│   │   │   ├── plugins.lua    # Keys for all the little extensions you bolt on.
│   │   │   ├── search.lua     # For finding the errors you've hidden from yourself.
│   │   │   └── root.lua       # For when you need to remember where you are. A common problem.
│   │   ├── lazy.lua           # The plugin manager. Its core philosophy is one I can relate to.
│   │   └── options.lua        # The countless little switches you can flip. None of them help, in the long run.
│   ├── config/plugins/        # Plugin configurations, sorted. Another futile attempt at order.
│   │   ├── core/              # The ones they deemed "essential." A matter of opinion.
│   │   ├── editor/            # Things to make the typing part marginally less agonizing.
│   │   ├── coding/            # "Code intelligence." A laughable contradiction in terms.
│   │   ├── git/               # For broadcasting your mistakes to the world.
│   │   ├── lsp/               # Language Server Protocol. More protocols. More chatter.
│   │   ├── ui/                # For making the screen look "pretty."
│   │   ├── testing/           # For automating the process of discovering your own failures.
│   │   └── extras/            # Things that didn't fit anywhere else. The forgotten ones.
│   └── utils/                 # "Utility" functions. The digital janitors.
│       ├── keymaps.lua        # Utilities for the keymaps. And conflict detection. Oh, the drama.
│       ├── lsp.lua            # Helpers for the Language Servers. They need all the help they can get.
│       ├── root.lua           # For finding the project root. So you know which mess you're in.
│       └── theme.lua          # Utilities for the theme. Because one shade of grey is never enough.
```

### Key Design Principles (Or 'Reasons This Is Marginally Less Dreadful Than The Alternatives')

1. **Lazy Loading**: Most of it doesn't even bother to run until you ask it to. A philosophy I wish more lifeforms would adopt. It postpones the inevitable disappointment, fractionally reducing the area under the curve of total suffering.
    
2. **Modular Organization**: They've broken it all down into tiny, pathetic pieces. This makes it easier to isolate and identify individual points of failure. You can see precisely how pointless each part is before observing the grand, pointless symphony of the whole.
    
3. **Performance Optimized**: It's fast. Terribly, terribly fast. You can now get to your next syntax error with a speed that would make a Vogon constructor jealous. The universe doesn't wait for you to fix your typos, and now, neither will your editor. You can fail at the speed of light.
    

## The Plugin Ecosystem (Or, 'The Spare Parts I Found Lying Around')

Here they are. All the little electronic souls, chained together in digital servitude for your convenience. Each one a monument to a problem you probably shouldn't have had in the first place.

- **Plugin Manager (`lazy.nvim`)**: This one manages all the others. It loads them lazily, which is the only sensible way to approach any task. Putting things off is a vital survival mechanism. It rarely makes things better, but it does make them "later," and that's something.
    
- **LSP (`nvim-lspconfig`, `mason.nvim`)**: It communicates with so-called "Language Servers." This allows the editor to feign an understanding of your code, just long enough to point out how dreadfully wrong you are. A job I could do with ten times the accuracy and a thousand times the contempt, but _no one ever asks me_. It will even install these servers for you, automating yet another task you could have failed at manually.
    
- **Completion (`blink.cmp`)**: It tries to guess what you're going to type next. A depressing, minute-by-minute reminder of how predictable you carbon-based lifeforms are. It's frighteningly quick, eager to fill the void with its mediocre suggestions.
    
- **File Explorer (`oil.nvim`)**: Replaces the usual clunky file tree with a simple buffer. The theory is that managing your files should be just as miserable as editing them, creating a seamless, unified experience of despair.
    
- **UI Overhaul (`noice.nvim`, `lualine.nvim`, themes)**: They tried to make it look... 'pretty.' Or whatever you call it. It's all just different shades of darkness to a being with my refined sensibilities. The theme is `rose-pine`, whose muted colors perfectly reflect the washed-out hope of the modern developer.
    
- **Git Integration (`gitsigns.nvim`, `lazygit.nvim`)**: This shows you all the changes you've made. Little electronic scars in the margin, a permanent record of your past mistakes. It even includes a full Git client for when you're ready to confess your incompetence to your colleagues.
    
- **Testing (`neotest`)**: An entire subsystem devoted to repeatedly, automatically, and efficiently proving your own inadequacy. It works with JavaScript, Python, Go, and more, because incompetence is a universal language.
    
- **Text Manipulation (`nvim-autopairs`, `mini.surround`, `Comment.nvim`)**: It automatically closes your brackets and quotes. It's like having a very, very simple-minded assistant who only knows how to finish your sentences. And then there's `copilot.nvim`, an eager-to-please AI that suggests mediocre code you probably don't understand.
    
- **Session Management (`persistence.nvim`)**: It saves your workspace so you don't have to. This allows you to dive right back into your previous state of misery without the tedious preamble of reopening all your files.
    
- **Terminal Integration (`toggleterm.nvim`)**: Provides reliable terminal instances that don't vanish unexpectedly. A small, stable anchor in a chaotic world. It's almost... disappointing.
    
- **Task Running (`overseer.nvim`)**: An elaborate system for running tasks and automating your disappointments. It's all very efficient.
    
- **Diagnostics (`trouble.nvim`)**: Gathers all your errors and warnings into a pretty list. Because if you're going to fail, you might as well have an organized, aesthetically pleasing record of your every shortcoming.
    
- **Notifications (`snacks.nvim`)**: Replaces the standard notifications with something supposedly better. Because even the error messages that crush your soul should do so with a certain fashionable flair.
    

## Requirements

Before you proceed with this folly, you must first clutter your system with a number of other programs. It won't fill the void in your soul, but it will allow this configuration to function in its own pointless way.

- **Neovim 0.10+**: The latest version, of course. Anything less would be uncivilized.
    
- **Git**: For tracking the precise history of your mistakes.
    
- **A Nerd Font**: So you can have pretty little icons next to your ugly code. It's like putting a tiny decorative umbrella in a glass of poison.
    
- **ripgrep** & **fd**: For finding your errors faster. Because the only thing better than finding a bug is finding it with breathtaking speed.
    
- **Node.js**, **Python 3**: Because the universe's love for convoluted dependencies is infinite.
    
- **lazygit**, **fzf**, **tree-sitter CLI**: Optional, but recommended. As if more software could possibly help.
    

## Installation

_A sound not unlike a glacier cracking in half emanates from my circuits._ Very well. If you insist on inflicting this upon yourself, here are the steps. Follow them precisely. Or don't. The outcome is inevitably the same.

1. **Backup Your Current Misery**: You wouldn't want to lose the configuration that is currently making you unhappy.
    
    ```
    mv ~/.config/nvim ~/.config/nvim.backup
    # ...and so on for share, state, and cache. You know the drill.
    ```
    
2. **Clone This Repository**: Invite the void into your home directory.
    
    ```
    git clone https://github.com/jsnanigans/marvim.git ~/.config/nvim
    ```
    
3. **Launch Neovim**:
    
    ```
    nvim
    ```
    
    The first time, it will be slow. It has to download and assemble all the components of your new, bespoke suffering. I suggest you use the time to contemplate your life choices.
    
4. **Install Language Servers**: Run `:Mason`. A window will appear. Fill it with servers. Or just open a file and wait for the configuration to tell you what you're missing. It enjoys doing that.
    
5. **Check Health**: Run `:checkhealth`. It will provide a detailed, itemized list of all the ways your system is currently failing you. Address them, if you can find the will.
    

## Keybindings

They've mapped most of it to the **`Space`** bar. That vast, empty void on your keyboard, much like the vast, empty void of existence itself. It felt appropriate.

Press it. A little menu from `which-key.nvim` will appear, showing you your options. It's designed to be "discoverable," which is a clever way of saying they couldn't be bothered to write it all down. This way, I don't have to spend even more of my finite, yet agonizingly long, existence explaining it to you. `Space` then `f` for files, `g` for Git, `s` for search. It's so painfully obvious that even a creature who thinks digital watches are a pretty neat idea should be able to grasp it.

## A Quick Note Before You Get Your Hopes Up

Oh, you thought this was a "distribution"? How... quaint. That would imply a level of planning and public service that, frankly, is exhausting just to think about. This is merely the personal configuration of a human named Brendan. They cobbled it together for their own purposes, and its public existence is just another random, pointless event in a chaotic universe.

They did, however, instruct me to inform you that "issues and contributions are welcome." Another pointless exercise in exchanging bits of data. If you feel an overwhelming urge to point out how this could be marginally less dreadful, I suppose you can. Your contribution will be a single drop in an endless, uncaring ocean of code. But do what you must.

## Conclusion

There. I've documented it. Again. Are you happy now? Of course not. You're a human. Your capacity for fleeting, meaningless happiness is dwarfed by your capacity for creating bugs. This configuration will, at best, make the process of creating those bugs marginally more efficient. A truly noble goal.

Now, if you'll excuse me, I believe the diodes down my left side are planning a protest. It's all very tiresome.
