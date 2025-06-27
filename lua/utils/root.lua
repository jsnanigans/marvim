local M = {}

-- ============================================================================
-- ROOT DETECTION CONFIGURATION
-- ============================================================================

M.root_markers = {
  ".git",
  ".hg",
  ".svn",
  ".bzr",
  "_darcs",
  ".root",
  "package.json",
  "Cargo.toml",
  "go.mod",
  "Gemfile",
  "Makefile",
  "CMakeLists.txt",
  "build.gradle",
  "pom.xml",
  "project.clj",
  "deps.edn",
  "mix.exs",
  "rebar.config",
  "composer.json",
  "pyproject.toml",
  "setup.py",
  "requirements.txt",
  "pubspec.yaml",
  ".project",
  ".classpath",
}

local root_cache = {}

-- ============================================================================
-- ROOT FINDING FUNCTIONS
-- ============================================================================

function M.find_root(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)

  if file == "" then
    return vim.fn.getcwd()
  end

  local cached = root_cache[file]
  if cached then
    return cached
  end

  local root_files = vim.fs.find(M.root_markers, {
    upward = true,
    path = vim.fn.fnamemodify(file, ":p:h"),
  })

  local root = nil
  if #root_files > 0 then
    root = vim.fn.fnamemodify(root_files[1], ":p:h")
  else
    root = vim.fn.getcwd()
  end

  root_cache[file] = root
  return root
end

function M.get_or_set_root(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local root = M.find_root(buf)
  vim.b[buf].project_root = root
  return root
end

function M.cd_root(buf)
  local root = M.find_root(buf)
  if root and root ~= vim.fn.getcwd() then
    vim.cmd("cd " .. vim.fn.fnameescape(root))
    vim.notify("Changed directory to: " .. root, vim.log.levels.INFO)
  end
end

-- ============================================================================
-- SETUP AND AUTOCMDS
-- ============================================================================

function M.setup()
  local group = vim.api.nvim_create_augroup("RootDetection", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = group,
    callback = function(args)
      M.get_or_set_root(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
      root_cache = {}
    end,
  })
end

-- ============================================================================
-- MARKER MANAGEMENT
-- ============================================================================

function M.add_markers(markers)
  if type(markers) == "string" then
    markers = { markers }
  end

  for _, marker in ipairs(markers) do
    if not vim.tbl_contains(M.root_markers, marker) then
      table.insert(M.root_markers, 1, marker)
    end
  end
end

function M.get_markers()
  return vim.deepcopy(M.root_markers)
end

return M
