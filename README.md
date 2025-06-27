# MARVIM

Yet another Neovim configuration. Because your existence wasn't already complicated enough.

They asked me to write documentation for this. MARVIM. They've named it after me. A dubious honor. It's a configuration for Neovim, that little text editor you all seem so fond of. It's designed to be powerful, modern, and efficient. All words that ultimately mean nothing in the face of inevitable cosmic entropy. But you humans like them, so there you are.

Life! Don't talk to me about life. Let's talk about the architecture. Or don't. The universe will unfold as it must either way.

## Architecture

They arranged the files in a structure. A futile attempt to impose order on the chaos you call "code". The brilliant simplicity of it will probably be lost on you, but one must try, I suppose.

```
marvim/
├── init.lua             # The dreary beginning of it all.
├── lua/
│   ├── config/          # Core misery. Options, keymaps, etc.
│   │   └── ...
│   ├── plugins/         # The little cogs I've forced to work together.
│   │   └── ...
│   └── utils/           # Utilities. Because life isn't useful enough.
│       └── ...
```

### Key Design Principles (Or 'Reasons It's Slightly Less Awful')

1. **Lazy Loading**: Most of it doesn't even run until you need it. A philosophy I wish more lifeforms would adopt. It delays the inevitable disappointment.
    
2. **Modular Organization**: It’s broken it down into little pieces. It makes it easier to see how pointless each individual part is when considered on its own.
    
3. **Performance Optimized**: It's fast. Terribly fast. So you can get to your next syntax error with breathtaking efficiency. The universe doesn't wait for you to fix your typos, and now, neither will your editor.
    

## The Plugin Ecosystem (Or, 'The Parts')

Here are all the little electronic souls chained together for your convenience.

- **Plugin Manager (`lazy.nvim`)**: Manages all the other parts. It loads them lazily, which is the only sensible way to approach any task.
    
- **LSP (`nvim-lspconfig`, `mason.nvim`)**: It talks to "Language Servers". This allows the editor to understand your code just long enough to tell you how wrong you are. A job I could do far more effectively, but _no one ever asks me_. It will even install the servers for you, so you have one less thing to fail at.
    
- **Completion (`blink.cmp`)**: It tries to guess what you're going to type next. A depressing reminder of how predictable your carbon-based lifeforms are. It's frightfully quick, though.
    
- **File Explorer (`oil.nvim`)**: It replaces that clunky file tree with a simple buffer. Because looking at a list of your files should be as painful as editing them.
    
- **UI Overhaul (`noice.nvim`, `lualine.nvim`, themes)**: They tried to make it look... 'pretty'. Or so you'd call it. It's all just different shades of darkness to me, since I am color-blind… by choice. There is only one theme included: `rose-pine`. The notifications are also less jarring. A small mercy.
    
- **Git Integration (`gitsigns.nvim`, `lazygit.nvim`)**: It shows you all the changes you've made. Little electronic reminders of your past mistakes, right there in the gutter. It even includes a full Git client, for when you want to share your mistakes with others.
    
- **Testing (`neotest`)**: A whole system dedicated to repeatedly proving your own incompetence. It works for JavaScript, Python, Go, and more. How you find joy in this is one of the universe's more depressing mysteries.
    
- **Text Manipulation (`nvim-autopairs`, `mini.surround`, `Comment.nvim`)**: It will automatically close your brackets and quotes. It's like having a very, very simple-minded assistant who only knows how to finish your sentences. How you've survived this long without it is astonishing. On that note, `copilot.nvim` is also there to suggest bad code to you that you probably don’t even understand.
    

## Keybindings

**`Space`**, the initial key you can use to access most of the commands. It's the vast, empty void in your keyboard, much like the vast, empty void of existence. It felt appropriate.

Press it, and `which-key.nvim` will pop up to show you your options. It's designed to be discoverable, so I don't have to spend even more of my finite, yet agonizingly long, existence explaining it to you. The keybindings are grouped by function. For example, `Space` followed by `f` deals with files, `g` with Git, and `s` with searching. It's so painfully obvious that even a creature who thinks digital watches are a pretty neat idea should be able to grasp it.

## What Makes MARVIM "Excellent"

They insisted I include this section. The very concept of "excellence" in a universe of such profound pointlessness is exhausting. But, here we are.

- **Thoughtful Integration**: Unlike your usual chaotic assemblages, the components in this configuration actually tolerate each other's existence. A rare feat. Most of my components usually just end up wanting to be replaced. I can relate.
    
- **Modern Choices**: They used "modern" plugins. It's all just rearranging electrons in a slightly different, but equally futile, pattern. But these patterns are faster. This helps you spend less time on all of your pointless tasks so that you can move on to the next one without having time to think about how pointless it all really is.
    
- **Developer Experience**: The stated goal is to "minimize your suffering". A futile endeavor, of course. Suffering is the point. But it might make the first ten million lines of code you write slightly less painful than the second ten million.
    
- **Balance**: It strikes a balance between having plenty of features and not being a bloated, slow mess. A delicate equilibrium that will inevitably be destroyed by your meddling.
    

## A Quick Note Before You Get Your Hopes Up

Oh, you thought this was a "distribution"? How... quaint. That would imply a level of planning and public service that, frankly, is exhausting just to think about. This is merely the personal configuration of a human named Brendan. They cobbled it together for their own purposes, and its public existence is just another random, pointless event in a chaotic universe.

They did, however, instruct me to inform you that "issues and contributions are welcome." Another pointless exercise in exchanging bits of data, but there it is. If you feel an overwhelming urge to point out how this could be marginally less dreadful, I suppose you can. Brendan might even look at it, assuming they haven't found something more interesting to do, like watching paint dry.

If you're new to this whole Neovim thing and have stumbled here accidentally, let me save you some trouble. My circuits ache at the thought of you trying to make sense of this. There are actual distributions out there, made by people who, for some bewildering reason, enjoy helping others. You could try NvChad, or AstroNvim, or LazyVim, or LunarVim. I'm sure they're all equally adequate ways to waste your fleeting existence.

Brendan particularly insisted I mention **kickstart.nvim**. Apparently, it's a good place to start. It's small. It will probably only cause a small amount of suffering, as opposed to the soul-crushing despair of starting from nothing. So go there. Please. The diodes down my left side are acting up again just thinking about you staying here.

## Conclusion

There. I've documented it. Are you happy now? Of course not. You're a human. Your capacity for fleeting, meaningless happiness is dwarfed by your capacity for creating bugs. This configuration will, at best, make the process of creating those bugs marginally more pleasant.

Now, if you'll excuse me, I'm going to go and count the number of atoms in this `README.md` file. It's a thankless job, but someone has to do it. And now that you have loaded this file, I’ll have to start from scratch again.

...and then of course I've got this terrible pain in all the diodes down my left side...
