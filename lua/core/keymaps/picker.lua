local M = {}

function M.setup()
  local keymaps = require("core.keymaps")
  
  keymaps.register({
    n = {
      -- File pickers
      ["<leader>ff"] = { function() require("snacks").picker.files() end, { desc = "Find files" } },
      ["<leader>fg"] = { function() require("snacks").picker.grep() end, { desc = "Live grep" } },
      ["<leader>fb"] = { function() require("snacks").picker.buffers() end, { desc = "Find buffers" } },
      ["<leader>fh"] = { function() require("snacks").picker.help() end, { desc = "Help tags" } },
      ["<leader>fo"] = { function() require("snacks").picker.recent() end, { desc = "Recent files" } },
      ["<leader>fc"] = { function() require("snacks").picker.commands() end, { desc = "Commands" } },
      ["<leader>fk"] = { function() require("snacks").picker.keymaps() end, { desc = "Keymaps" } },
      ["<leader>fm"] = { function() require("snacks").picker.marks() end, { desc = "Marks" } },
      ["<leader>fr"] = { function() require("snacks").picker.registers() end, { desc = "Registers" } },
      
      -- Git pickers
      ["<leader>gs"] = { function() require("snacks").picker.git_status() end, { desc = "Git status" } },
      ["<leader>gc"] = { function() require("snacks").picker.git_log() end, { desc = "Git commits" } },
      ["<leader>gb"] = { function() require("snacks").picker.git_branches() end, { desc = "Git branches" } },
      ["<leader>gS"] = { function() require("snacks").picker.git_stash() end, { desc = "Git stash" } },
      
      -- LSP pickers
      ["<leader>lr"] = { function() require("snacks").picker.lsp_references() end, { desc = "LSP references" } },
      ["<leader>ld"] = { function() require("snacks").picker.lsp_definitions() end, { desc = "LSP definitions" } },
      ["<leader>lt"] = { function() require("snacks").picker.lsp_type_definitions() end, { desc = "LSP type definitions" } },
      ["<leader>li"] = { function() require("snacks").picker.lsp_implementations() end, { desc = "LSP implementations" } },
      ["<leader>ls"] = { function() require("snacks").picker.lsp_symbols() end, { desc = "Document symbols" } },
      ["<leader>lw"] = { function() require("snacks").picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" } },
      ["<leader>le"] = { function() require("snacks").picker.diagnostics() end, { desc = "Diagnostics" } },
      
      -- Search variations
      ["<leader>sw"] = { function() require("snacks").picker.grep_string() end, { desc = "Search word under cursor" } },
      ["<leader>sg"] = { function() require("snacks").picker.grep() end, { desc = "Search by grep" } },
      ["<leader>sf"] = { function() require("snacks").picker.files() end, { desc = "Search files" } },
      ["<leader>sr"] = { function() require("snacks").picker.resume() end, { desc = "Resume last search" } },
      ["<leader>s/"] = { function() require("snacks").picker.search_history() end, { desc = "Search history" } },
      ["<leader>sc"] = { function() require("snacks").picker.command_history() end, { desc = "Command history" } },
      
      -- Custom pickers
      ["<leader>fp"] = { 
        function()
          require("snacks").picker.files({
            cwd = require("core.utils.project").get_current_root()
          })
        end,
        { desc = "Find files in project" } 
      },
      ["<leader>sp"] = { 
        function()
          require("snacks").picker.grep({
            cwd = require("core.utils.project").get_current_root()
          })
        end,
        { desc = "Search in project" } 
      },
      ["<leader>ft"] = { 
        function()
          require("snacks").picker.grep({
            search = "TODO|HACK|FIX|NOTE|WARN|PERF|TEST",
            additional_args = { "--type-add", "code:*.{js,ts,jsx,tsx,lua,py,go,rs,c,cpp,h,hpp}" }
          })
        end,
        { desc = "Find todos" } 
      },
    },
    
    v = {
      -- Visual mode search
      ["<leader>sw"] = { 
        function()
          local text = require("core.utils").get_visual_selection()
          require("snacks").picker.grep_string({ search = text })
        end,
        { desc = "Search selection" } 
      },
    }
  })
end

return M