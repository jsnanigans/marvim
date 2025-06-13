local M = {}

function M.setup()
  local keymaps = require("core.keymaps")
  local config = require("core.config")
  
  keymaps.register({
    n = {
      -- Window navigation
      ["<C-h>"] = { "<C-w>h", { desc = "Navigate to left window" } },
      ["<C-j>"] = { "<C-w>j", { desc = "Navigate to window below" } },
      ["<C-k>"] = { "<C-w>k", { desc = "Navigate to window above" } },
      ["<C-l>"] = { "<C-w>l", { desc = "Navigate to right window" } },
      
      -- Window resizing
      ["<C-Up>"] = { 
        function() vim.cmd("resize +" .. config.ui.window_resize_step) end, 
        { desc = "Increase window height" } 
      },
      ["<C-Down>"] = { 
        function() vim.cmd("resize -" .. config.ui.window_resize_step) end, 
        { desc = "Decrease window height" } 
      },
      ["<C-Left>"] = { 
        function() vim.cmd("vertical resize -" .. config.ui.window_resize_step) end, 
        { desc = "Decrease window width" } 
      },
      ["<C-Right>"] = { 
        function() vim.cmd("vertical resize +" .. config.ui.window_resize_step) end, 
        { desc = "Increase window width" } 
      },
      
      -- Window management
      ["<leader>wv"] = { "<C-w>v", { desc = "Split window vertically" } },
      ["<leader>ws"] = { "<C-w>s", { desc = "Split window horizontally" } },
      ["<leader>we"] = { "<C-w>=", { desc = "Equalize window sizes" } },
      ["<leader>wc"] = { "<C-w>c", { desc = "Close current window" } },
      ["<leader>wo"] = { "<C-w>o", { desc = "Close other windows" } },
      ["<leader>ww"] = { "<C-w>w", { desc = "Switch windows" } },
      
      -- Window swap and rotate
      ["<leader>wx"] = { "<C-w>x", { desc = "Swap current with next" } },
      ["<leader>wr"] = { "<C-w>r", { desc = "Rotate windows downwards" } },
      ["<leader>wR"] = { "<C-w>R", { desc = "Rotate windows upwards" } },
      
      -- Move window to different position
      ["<leader>wH"] = { "<C-w>H", { desc = "Move window to far left" } },
      ["<leader>wJ"] = { "<C-w>J", { desc = "Move window to very bottom" } },
      ["<leader>wK"] = { "<C-w>K", { desc = "Move window to very top" } },
      ["<leader>wL"] = { "<C-w>L", { desc = "Move window to far right" } },
    }
  })
end

return M