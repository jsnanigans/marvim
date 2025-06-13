local M = {}

-- Performance settings
M.performance = {
  -- File size threshold for large file optimizations (1MB)
  large_file_size = 1024 * 1024,
  
  -- Maximum file size to enable features (10MB)
  max_file_size = 10 * 1024 * 1024,
  
  -- Lazy redraw for better performance
  lazy_redraw = false,
  
  -- Update time for CursorHold events
  updatetime = 300,
  
  -- Time to wait for a mapped sequence
  timeoutlen = 500,
  
  -- Redraw time for 'hlsearch' and 'incsearch'
  redrawtime = 10000,
}

-- UI settings
M.ui = {
  -- Window resize step size
  window_resize_step = 2,
  
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
  format_timeout = 5000,
  
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
    javascript = { "prettier", "eslint_d" },
    javascriptreact = { "prettier", "eslint_d" },
    typescript = { "prettier", "eslint_d" },
    typescriptreact = { "prettier", "eslint_d" },
    vue = { "prettier", "eslint_d" },
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

return M