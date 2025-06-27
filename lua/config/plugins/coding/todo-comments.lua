return {
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = true,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", function() 
          require("snacks").picker.grep({
            search = "TODO|HACK|FIX|NOTE|WARN|PERF|TEST",
          })
        end, desc = "Todo Comments" },
      { "<leader>sT", function() 
          require("snacks").picker.grep({
            search = "TODO|FIX|FIXME",
          })
        end, desc = "Todo/Fix/Fixme" },
    },
  },
}