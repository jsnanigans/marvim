return {
  {
    "github/copilot.vim",
    enabled = true,
    cmd = { "Copilot" },
    event = { "InsertEnter", "VeryLazy" },
    keys = function()
      return require("config.keymaps").copilot_keys
    end,
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },
}
