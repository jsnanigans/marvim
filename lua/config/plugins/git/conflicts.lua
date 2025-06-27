return {
  {
    "akinsho/git-conflict.nvim",
    version = "^1.0.0",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      default_mappings = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
        ancestor = "DiffChange",
      },
    },
  },
}
