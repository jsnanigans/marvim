local M = {}

-- ============================================================================
-- PLUGIN REGISTRY
-- ============================================================================

-- Priority levels (higher = loads first):
-- 1000: Critical UI (colorscheme, core theme components)
-- 900:  Dashboard and startup UI
-- 800:  Core functionality (completion, LSP)
-- 700:  Editor features
-- 600:  Language-specific tools
-- 500:  Optional extras

M.registry = {
  -- ============================================================================
  -- CORE PLUGINS
  -- Essential plugins that provide foundational functionality
  -- ============================================================================
  ["folke/lazy.nvim"] = { 
    category = "core", 
    enabled = true, 
    priority = 1000 
  },
  ["nvim-lua/plenary.nvim"] = { 
    category = "core", 
    enabled = true, 
    lazy = true 
  },
  ["folke/persistence.nvim"] = { 
    category = "core", 
    enabled = true, 
    event = "BufReadPre" 
  },
  ["stevearc/dressing.nvim"] = { 
    category = "core", 
    enabled = true, 
    lazy = true 
  },
  ["nvim-tree/nvim-web-devicons"] = { 
    category = "core", 
    enabled = true, 
    lazy = true 
  },
  ["folke/which-key.nvim"] = { 
    category = "core", 
    enabled = true, 
    priority = 900, 
    event = "VeryLazy" 
  },

  -- ============================================================================
  -- EDITOR PLUGINS
  -- Text editing, navigation, and buffer management
  -- ============================================================================
  ["stevearc/oil.nvim"] = { 
    category = "editor", 
    enabled = true, 
    cmd = "Oil" 
  },
  ["RRethy/vim-illuminate"] = { 
    category = "editor", 
    enabled = true, 
    event = { "BufReadPost", "BufNewFile" } 
  },
  ["folke/snacks.nvim"] = { 
    category = "editor", 
    enabled = true, 
    priority = 1000, 
    event = "VeryLazy" 
  },
  ["ThePrimeagen/harpoon"] = { 
    category = "editor", 
    enabled = true, 
    branch = "harpoon2" 
  },
  ["folke/flash.nvim"] = { 
    category = "editor", 
    enabled = true, 
    event = "VeryLazy" 
  },
  ["windwp/nvim-autopairs"] = { 
    category = "editor", 
    enabled = true, 
    event = "InsertEnter" 
  },
  ["numToStr/Comment.nvim"] = { 
    category = "editor", 
    enabled = true 
  },
  ["echasnovski/mini.ai"] = { 
    category = "editor", 
    enabled = true, 
    event = "VeryLazy" 
  },
  ["echasnovski/mini.surround"] = { 
    category = "editor", 
    enabled = true 
  },
  ["echasnovski/mini.bufremove"] = { 
    category = "editor", 
    enabled = true 
  },

  -- ============================================================================
  -- CODING PLUGINS
  -- Syntax highlighting, snippets, formatting, and code intelligence
  -- ============================================================================
  ["nvim-treesitter/nvim-treesitter"] = {
    category = "coding",
    enabled = true,
    priority = 700,
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = { 
    category = "coding", 
    enabled = true 
  },
  ["L3MON4D3/LuaSnip"] = { 
    category = "coding", 
    enabled = true 
  },
  ["rafamadriz/friendly-snippets"] = { 
    category = "coding", 
    enabled = true 
  },
  ["stevearc/conform.nvim"] = { 
    category = "coding", 
    enabled = true, 
    lazy = true, 
    cmd = "ConformInfo" 
  },
  ["folke/trouble.nvim"] = { 
    category = "coding", 
    enabled = true, 
    cmd = { "TroubleToggle", "Trouble" } 
  },
  ["folke/todo-comments.nvim"] = { 
    category = "coding", 
    enabled = true, 
    cmd = { "TodoTrouble" } 
  },

  -- ============================================================================
  -- GIT PLUGINS
  -- Git integration, conflict resolution, and version control
  -- ============================================================================
  ["lewis6991/gitsigns.nvim"] = { 
    category = "git", 
    enabled = true, 
    event = { "BufReadPre", "BufNewFile" } 
  },
  ["kdheepak/lazygit.nvim"] = { 
    category = "git", 
    enabled = true, 
    cmd = "LazyGit" 
  },
  ["akinsho/git-conflict.nvim"] = { 
    category = "git", 
    enabled = true, 
    version = "^1.0.0" 
  },
  ["f-person/git-blame.nvim"] = { 
    category = "git", 
    enabled = true, 
    event = { "BufReadPre", "BufNewFile" } 
  },
  ["sindrets/diffview.nvim"] = { 
    category = "git", 
    enabled = true, 
    cmd = { "DiffviewOpen", "DiffviewClose" } 
  },

  -- ============================================================================
  -- LSP PLUGINS
  -- Language Server Protocol, completion, and development tools
  -- ============================================================================
  ["neovim/nvim-lspconfig"] = {
    category = "lsp",
    enabled = true,
    priority = 800,
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  },
  ["folke/neoconf.nvim"] = { 
    category = "lsp", 
    enabled = true, 
    cmd = "Neoconf" 
  },
  ["mason-org/mason.nvim"] = { 
    category = "lsp", 
    enabled = true, 
    cmd = "Mason", 
    build = ":MasonUpdate" 
  },
  ["williamboman/mason-lspconfig.nvim"] = { 
    category = "lsp", 
    enabled = true 
  },
  ["b0o/schemastore.nvim"] = { 
    category = "lsp", 
    enabled = true 
  },
  ["saghen/blink.cmp"] = {
    category = "lsp",
    enabled = true,
    priority = 800,
    event = { "InsertEnter", "CmdlineEnter" },
    version = "v0.*",
  },
  ["echasnovski/mini.icons"] = { 
    category = "lsp", 
    enabled = true 
  },
  ["folke/lazydev.nvim"] = { 
    category = "lsp", 
    enabled = true, 
    ft = "lua", 
    cmd = "LazyDev" 
  },
  ["Bilal2453/luvit-meta"] = { 
    category = "lsp", 
    enabled = true, 
    lazy = true 
  },

  -- ============================================================================
  -- UI PLUGINS
  -- Colorschemes, status line, notifications, and visual enhancements
  -- ============================================================================
  ["rose-pine/neovim"] = { 
    category = "ui", 
    enabled = true, 
    name = "rose-pine", 
    lazy = false, 
    priority = 1000 
  },
  ["nvim-lualine/lualine.nvim"] = { 
    category = "ui", 
    enabled = true, 
    event = "VeryLazy" 
  },
  ["rcarriga/nvim-notify"] = { 
    category = "ui", 
    enabled = true 
  },
  ["folke/noice.nvim"] = { 
    category = "ui", 
    enabled = true, 
    event = "VeryLazy" 
  },
  ["nvimdev/dashboard-nvim"] = { 
    category = "ui", 
    enabled = true, 
    priority = 900, 
    event = "VimEnter" 
  },
  ["lukas-reineke/indent-blankline.nvim"] = { 
    category = "ui", 
    enabled = true 
  },
  ["echasnovski/mini.indentscope"] = { 
    category = "ui", 
    enabled = true, 
    version = false 
  },
  ["Bekaboo/dropbar.nvim"] = { 
    category = "ui", 
    enabled = true, 
    event = "VeryLazy" 
  },

  -- ============================================================================
  -- TESTING PLUGINS
  -- Test runners, coverage, and debugging tools
  -- ============================================================================
  ["nvim-neotest/neotest"] = { 
    category = "testing", 
    enabled = true 
  },
  ["nvim-neotest/nvim-nio"] = { 
    category = "testing", 
    enabled = true 
  },
  ["nvim-neotest/neotest-jest"] = { 
    category = "testing", 
    enabled = true 
  },
  ["marilari88/neotest-vitest"] = { 
    category = "testing", 
    enabled = true 
  },
  ["nvim-neotest/neotest-python"] = { 
    category = "testing", 
    enabled = true 
  },
  ["nvim-neotest/neotest-go"] = { 
    category = "testing", 
    enabled = true 
  },
  ["nvim-neotest/neotest-plenary"] = { 
    category = "testing", 
    enabled = true 
  },
  ["antoinemadec/FixCursorHold.nvim"] = { 
    category = "testing", 
    enabled = true 
  },
  ["andythigpen/nvim-coverage"] = { 
    category = "testing", 
    enabled = true 
  },
  ["stevearc/overseer.nvim"] = { 
    category = "testing", 
    enabled = true 
  },
  
  -- Disabled testing plugins
  ["rcarriga/vim-ultest"] = { 
    category = "testing", 
    enabled = false 
  },
  ["vim-test/vim-test"] = { 
    category = "testing", 
    enabled = false 
  },

  -- ============================================================================
  -- EXTRAS PLUGINS
  -- Optional language-specific tools and experimental features
  -- ============================================================================
  ["github/copilot.vim"] = { 
    category = "extras", 
    enabled = true, 
    cmd = { "Copilot" } 
  },
  ["akinsho/toggleterm.nvim"] = { 
    category = "extras", 
    enabled = true, 
    cmd = { "ToggleTerm", "TermExec" } 
  },
  
  -- Disabled extras
  ["supermaven-inc/supermaven-nvim"] = { 
    category = "extras", 
    enabled = false 
  },
  ["nvim-java/nvim-java"] = { 
    category = "extras", 
    enabled = false, 
    ft = "java" 
  },
  ["akinsho/flutter-tools.nvim"] = { 
    category = "extras", 
    enabled = false, 
    ft = "dart" 
  },
  ["rest-nvim/rest.nvim"] = { 
    category = "extras", 
    enabled = false, 
    ft = "http" 
  },
  ["tpope/vim-dadbod"] = { 
    category = "extras", 
    enabled = false, 
    cmd = "DB" 
  },
  ["kristijanhusak/vim-dadbod-ui"] = { 
    category = "extras", 
    enabled = false, 
    cmd = { "DBUI", "DBUIToggle" } 
  },
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

function M.get_plugins_by_category(category)
  local plugins = {}
  for plugin, config in pairs(M.registry) do
    if config.category == category and config.enabled then
      plugins[plugin] = config
    end
  end
  return plugins
end

function M.get_enabled_plugins()
  local plugins = {}
  for plugin, config in pairs(M.registry) do
    if config.enabled then
      plugins[plugin] = config
    end
  end
  return plugins
end

function M.get_all_categories()
  local categories = {}
  for _, config in pairs(M.registry) do
    categories[config.category] = true
  end
  return vim.tbl_keys(categories)
end

function M.generate_spec()
  local spec = {}
  local category_order = { "core", "editor", "coding", "git", "lsp", "ui", "testing", "extras" }
  for _, category in ipairs(category_order) do
    table.insert(spec, { import = "config.plugins." .. category })
  end
  return spec
end

return M

