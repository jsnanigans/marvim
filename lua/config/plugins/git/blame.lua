return {
  {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      enabled = false,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
      highlight_group = "Comment",
      set_extmark_options = {
        hl_mode = "combine",
      },
      display_virtual_text = true,
      ignored_filetypes = { "gitcommit", "gitrebase", "gitconfig" },
      delay = 1000,
    },
  },
}