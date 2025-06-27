local M = {}
local keymap_utils = require("utils.keymaps")

-- ============================================================================
-- ROOT DIRECTORY OPERATIONS
-- ============================================================================

function M.setup_root_operations()
  local map = keymap_utils.create_safe_mapper("root_operations")

  -- Root directory operations
  map("n", "<leader>cD", function()
    local available, root_utils = keymap_utils.is_available("utils.root")
    if available then
      local success, err = pcall(root_utils.cd_root)
      if not success then
        vim.notify("Failed to change to root directory: " .. err, vim.log.levels.ERROR)
      else
        local cwd = vim.fn.getcwd()
        vim.notify("Changed to root directory: " .. cwd, vim.log.levels.INFO)
      end
    else
      vim.notify("Root utilities not available", vim.log.levels.WARN)
    end
  end, { desc = "Change to Root Directory" })

  map("n", "<leader>cR", function()
    local available, root_utils = keymap_utils.is_available("utils.root")
    if available then
      local success, root = pcall(root_utils.find_root)
      if not success then
        vim.notify("Failed to find root directory: " .. root, vim.log.levels.ERROR)
      else
        vim.notify("Project root: " .. root, vim.log.levels.INFO)
      end
    else
      vim.notify("Root utilities not available", vim.log.levels.WARN)
    end
  end, { desc = "Show Root Directory" })

  -- Project navigation
  map("n", "<leader>fp", function()
    local available, snacks = keymap_utils.is_available("snacks")
    if available and snacks.picker then
      snacks.picker.files({
        cwd = vim.fn.expand("~/Projects"),
        find_command = { "find", ".", "-type", "d", "-name", ".git" },
        prompt_title = "Projects",
      })
    else
      vim.notify("Snacks picker not available for project navigation", vim.log.levels.WARN)
    end
  end, { desc = "Find Projects" })

  -- Alternative project navigation using built-in file picker as fallback
  map("n", "<leader>fP", function()
    vim.ui.select(
      vim.fn.glob(vim.fn.expand("~/Projects") .. "/*", false, true),
      { prompt = "Select Project:" },
      function(choice)
        if choice then
          vim.cmd("cd " .. choice)
          vim.notify("Changed to project: " .. vim.fn.fnamemodify(choice, ":t"), vim.log.levels.INFO)
        end
      end
    )
  end, { desc = "Find Projects (Fallback)" })
end

return M
