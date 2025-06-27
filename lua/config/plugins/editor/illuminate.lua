return {
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      -- Keymaps handled via keys table in keymaps.lua
    end,
    keys = function() return require("config.keymaps").illuminate_keys end,
  },
}