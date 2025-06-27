return {
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = true,
    keys = function()
      return require("config.keymaps").todo_comments_keys
    end,
  },
}
