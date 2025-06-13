-- Markdown tools for documentation and notes
return {
  -- Better markdown editing
  {
    "preservim/vim-markdown",
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_json_frontmatter = 1
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_autowrite = 1
      vim.g.vim_markdown_follow_anchor = 1
    end,
  },

  -- Table mode for markdown tables
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    cmd = { "TableModeToggle", "TableModeEnable", "TableModeDisable" },
    keys = {
      { "<leader>tm", "<cmd>TableModeToggle<CR>", desc = "Toggle Table Mode" },
    },
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_corner_corner = "|"
      vim.g.table_mode_header_fillchar = "="
    end,
  },
}