-- Coding enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Diagnostics with simple config
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = function()
      return require("config.keymaps").trouble_keys
    end,
  },

  -- Todo comments with minimal config
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = true,
    keys = function()
      return require("config.keymaps").todo_comments_keys
    end,
  },

  -- Snippets with simple build function
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
        return
      end
      return "make install_jsregexp"
    end)(),
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = function()
      return require("config.keymaps").luasnip_keys
    end,
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.coding.treesitter" },
  { import = "config.plugins.coding.conform" },
}
