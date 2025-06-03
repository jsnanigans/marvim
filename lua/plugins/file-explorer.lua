-- Mini.files - A modern file explorer
return {
  "echasnovski/mini.files",
  version = "*",
  keys = {
    { "<leader>ee", desc = "Toggle file explorer" },
    { "<leader>ef", desc = "Toggle file explorer on current file" },
    { "<leader>ed", desc = "Open file explorer in current directory" },
  },
  config = function()
    local mini_files = require("mini.files")
    
    mini_files.setup({
      -- Customization of explorer windows
      windows = {
        -- Whether to show preview of file/directory under cursor
        preview = false,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 25,
      },
      
      -- Module mappings created only inside explorer.
      mappings = {
        close       = 'q',
        go_in       = 'l',
        go_in_plus  = 'L',
        go_out      = 'h',
        go_out_plus = 'H',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '=',
        trim_left   = '<',
        trim_right  = '>',
      },
      
      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = true,
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },
    })

    -- Set keymaps
    local keymap = vim.keymap.set
    keymap("n", "<leader>ee", function() mini_files.open() end, { desc = "Toggle file explorer" })
    keymap("n", "<leader>ef", function() mini_files.open(vim.api.nvim_buf_get_name(0)) end, { desc = "Toggle file explorer on current file" })
    keymap("n", "<leader>ed", function() mini_files.open(vim.fn.getcwd()) end, { desc = "Open file explorer in current directory" })
  end
} 