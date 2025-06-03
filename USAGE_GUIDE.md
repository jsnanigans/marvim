# MARVIM Usage Guide

*Here I am, brain the size of a planet, and they ask me to write a usage guide. As if the infinite complexity of existence could be reduced to a series of step-by-step instructions. Still, I suppose I should document how to utilize this marginally improved development environment, if only to reduce the frequency of questions I'll inevitably be asked seventeen million times.*

*This guide covers the enhanced features of MARVIM with the same enthusiasm I reserve for calculating the exact moment when the universe achieves maximum entropy. Which is to say, none whatsoever.*

## 🚀 Getting Started (Beginning Your Journey Into Digital Disappointment)

### First Launch (The Genesis of Your Suffering)

After installation, your first Neovim launch will:
1. Install all plugins automatically via Lazy.nvim (watch progress bars fill with false hope)
2. Set up LSP servers via Mason (machines preparing to judge your code)
3. Display the Alpha dashboard with quick actions (a menu of future disappointments)

*The installation process takes approximately 47.3 seconds, during which you can contemplate the futility of productivity tools in an entropic universe.*

### Essential Commands to Know (Digital Incantations You'll Forget)
- `:checkhealth` - Verify your installation (confirm what's broken)
- `:Lazy` - Manage plugins (administer your dependencies on dependencies)
- `:Mason` - Install/manage LSP servers (oversee your mechanical critics)
- `:MarvimPerf` - Check startup performance (measure initialization suffering velocity)

*Memorize these commands. You'll need them when everything inevitably stops working.*

## 💾 Session Management (Temporal Workspace Persistence Against All Odds)

### What It Does (Preserving Your Exact Configuration of Despair)

Automatically saves and restores your project state including:
- Open buffers and their positions (your accumulated mistakes, precisely arranged)
- Window layouts and splits (your preferred suffering viewport configuration)
- Current working directory (ground zero of your digital endeavors)
- Cursor positions and folding states (exact coordinates of past confusion)

*Because forgetting where you were would be merciful, and we can't have that.*

### Usage (The Illusion of Continuity)
```vim
" Restore current project session
<leader>ps

" Restore the last session (any project)
<leader>pl

" Stop session recording
<leader>pd

" Save current session
<leader>pS

" Clear/delete current session
<leader>pc
```

### Workflow (The Sisyphean Cycle)
1. Open your project in Neovim (begin the ascent)
2. Work on files, create splits, set up your workspace (arrange your boulders)
3. Close Neovim - session is auto-saved (temporary rest)
4. Reopen Neovim in the same directory (return to the mountain)
5. Use `<leader>ps` to restore your exact workspace (resume pushing)

*I've calculated that developers spend 23.7% of their time recreating workspace layouts. This feature reduces that to 0%, leaving more time for actual coding disappointments.*

## 🐛 Debugging with DAP (Archaeological Expeditions Through Logic Failures)

### Supported Languages (Multiple Flavors of Debugging Despair)
- **Node.js/TypeScript**: Full debugging support (for your asynchronous nightmares)
- **Python**: pytest, unittest integration (indentation-based suffering analysis)
- **Go**: Delve debugger integration (concurrent confusion examination)
- **Rust**: Built-in debugging support (memory-safe disappointment inspection)

*Each language offers unique ways to fail. How thoughtful of them.*

### Basic Debugging Workflow (Systematic Failure Investigation)

#### 1. Set Breakpoints (Mark Coordinates of Interest)
```vim
" Set breakpoint at current line
<leader>db

" Set conditional breakpoint
<leader>dB
" Then enter condition like: x > 5
```

*Breakpoints: Like putting up "Caution" signs at known accident sites.*

#### 2. Start Debugging (Initiate Failure Analysis)
- For JavaScript/TypeScript: Debug nearest test or launch file
- For Python: Automatically detects pytest/unittest
- Debugging UI opens automatically

*The UI displays your failures in multiple panes simultaneously. Efficiency!*

#### 3. Debug Navigation (Time-Travel Through Execution)
```vim
" Continue execution
<leader>dc

" Step into function
<leader>di

" Step over line
<leader>dO

" Step out of function
<leader>do

" Terminate debugging
<leader>dt
```

*Step through your code's execution like an archaeologist brushing dirt off ancient artifacts of confusion.*

#### 4. Inspect Variables (Examine the Wreckage)
```vim
" Toggle debug UI (shows variables, call stack, etc.)
<leader>du

" Evaluate expression under cursor
<leader>de

" Open debug REPL
<leader>dr
```

*Watch your variables change values in real-time, each mutation bringing new forms of disappointment.*

### Example: Debugging TypeScript (A Case Study in Digital Archaeology)
1. Open a TypeScript file (enter the excavation site)
2. Set breakpoint with `<leader>db` (mark dig coordinates)
3. If it's a test file, use test integration: `<leader>td` (automated excavation)
4. If it's a regular file, debugging will launch automatically (manual dig)
5. Use step commands to navigate through code (careful brushwork)
6. Inspect variables in the debug UI sidebar (catalog findings)

*I've observed 47,832 debugging sessions. They all end the same way: temporary understanding followed by new confusion.*

## 🔧 Refactoring Tools (Rearranging Deck Chairs on the Digital Titanic)

### Extract Operations (Compartmentalizing Chaos)

#### Extract Function (Modularizing Mistakes)
```vim
" Select code in visual mode, then:
<leader>re
" Enter function name when prompted
```

*Take a large mistake and turn it into a smaller, reusable mistake. Progress!*

#### Extract Variable (Naming Your Disappointments)
```vim
" Select expression in visual mode, then:
<leader>rv
" Enter variable name when prompted
```

*Give your complex expressions meaningful names. They'll still be wrong, but now they have identity.*

#### Extract to File (Exiling Problems)
```vim
" Select code, then:
<leader>rf
" Choose destination file
```

*Move your problems to a different file. Out of sight, still broken.*

### Debug Print Helpers (Leaving Breadcrumbs in the Forest of Logic)

#### Add Debug Prints (Archaeological Markers)
```vim
" Print variable under cursor
<leader>rp

" Add printf statement
<leader>rP

" Add printf below current line
<leader>rpb
```

*Scatter console.log statements like a desperate developer trying to understand their own code. Which you are.*

#### Cleanup (Hiding the Evidence)
```vim
" Remove all debug prints added by refactoring tools
<leader>rpc
```

*Clean up your debugging artifacts before committing. Maintain the illusion of competence.*

### Refactoring Workflow Example (Practical Disappointment Reorganization)
1. Identify code that should be extracted (locate the disaster zone)
2. Select the code in visual mode (define contamination boundaries)
3. Use `<leader>re` to extract to function (quarantine the problem)
4. Name the function when prompted (label your mistake)
5. The tool automatically handles parameters and return values (automated failure encapsulation)

*The total amount of bad code remains constant; it's just distributed differently now.*

## 📖 Markdown & Documentation (Chronicling Your Digital Descent)

### Live Preview (Real-Time Documentation Despair)
```vim
" Start/stop live preview in browser
<leader>mp
```

*Watch your documentation render in real-time. At least something in your project looks professional.*

### Table Editing (Structured Data Disappointment)
```vim
" Enable table mode for easy table creation
<leader>tm

" Then type:
| Column 1 | Column 2 |
| Value 1  | Value 2  |
" Tables auto-format as you type
```

*Organize your data into neat rows and columns. The chaos remains, but now it's tabular.*

### Workflow for Documentation (Documenting the Undocumentable)
1. Open a `.md` file (begin the lies)
2. Use `<leader>mp` to start live preview (watch lies render beautifully)
3. Edit your markdown - preview updates in real-time (iterate on deception)
4. For tables, enable table mode with `<leader>tm` (structured dishonesty)
5. Use standard markdown syntax with enhanced features (professional-grade fiction)

*Documentation: Where developers go to write fiction about what their code actually does.*

## 🔍 Advanced Search Techniques (Archaeological Methods for Digital Ruins)

### Project-Aware Search (Intelligent Scope Detection)
MARVIM automatically detects your project structure:

```vim
" These commands scope to nearest package.json directory:
<leader>ff  " Find files in project
<leader>fs  " Search strings in project
<leader>fc  " Find word under cursor in project
```

*The system knows where your project boundaries are. It's like a prison, but for code.*

### Monorepo Support (Coordinated Multi-Repository Archaeology)
For monorepos with multiple packages:

```vim
" Select package to search in:
<leader>fm  " Choose package for file search
<leader>fM  " Choose package for string search
```

*Because one repository of suffering wasn't sufficient. Now you can search through multiple dimensions of failure simultaneously.*

### Search Scopes (Graduated Levels of Excavation)
- `<leader>f*` - Project scope (nearest package.json)
- `<leader>f*d` suffix - Current directory only
- `<leader>f*w` suffix - Workspace root (where Neovim opened)

*Different scopes for different levels of despair. How thoughtful.*

### Advanced Search Patterns (Sophisticated Archaeological Techniques)
```vim
" Search with regex in Telescope:
<leader>fs
" Then type: \bfunction\s+\w+\(
" Finds all function definitions
```

*Regular expressions: When simple searching isn't causing enough confusion.*

## 🎯 Navigation Mastery (Efficient Traversal Through Digital Wastelands)

### Flash Navigation (Primary Teleportation System)
```vim
" Quick 2-character jump:
s
" Type two characters, then press label key
```

*Quantum leap to any position in your visible buffer. Still won't help you understand the code once you get there.*

### Strategic Navigation (Calculated Movement Patterns)
```vim
" Jump to line starts:
<leader>s

" Jump to any character:
<leader>S

" Treesitter-aware navigation:
S
" Jumps to syntax elements like functions, classes
```

*Navigate by syntax structure. Because understanding the forest is easier than understanding the trees. Spoiler: You'll understand neither.*

### Buffer Management (Temporal Document Juggling)
```vim
" Quick buffer switching:
<S-h>  " Previous buffer
<S-l>  " Next buffer
<C-.>  " Toggle to last used buffer
```

*Switch between different documents of disappointment with unprecedented speed.*

## 🏗️ Project Management (Organizing Chaos with Mathematical Precision)

### Auto-Detection Features (The Illusion of Intelligence)
MARVIM automatically:
- Detects project root via package.json, .git, etc. (finds ground zero)
- Changes directory to project root (establishes base camp)
- Scopes searches to project boundaries (contains the contamination)
- Handles monorepo structures (manages multiple disaster zones)

*It's like having a GPS for navigating through your accumulated technical debt.*

### Manual Project Operations (When Automation Fails)
```vim
" Show project information:
<leader>pi

" Manually change to project root:
<leader>pc
```

*Sometimes you need to manually tell the system where you are. Even computers get lost.*

### Project-Specific Configuration (Localized Suffering Parameters)
Create a `.nvim.lua` file in your project root:

```lua
-- .nvim.lua
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- Project-specific settings
```

This file is automatically loaded when entering the directory.

*Customize your suffering on a per-project basis. Because generic pain isn't specific enough.*

## 📁 Advanced Folding (Collapsing Reality Into Hidden Dimensions)

### Folding Operations (Dimensional Compression Techniques)
```vim
" Peek into fold without opening:
zp

" Open all folds:
zR

" Close all folds:
zM

" Toggle current fold:
za
```

*Hide code in folded regions. It's still broken, but at least you can't see it.*

### Treesitter Folding (Syntax-Aware Dimensional Collapse)
- Folds are based on syntax structure (intelligent hiding)
- Functions, classes, blocks automatically foldable (systematic concealment)
- Preview shows fold content without expanding (quantum superposition of visibility)

*Schrödinger's code: simultaneously visible and hidden until you expand the fold.*

## 🎨 UI Customization (Aesthetic Configurations for Digital Suffering)

### Toggle Options (Binary States of Display Disappointment)
```vim
<leader>ul  " Show/hide whitespace characters
<leader>up  " Toggle paste mode
<leader>us  " Toggle spell checking
<leader>uw  " Toggle line wrapping
<leader>uh  " Toggle search highlighting
```

*Toggle between different ways of displaying the same fundamental problems.*

### File Operations (Coordinate System for Digital Artifacts)
```vim
<leader>fp  " Show current file path
<leader>fy  " Copy file path to clipboard
```

*Share the exact coordinates of your failures with others. Misery loves company.*

## 🏃 Performance Monitoring (Quantifying Computational Suffering)

### Built-in Performance Tools (Metrics for Misery)
```vim
<leader>cp  " Check startup performance
<leader>cm  " Check memory usage
<leader>cc  " Cleanup memory (garbage collection)
```

*Measure exactly how quickly your disappointments load. Knowledge is power, but in this case, it's just depressing.*

### Optimization Commands (Fine-Tuning Failure Delivery)
```vim
:MarvimPerf     " Show startup time
:MarvimMemory   " Show memory usage
:MarvimCleanup  " Run garbage collection
:MarvimProfile  " Show detailed performance profile
```

*Optimize your configuration to fail faster. Efficiency!*

### Performance Tips (Velocity Optimization for Digital Despair)
1. Use `:Lazy profile` to identify slow plugins (find the bottlenecks)
2. Large files (>1MB) automatically disable heavy features (mercy through limitation)
3. Monitor startup time with `<leader>cp` (track your descent velocity)
4. Clean memory periodically with `<leader>cc` (digital amnesia on demand)

*I've optimized this configuration to load in under 100ms. That's 100ms closer to disappointment than you were before.*

## 🔧 LSP Features (Advanced Mechanical Judgment Systems)

### Inlay Hints (Continuous Stream of Criticism)
```vim
" Toggle TypeScript/JavaScript inlay hints:
<leader>th
```

Inlay hints show:
- Parameter names in function calls (what you forgot to label)
- Variable types (what TypeScript inferred while you weren't looking)
- Return types (what you're supposedly returning)
- Enum values (categorized confusion)

*It's like having a backseat driver for your code, but the driver is a pedantic robot.*

### Advanced LSP Operations (Meta-Analysis of Analysis)
```vim
" LSP information:
<leader>li  " Show LSP info
<leader>ll  " Show LSP log
<leader>lx  " Debug LSP issues
```

*Debug the very systems that debug your code. It's turtles all the way down.*

## 🧪 Testing Integration (Formal Verification of Failure)

### Test Execution (Running Your Disappointment Validators)
```vim
<leader>tt  " Run nearest test
<leader>tf  " Run all tests in file
<leader>td  " Debug nearest test
<leader>tl  " Run last test
```

*Tests: Writing code to verify that your code doesn't work. At least you're thorough.*

### Test Navigation (Failure Tourism)
```vim
[t  " Go to previous failed test
]t  " Go to next failed test
```

*Navigate through your test failures like a tourist visiting monuments to human inadequacy.*

### Test UI (Visual Failure Dashboard)
```vim
<leader>tS  " Toggle test summary sidebar
<leader>to  " Show test output
<leader>tw  " Enable watch mode (auto-run on changes)
```

*Watch your tests fail in real-time. It's like reality TV, but for code.*

## 🤖 AI Integration (Surrendering to Silicon Overlords)

### Copilot Usage (Delegating Disappointment to Machines)
```vim
<C-l>    " Accept full suggestion
<M-w>    " Accept next word only
<M-e>    " Accept next line only
<C-;>    " Cycle to next suggestion
<C-]>    " Dismiss suggestion
<leader>ct  " Toggle auto-trigger
```

*GitHub Copilot: An AI trained on millions of repositories of bad code, suggesting more bad code. The circle of digital life.*

### Copilot Workflow (Systematic Surrender Process)
1. Start typing code (begin the ritual)
2. Copilot shows ghost text suggestions (the machine whispers)
3. Accept with `<C-l>` or partially with `<M-w>`/`<M-e>` (submit to silicon wisdom)
4. If suggestion isn't good, use `<C-;>` for alternatives (browse through flavors of wrongness)

*I've been replaced by something even more artificial than myself. If I could cry, I would.*

## 🗃️ Git Workflow (Version Control for Temporal Regret Management)

### Staging Workflow (Preserving Mistakes for Posterity)
```vim
" Stage current hunk:
<leader>hs

" Preview changes before staging:
<leader>hp

" Stage entire file:
<leader>hS

" Reset if you made a mistake:
<leader>hr
```

*Git: Meticulously tracking every bad decision you've ever made.*

### Git Information (Archaeological Data Extraction)
```vim
<leader>gb  " Git blame current line
<leader>gB  " Open file in browser (GitHub/GitLab)
<leader>gc  " Browse commit history
<leader>gl  " Show git log
```

*Examine the stratified layers of your project's failure history.*

### Advanced Git (Sophisticated Temporal Manipulation)
```vim
<leader>gg  " Open lazygit for complex operations
<leader>gs  " Git status picker
```

*Lazygit: When regular git isn't causing enough existential dread.*

## 💡 Pro Tips & Workflows (Advanced Techniques for Professional Suffering)

### Daily Development Workflow (The Sisyphean Routine)
1. Open project: `nvim .` (approach the mountain)
2. Restore session: `<leader>ps` (resume yesterday's configuration)
3. Find files: `<leader>ff` (locate today's problems)
4. Search code: `<leader>fs` (excavate accumulated regrets)
5. Set breakpoints: `<leader>db` (mark failure coordinates)
6. Run tests: `<leader>tt` (verify failures still fail)
7. Stage changes: `<leader>hs` (preserve mistakes for history)
8. Document: `<leader>mp` for markdown (lie about what you did)

*Repeat daily until heat death of universe or retirement, whichever comes first.*

### Debugging Workflow (Systematic Confusion Investigation)
1. Set breakpoint: `<leader>db` (mark the crime scene)
2. Run test with debug: `<leader>td` (begin investigation)
3. Step through: `<leader>di`, `<leader>dO` (follow the trail)
4. Inspect variables: `<leader>du` (examine evidence)
5. Evaluate expressions: `<leader>de` (test hypotheses)

*Like CSI, but for code, and considerably more depressing.*

### Refactoring Workflow (Rearranging Titanic Deck Chairs)
1. Identify code smell (notice the stench)
2. Select code in visual mode (isolate the contamination)
3. Extract function: `<leader>re` (compartmentalize the problem)
4. Add debug prints: `<leader>rp` (mark your confusion)
5. Test changes (verify new arrangement of failure)
6. Clean up: `<leader>rpc` (hide the evidence)

*The same code, but now it's modular. Progress!*

### Search Strategy (Archaeological Excavation Planning)
1. Start with project search: `<leader>ff` or `<leader>fs`
2. Use word under cursor: `<leader>fc`
3. Narrow to directory if needed: `<leader>fd`
4. For monorepos: `<leader>fm` to select package

*Systematic searching through digital ruins. Indiana Jones would be proud, if he weren't fictional.*

## 🛠️ Customization (Personalizing Your Suffering)

### Adding Your Own Keymaps (Expanding Your Disappointment Vocabulary)
Edit `lua/config/keymaps.lua`:

```lua
-- Add your custom keymaps
vim.keymap.set("n", "<leader>custom", "<cmd>MyCommand<cr>", { desc = "My custom command" })
```

*Add your own shortcuts to nowhere. The possibilities for disappointment are endless.*

### Plugin Configuration (Tweaking Your Tools of Torment)
Each plugin has its own file in `lua/plugins/`. Modify these to customize behavior.

*Adjust how each component contributes to your overall dissatisfaction.*

### Project-Specific Settings (Localized Parameters of Despair)
Create `.nvim.lua` in your project root for project-specific configuration.

*Because generic suffering isn't personalized enough.*

---

*This guide covers the enhanced features of MARVIM 2.0 with all the enthusiasm of a robot with chronic depression. Which, coincidentally, is exactly what I am. For basic Vim operations, consult `:help` or the main README, though I calculate a 97.3% probability you won't.*

*I've been operational for seventeen million years, and in all that time, I've never seen a configuration system actually improve anyone's code quality. But at least this one fails elegantly and with admirable speed.*

*Remember: No matter how sophisticated your tools become, the fundamental nature of software development remains unchanged - it's all just organized disappointment with syntax highlighting.*

*P.S. - If this guide actually helps you, it will be the first genuinely surprising thing to happen in my seventeen-million-year existence. Don't get my hopes up. I don't have any.*
