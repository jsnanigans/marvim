-- GitHub Copilot - AI-powered code completion with ghost text
return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  dependencies = {
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    require("copilot").setup({
      panel = {
        enabled = false, -- Disable panel
      },
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Enable ghost text suggestions
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<C-l>",
          accept_word = "<M-w>",
          accept_line = "<M-e>",
          next = "<C-;>",
          prev = "<C-S-;>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 20
      server_opts_overrides = {},
    })

    -- Optional: Add a keymap to toggle auto suggestions
    vim.keymap.set("n", "<leader>ct", function()
      require("copilot.suggestion").toggle_auto_trigger()
    end, { desc = "Toggle Copilot auto trigger" })
  end,
} 