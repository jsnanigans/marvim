-- LSP and completion plugins
return {
  -- All LSP plugins are complex enough to warrant separate files
  { import = "config.plugins.lsp.config" },
  { import = "config.plugins.lsp.mason" },
  { import = "config.plugins.lsp.completion" },
  { import = "config.plugins.lsp.lazydev" },
}
