return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = function() return require("config.keymaps").trouble_keys end,
  },
}