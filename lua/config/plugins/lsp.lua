-- LSP and completion plugins
-- Plugin files with 18+ lines get their own file, smaller ones are consolidated here

return {
  -- All LSP plugins are complex enough to warrant separate files
  { import = "config.plugins.lsp.config" },
  { import = "config.plugins.lsp.mason" },
  { import = "config.plugins.lsp.completion" },
  { import = "config.plugins.lsp.lazydev" },
}
