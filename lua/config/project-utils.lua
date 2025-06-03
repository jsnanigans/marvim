-- Project Utilities - Helper functions for project management and navigation
local M = {}

-- Find the root directory of the current project
function M.find_project_root()
  local current_dir = vim.fn.expand('%:p:h')
  local root_patterns = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git', 'Cargo.toml', 'pyproject.toml', 'go.mod' }
  
  local function find_root(path)
    for _, pattern in ipairs(root_patterns) do
      if vim.fn.filereadable(path .. '/' .. pattern) == 1 or vim.fn.isdirectory(path .. '/' .. pattern) == 1 then
        return path
      end
    end
    
    local parent = vim.fn.fnamemodify(path, ':h')
    if parent == path then
      return nil -- Reached filesystem root
    end
    
    return find_root(parent)
  end
  
  return find_root(current_dir) or vim.fn.getcwd()
end

-- Get project name from root directory
function M.get_project_name()
  local root = M.find_project_root()
  return vim.fn.fnamemodify(root, ':t')
end

-- Check if current directory is a monorepo
function M.is_monorepo()
  local packages = M.find_monorepo_packages()
  return #packages > 1
end

-- Find all package.json locations in workspace (for monorepos)
function M.find_monorepo_packages()
  local packages = {}
  local cwd = vim.fn.getcwd()
  
  -- Use find command to locate all package.json files
  local cmd = "find " .. cwd .. " -name 'package.json' -not -path '*/node_modules/*' 2>/dev/null"
  local handle = io.popen(cmd)
  
  if handle then
    for line in handle:lines() do
      local dir = vim.fn.fnamemodify(line, ':h')
      table.insert(packages, {
        path = dir,
        name = vim.fn.fnamemodify(dir, ':t'),
        relative = vim.fn.fnamemodify(dir, ':~:.'),
      })
    end
    handle:close()
  end
  
  return packages
end

-- Change directory to project root
function M.cd_to_project_root()
  local root = M.find_project_root()
  vim.cmd('cd ' .. root)
  vim.notify('Changed directory to: ' .. root, vim.log.levels.INFO)
end

-- Quick project info display
function M.show_project_info()
  local root = M.find_project_root()
  local name = M.get_project_name()
  local is_mono = M.is_monorepo()
  local packages = M.find_monorepo_packages()
  
  local info = {
    "=== Project Information ===",
    "Name: " .. name,
    "Root: " .. root,
    "Type: " .. (is_mono and "Monorepo" or "Single Package"),
  }
  
  if is_mono then
    table.insert(info, "Packages found: " .. #packages)
    for i, pkg in ipairs(packages) do
      if i <= 5 then -- Show first 5 packages
        table.insert(info, "  - " .. pkg.name .. " (" .. pkg.relative .. ")")
      elseif i == 6 then
        table.insert(info, "  - ... and " .. (#packages - 5) .. " more")
        break
      end
    end
  end
  
  table.insert(info, "")
  table.insert(info, "Available commands:")
  table.insert(info, "=== File Search ===")
  table.insert(info, "  <leader>ff - Find files in project (most common)")
  table.insert(info, "  <leader>fd - Find files in current dir")
  table.insert(info, "  <leader>fw - Find files in workspace root (where nvim opened)")
  if is_mono then
    table.insert(info, "  <leader>fm - Find files in monorepo package")
  end
  table.insert(info, "")
  table.insert(info, "=== String Search ===")
  table.insert(info, "  <leader>fs - Find string in project (most common)")
  table.insert(info, "  <leader>fc - Find string under cursor in project")
  table.insert(info, "  <leader>fS - Find string in current dir")
  table.insert(info, "  <leader>fW - Find string in workspace root (where nvim opened)")
  if is_mono then
    table.insert(info, "  <leader>fM - Find string in monorepo package")
  end
  
  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
end

-- Auto commands for project management
local function setup_autocmds()
  local augroup = vim.api.nvim_create_augroup("ProjectUtils", { clear = true })
  
  -- Automatically change to project root when opening a file
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = augroup,
    callback = function()
      -- Only auto-cd if we're not already in the project root
      local current_cwd = vim.fn.getcwd()
      local project_root = M.find_project_root()
      
      if current_cwd ~= project_root then
        -- Check if the current working directory is a subdirectory of project root
        local is_subdir = string.find(current_cwd, project_root, 1, true) == 1
        if not is_subdir then
          vim.cmd('cd ' .. project_root)
        end
      end
    end,
  })
  
  -- Set project-specific settings
  vim.api.nvim_create_autocmd({ "DirChanged" }, {
    group = augroup,
    callback = function()
      -- Re-source project config if it exists
      local project_config = vim.fn.getcwd() .. "/.nvim.lua"
      if vim.fn.filereadable(project_config) == 1 then
        dofile(project_config)
        vim.notify('Loaded project config: .nvim.lua', vim.log.levels.INFO)
      end
    end,
  })
end

-- Setup keymaps for project utilities
local function setup_keymaps()
  local keymap = vim.keymap.set
  
  keymap("n", "<leader>pc", M.cd_to_project_root, { desc = "Change to project root" })
  keymap("n", "<leader>pi", M.show_project_info, { desc = "Show project info" })
end

-- Initialize the module
function M.setup()
  setup_autocmds()
  setup_keymaps()
end

return M 