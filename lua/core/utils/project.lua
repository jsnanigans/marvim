local M = {}

-- Common root patterns used across the config
M.root_patterns = {
  "package.json",
  "tsconfig.json",
  ".git",
  "Makefile",
  "go.mod",
  "Cargo.toml",
  "pyproject.toml",
  "setup.py",
  "requirements.txt",
  "composer.json",
  ".gitignore",
  ".nvimrc",
  ".nvim.lua",
}

-- Cache for root directory lookups
local root_cache = {}

-- Find the root directory of a project
-- @param path string Starting path to search from
-- @param patterns table Optional custom patterns to search for
-- @return string|nil The root directory path or nil if not found
function M.find_root(path, patterns)
  patterns = patterns or M.root_patterns
  
  -- Check cache first
  local cache_key = path .. table.concat(patterns, ",")
  if root_cache[cache_key] then
    return root_cache[cache_key]
  end
  
  local Path = require("plenary.path")
  path = Path:new(path):absolute()
  
  local root = require("lspconfig.util").root_pattern(unpack(patterns))(path)
  
  -- Cache the result
  root_cache[cache_key] = root
  
  return root
end

-- Get monorepo packages for a given root directory
-- @param root string The root directory to search
-- @return table List of package directories
function M.get_monorepo_packages(root)
  local packages = {}
  local patterns = {
    "packages/*/package.json",
    "apps/*/package.json",
    "services/*/package.json",
    "libs/*/package.json",
  }
  
  for _, pattern in ipairs(patterns) do
    local glob_pattern = root .. "/" .. pattern
    local matches = vim.fn.glob(glob_pattern, false, true)
    
    for _, match in ipairs(matches) do
      local package_dir = vim.fn.fnamemodify(match, ":h")
      table.insert(packages, package_dir)
    end
  end
  
  return packages
end

-- Clear the root cache (useful for when project structure changes)
function M.clear_cache()
  root_cache = {}
end

-- Get the current buffer's project root
-- @return string|nil The project root or nil
function M.get_current_root()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return vim.fn.getcwd()
  end
  
  return M.find_root(bufname) or vim.fn.getcwd()
end

-- Check if a path is within a node_modules directory
-- @param path string The path to check
-- @return boolean
function M.is_in_node_modules(path)
  return path:match("node_modules") ~= nil
end

-- Get relative path from project root
-- @param path string The absolute path
-- @param root string Optional root directory (defaults to current project root)
-- @return string The relative path
function M.get_relative_path(path, root)
  root = root or M.get_current_root()
  if not root then
    return path
  end
  
  local Path = require("plenary.path")
  local p = Path:new(path)
  return p:make_relative(root)
end

return M