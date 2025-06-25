local M = {}

-- Ultimate MARVIM Configuration
-- Combining the best of LazyVim, AstroVim, NvChad, and LunarVim
-- with Marvin's signature touch of existential optimization

-- Performance settings (Enhanced from LazyVim principles)
M.performance = {
  -- File size threshold for large file optimizations (1MB)
  large_file_size = 1024 * 1024,
  
  -- Maximum file size to enable features (10MB)
  max_file_size = 10 * 1024 * 1024,
  
  -- Startup time target (LazyVim inspired)
  startup_time_target = 100, -- milliseconds
  
  -- Lazy redraw for better performance
  lazy_redraw = false,
  
  -- Update time for CursorHold events
  updatetime = 250, -- Faster for better UX
  
  -- Time to wait for a mapped sequence
  timeoutlen = 300, -- Faster key sequence timeout
  
  -- Redraw time for 'hlsearch' and 'incsearch'
  redrawtime = 10000,
  
  -- Debounce timers for various operations
  debounce = {
    diagnostics = 150,
    formatting = 200,
    completion = 100,
    lsp_progress = 300,
  },
  
  -- Memory management
  memory = {
    max_old_files = 100,
    gc_threshold = 1024 * 1024, -- 1MB before forcing GC
  },
}

-- UI settings (Enhanced from NvChad aesthetics + AstroVim functionality)
M.ui = {
  -- Theme configuration (Rosé Pine elegance)
  theme = {
    name = "rose-pine", -- Default theme - All natural pine, faux fur and soho vibes
    variant = "auto", -- auto, main, moon, or dawn
    transparent = false,
    style = "main", -- main, moon, or dawn
  },
  
  -- Window management
  window_resize_step = 2,
  
  -- Statusline configuration (AstroVim inspired)
  statusline = {
    enabled = false, -- Temporarily disabled for testing
    style = "ultimate", -- minimal, default, ultimate
    components = {
      "mode",
      "file_info",
      "git_branch",
      "git_diff",
      "diagnostics",
      "lsp_progress",
      "search_count",
      "location",
      "progress",
    },
    separators = {
      left = "",
      right = "",
    },
  },
  
  -- Winbar configuration (breadcrumbs)
  winbar = {
    enabled = false, -- Temporarily disabled for testing
    show_file_path = true,
    show_symbols = true,
    exclude_filetypes = { "help", "neo-tree", "lazy", "mason" },
  },
  
  -- Tabline configuration
  tabline = {
    enabled = true,
    show_close_icons = true,
    show_modified_icons = true,
    max_name_length = 18,
    max_length = 80,
  },
  
  -- Dashboard configuration (LazyVim inspired)
  dashboard = {
    enabled = true,
    header = {
      "                                   ",
      "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
      "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
      "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
      "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
      "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
      "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
      "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
      " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
      " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
      "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
      "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
      "                                   ",
      "        [ MARVIM: Malevolently Awesome ]        ",
      "                                   ",
    },
    shortcuts = {
      { desc = " Find File", group = "@property", action = "Telescope find_files", key = "f" },
      { desc = " Recent Files", group = "Label", action = "Telescope oldfiles", key = "r" },
      { desc = " Find Word", group = "DiagnosticHint", action = "Telescope live_grep", key = "w" },
      { desc = " Config", group = "Number", action = "edit $MYVIMRC", key = "c" },
      { desc = " Lazy", group = "Title", action = "Lazy", key = "l" },
      { desc = " Quit", group = "Error", action = "quit", key = "q" },
    },
    footer = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
    end,
  },
  
  -- Notification system (snacks.nvim)
  notifications = {
    enabled = true,
    timeout = 3000,
    max_width = 60,
    max_height = 10,
    icons = {
      error = "",
      warn = "",
      info = "",
      debug = "",
      trace = "✎",
    },
  },
  
  -- Animation settings
  animations = {
    enabled = false, -- Disabled by default for performance
    duration = 200,
    fps = 60,
  },
  
  -- Common ignore patterns for file operations
  ignore_patterns = {
    "node_modules",
    ".git",
    ".next",
    ".nuxt",
    ".vuepress",
    "dist",
    "build",
    "target",
    "*.pyc",
    "__pycache__",
    ".DS_Store",
    "*.swp",
    "*.swo",
    "*~",
    ".sass-cache",
    "*.class",
    "*.egg-info",
    ".pytest_cache",
    ".mypy_cache",
    ".ruff_cache",
    ".coverage",
    "coverage.xml",
    "*.cover",
    ".hypothesis",
    ".tox",
    ".nox",
    ".cache",
    ".parcel-cache",
  },
  
  -- Icons configuration
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
      renamed = "➜",
      untracked = "★",
      ignored = "◌",
      unstaged = "✗",
      staged = "✓",
      conflict = "",
    },
    kinds = {
      Text = "",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    },
  },
  
  -- Border styles
  border = "rounded",
  
  -- Transparency
  transparent = false,
  
  -- Show mode in statusline
  showmode = false,
}

-- Editor settings
M.editor = {
  -- Format on save
  format_on_save = true,
  
  -- Format timeout
  format_timeout = 2000,
  
  -- Auto save
  auto_save = false,
  
  -- Spell check languages
  spelllang = "en_us",
  
  -- Tab settings
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  
  -- Wrap settings
  wrap = false,
  linebreak = true,
  
  -- Search settings
  ignorecase = true,
  smartcase = true,
  
  -- Completion settings
  completeopt = "menu,menuone,noselect",
  
  -- Fold settings
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
  foldlevel = 99,
}

-- LSP settings
M.lsp = {
  -- Virtual text for diagnostics
  virtual_text = true,
  
  -- Signs for diagnostics
  signs = true,
  
  -- Update diagnostics in insert mode
  update_in_insert = false,
  
  -- Underline diagnostics
  underline = true,
  
  -- Sort diagnostics by severity
  severity_sort = true,
  
  -- Float settings
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  
  -- Code lens
  codelens = true,
  
  -- Semantic tokens
  semantic_tokens = true,
  
  -- Inlay hints
  inlay_hints = {
    enabled = true,
  },
}

-- Formatting settings
M.formatting = {
  -- Formatters by filetype
  formatters_by_ft = {
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix" },
    go = { "goimports", "gofmt" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    ["*"] = { "trim_whitespace" },
  },
  
  -- Format on save filetypes
  format_on_save_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "css",
    "scss",
    "html",
    "json",
    "jsonc",
    "yaml",
    "markdown",
    "graphql",
    "lua",
    "python",
    "go",
    "rust",
  },
}

-- Linting settings
M.linting = {
  -- Linters by filetype
  linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    vue = { "eslint_d" },
    python = { "ruff" },
    go = { "golangcilint" },
    lua = { "luacheck" },
    sh = { "shellcheck" },
    yaml = { "yamllint" },
    json = { "jsonlint" },
    markdown = { "markdownlint" },
  },
}

-- Keybinding configuration (LazyVim inspired leader system)
M.keymaps = {
  -- Leader keys
  leader = " ",
  localleader = "\\",
  
  -- Which-key integration
  which_key = {
    enabled = true,
    delay = 300,
    show_help = true,
    show_keys = true,
  },
  
  -- Conflict detection
  conflict_detection = true,
  
  -- Key repeat settings
  key_repeat = {
    enabled = true,
    timeout = 500,
  },
}

-- Development workflow (LunarVim inspired)
M.workflow = {
  -- Auto-save settings
  auto_save = {
    enabled = false,
    events = { "InsertLeave", "TextChanged" },
    conditions = {
      exists = true,
      modifiable = true,
      filename_is_not = {},
      filetype_is_not = { "oil" },
    },
  },
  
  -- Format on save
  format_on_save = {
    enabled = true,
    timeout = 2000,
    filetypes = {
      "javascript", "javascriptreact", "typescript", "typescriptreact",
      "vue", "css", "scss", "html", "json", "jsonc", "yaml", "markdown",
      "graphql", "lua", "python", "go", "rust",
    },
  },
  
  -- Lint on save
  lint_on_save = true,
  
  -- Test on save (disabled by default)
  test_on_save = false,
  
  -- Session management
  session = {
    enabled = true,
    auto_save = true,
    auto_restore = false,
  },
  
  -- Project root patterns
  root_patterns = {
    ".git", ".svn", ".bzr", ".hg", "_darcs",
    "package.json", "Cargo.toml", "pyproject.toml", "setup.py",
    "go.mod", "Makefile", "README.md"
  },
}

-- AI assistance configuration
M.ai = {
  -- GitHub Copilot
  copilot = {
    enabled = true,
    auto_trigger = true,
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>",
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<M-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
  },
  
  -- Codeium (alternative)
  codeium = {
    enabled = false, -- Disabled by default when Copilot is enabled
    api_key_cmd = nil, -- Set if using Codeium
  },
  
  -- ChatGPT integration
  chatgpt = {
    enabled = false,
    api_key_cmd = "op read op://Personal/OpenAI/api_key", -- 1Password example
    model = "gpt-4",
    keymaps = {
      chat = "<leader>ac",
      edit = "<leader>ae",
      explain = "<leader>ax",
    },
  },
}

-- Advanced LSP configuration (Enhanced from all distributions)
M.lsp = vim.tbl_deep_extend("force", M.lsp, {
  -- Server management
  servers = {
    -- TypeScript/JavaScript (prefer ts_ls over vtsls for stability)
    ts_ls = {
      enabled = true,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
      },
    },
    
    -- Lua
    lua_ls = {
      enabled = true,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
          completion = { callSnippet = "Replace" },
          telemetry = { enable = false },
          hint = { enable = true },
        },
      },
    },
    
    -- Python
    pyright = {
      enabled = true,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
          },
        },
      },
    },
    
    -- Go
    gopls = {
      enabled = true,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
          gofumpt = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
    
    -- Rust
    rust_analyzer = {
      enabled = true,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
          inlayHints = {
            bindingModeHints = { enable = false },
            chainingHints = { enable = true },
            closingBraceHints = { enable = true, minLines = 25 },
            closureReturnTypeHints = { enable = "never" },
            lifetimeElisionHints = { enable = "never", useParameterNames = false },
            maxLength = 25,
            parameterHints = { enable = true },
            reborrowHints = { enable = "never" },
            renderColons = true,
            typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
          },
        },
      },
    },
  },
  
  -- Enhanced diagnostics
  diagnostics = {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      format = function(diagnostic)
        return string.format("%s (%s) [%s]", diagnostic.message, diagnostic.source, diagnostic.code or "")
      end,
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
  },
  
  -- Progress reporting
  progress = {
    enabled = true,
    format = "percentage", -- percentage, title, both
    max_clients = 5,
  },
})

-- Navigation configuration (telescope + neo-tree + harpoon)
M.navigation = {
  -- Telescope configuration
  telescope = {
    enabled = true,
    extensions = { "fzf", "ui-select", "file_browser", "projects" },
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "truncate" },
      file_ignore_patterns = M.ui.ignore_patterns,
    },
  },
  
  -- Neo-tree configuration
  neo_tree = {
    enabled = true,
    position = "left",
    width = 30,
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
  },
  
  -- Harpoon configuration
  harpoon = {
    enabled = true,
    save_on_toggle = false,
    sync_on_ui_close = true,
    mark_branch = false,
  },
  
  -- Flash (quick navigation)
  flash = {
    enabled = true,
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
    },
    jump = {
      jumplist = true,
      pos = "start",
      history = false,
      register = false,
    },
  },
}

-- Git configuration
M.git = {
  -- Gitsigns
  signs = {
    enabled = true,
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  
  -- Git integration
  blame = {
    enabled = true,
    format = "%an, %ar - %s",
  },
  
  -- Conflict resolution
  merge_conflict = {
    enabled = true,
    default_mappings = true,
    highlight_groups = {
      incoming = "DiffAdd",
      current = "DiffText",
    },
  },
}

-- Testing configuration (neotest)
M.testing = {
  enabled = true,
  adapters = {
    "neotest-jest",
    "neotest-vitest",
    "neotest-python",
    "neotest-go",
    "neotest-rust",
  },
  quickfix = {
    enabled = true,
    open = false,
  },
  status = {
    enabled = true,
    virtual_text = true,
    signs = true,
  },
}

-- Debugging configuration (nvim-dap)
M.debugging = {
  enabled = true,
  ui = {
    enabled = true,
    icons = {
      expanded = "",
      collapsed = "",
      current_frame = "",
    },
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
  },
  virtual_text = true,
  adapters = {
    "js-debug-adapter",
    "python",
    "delve", -- Go
    "lldb", -- Rust/C/C++
  },
}

-- Get a configuration value with fallback
-- @param path string Dot-separated path to the config value
-- @param default any Default value if path doesn't exist
-- @return any The configuration value or default
function M.get(path, default)
  local keys = vim.split(path, ".", { plain = true })
  local value = M
  
  for _, key in ipairs(keys) do
    if type(value) ~= "table" then
      return default
    end
    value = value[key]
    if value == nil then
      return default
    end
  end
  
  return value
end

-- Override configuration values
-- @param overrides table Table of configuration overrides
function M.setup(overrides)
  M = vim.tbl_deep_extend("force", M, overrides or {})
end

-- Validate configuration
-- @return boolean, string[] success, errors
function M.validate()
  local errors = {}
  
  -- Validate performance settings
  if M.performance.startup_time_target < 50 then
    table.insert(errors, "performance.startup_time_target too low (minimum 50ms)")
  end
  
  -- Validate UI settings
  if M.ui.statusline.enabled and not M.ui.statusline.style then
    table.insert(errors, "ui.statusline.style required when statusline is enabled")
  end
  
  -- Validate LSP settings
  if M.lsp.servers and type(M.lsp.servers) ~= "table" then
    table.insert(errors, "lsp.servers must be a table")
  end
  
  -- Validate keymaps
  if M.keymaps.leader == M.keymaps.localleader then
    table.insert(errors, "leader and localleader cannot be the same")
  end
  
  return #errors == 0, errors
end

-- Get health information
-- @return table Health status information
function M.health()
  local health = {
    performance = {
      startup_time_target = M.performance.startup_time_target,
      memory_usage = vim.fn.system("ps -o rss= -p " .. vim.fn.getpid()),
    },
    features = {
      lsp_enabled = M.lsp ~= nil,
      ai_enabled = M.ai.copilot.enabled or M.ai.codeium.enabled,
      git_enabled = M.git.signs.enabled,
      testing_enabled = M.testing.enabled,
      debugging_enabled = M.debugging.enabled,
    },
    plugin_count = 0, -- Will be filled by lazy.nvim
  }
  
  return health
end

return M