local M = {}

function M.setup()
  local keymaps = require("core.keymaps")
  
  keymaps.register({
    n = {
      -- File pickers
      ["<leader>ff"] = { "<cmd>Telescope find_files<CR>", { desc = "Find files" } },
      ["<leader>fg"] = { "<cmd>Telescope live_grep<CR>", { desc = "Live grep" } },
      ["<leader>fb"] = { "<cmd>Telescope buffers<CR>", { desc = "Find buffers" } },
      ["<leader>fh"] = { "<cmd>Telescope help_tags<CR>", { desc = "Help tags" } },
      ["<leader>fo"] = { "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" } },
      ["<leader>fc"] = { "<cmd>Telescope commands<CR>", { desc = "Commands" } },
      ["<leader>fk"] = { "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" } },
      ["<leader>fm"] = { "<cmd>Telescope marks<CR>", { desc = "Marks" } },
      ["<leader>fr"] = { "<cmd>Telescope registers<CR>", { desc = "Registers" } },
      
      -- Git pickers
      ["<leader>gs"] = { "<cmd>Telescope git_status<CR>", { desc = "Git status" } },
      ["<leader>gc"] = { "<cmd>Telescope git_commits<CR>", { desc = "Git commits" } },
      ["<leader>gb"] = { "<cmd>Telescope git_branches<CR>", { desc = "Git branches" } },
      ["<leader>gS"] = { "<cmd>Telescope git_stash<CR>", { desc = "Git stash" } },
      
      -- LSP pickers
      ["<leader>lr"] = { "<cmd>Telescope lsp_references<CR>", { desc = "LSP references" } },
      ["<leader>ld"] = { "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP definitions" } },
      ["<leader>lt"] = { "<cmd>Telescope lsp_type_definitions<CR>", { desc = "LSP type definitions" } },
      ["<leader>li"] = { "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP implementations" } },
      ["<leader>ls"] = { "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" } },
      ["<leader>lw"] = { "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Workspace symbols" } },
      ["<leader>le"] = { "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" } },
      
      -- Search variations
      ["<leader>sw"] = { "<cmd>Telescope grep_string<CR>", { desc = "Search word under cursor" } },
      ["<leader>sg"] = { "<cmd>Telescope live_grep<CR>", { desc = "Search by grep" } },
      ["<leader>sf"] = { "<cmd>Telescope find_files<CR>", { desc = "Search files" } },
      ["<leader>sr"] = { "<cmd>Telescope resume<CR>", { desc = "Resume last search" } },
      ["<leader>s/"] = { "<cmd>Telescope search_history<CR>", { desc = "Search history" } },
      ["<leader>sc"] = { "<cmd>Telescope command_history<CR>", { desc = "Command history" } },
      
      -- Custom pickers
      ["<leader>fp"] = { 
        function()
          require("telescope.builtin").find_files({
            cwd = require("core.utils.project").get_current_root()
          })
        end,
        { desc = "Find files in project" } 
      },
      ["<leader>sp"] = { 
        function()
          require("telescope.builtin").live_grep({
            cwd = require("core.utils.project").get_current_root()
          })
        end,
        { desc = "Search in project" } 
      },
    },
    
    v = {
      -- Visual mode search
      ["<leader>sw"] = { 
        function()
          local text = require("core.utils").get_visual_selection()
          require("telescope.builtin").grep_string({ search = text })
        end,
        { desc = "Search selection" } 
      },
    }
  })
end

return M