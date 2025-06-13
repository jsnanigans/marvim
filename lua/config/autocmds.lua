-- Optimized autocommands for power user workflow
local utils = require("core.utils")
local config = require("core.config")

-- Performance optimization group
local perf = utils.augroup("performance", { clear = true })

-- Check for large files and disable heavy features
utils.autocmd({ "BufReadPre", "FileReadPre" }, {
  group = perf,
  callback = function(event)
    local file = event.match
    if utils.is_large_file(file) then
      vim.b.large_file = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      -- Disable treesitter for large files
      vim.cmd("TSBufDisable highlight")
      vim.cmd("TSBufDisable indent")
    end
  end,
  desc = "Optimize for large files",
})

-- General settings group
local general = utils.augroup("general", { clear = true })

-- Better yank highlighting
utils.autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 200,
    })
  end,
  desc = "Highlight yanked text",
})

-- Auto resize splits when terminal is resized
utils.autocmd("VimResized", {
  group = general,
  pattern = "*",
  command = "tabdo wincmd =",
  desc = "Auto resize splits",
})

-- Close some filetypes with <q>
utils.autocmd("FileType", {
  group = general,
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close with q",
})

-- Auto create parent directories on save
utils.autocmd("BufWritePre", {
  group = general,
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create parent directories",
})

-- Terminal settings
local terminal = utils.augroup("terminal", { clear = true })

utils.autocmd("TermOpen", {
  group = terminal,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings",
})

-- File type specific settings
local filetypes = utils.augroup("filetypes", { clear = true })

-- JSON files
utils.autocmd("FileType", {
  group = filetypes,
  pattern = "json",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = "JSON settings",
})

-- Disable format options for all files to prevent auto-commenting
-- Debounced to reduce frequency
local disable_format_options = utils.debounce(function()
  vim.opt_local.formatoptions:remove({ "c", "r", "o" })
end, 50)

utils.autocmd("BufWinEnter", {
  group = filetypes,
  pattern = "*",
  callback = disable_format_options,
  desc = "Disable auto-commenting",
})

-- Better location restoration with caching
local location_cache = {}
utils.autocmd("BufReadPost", {
  group = general,
  callback = function(event)
    local exclude = { "gitcommit", "commit", "rebase" }
    local buf = event.buf
    local ft = vim.bo[buf].filetype
    
    if vim.tbl_contains(exclude, ft) then
      return
    end
    
    -- Check cache first
    local file = vim.api.nvim_buf_get_name(buf)
    if location_cache[file] then
      local pos = location_cache[file]
      pcall(vim.api.nvim_win_set_cursor, 0, pos)
      return
    end
    
    -- Fall back to mark
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      location_cache[file] = mark
    end
  end,
  desc = "Go to last location when opening a buffer",
})

-- Save location on buffer leave
utils.autocmd("BufLeave", {
  group = general,
  callback = function(event)
    local buf = event.buf
    local file = vim.api.nvim_buf_get_name(buf)
    if file ~= "" then
      location_cache[file] = vim.api.nvim_win_get_cursor(0)
    end
  end,
  desc = "Save cursor location",
})

-- Show cursor line only in active window
local cursorline_group = utils.augroup("cursorline", { clear = true })

-- Combine related autocmds for better performance
utils.autocmd({ "InsertLeave", "WinEnter", "FocusGained" }, {
  group = cursorline_group,
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
  desc = "Show cursorline in active window",
})

utils.autocmd({ "InsertEnter", "WinLeave", "FocusLost" }, {
  group = cursorline_group,
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
  desc = "Hide cursorline in inactive window",
})

-- Auto reload files changed outside of Neovim (throttled)
local checktime = utils.throttle(function()
  vim.cmd("checktime")
end, 1000)

utils.autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = general,
  callback = checktime,
  desc = "Check for file changes",
})

-- LSP Progress indicator with better filtering
utils.autocmd("LspProgress", {
  group = general,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value

    if not client or type(value) ~= "table" then
      return
    end

    -- Filter out noisy clients
    local noisy_clients = { "null-ls", "copilot" }
    if vim.tbl_contains(noisy_clients, client.name) then
      return
    end

    -- Only show notifications for operations that take more than 500ms
    if value.kind == "begin" then
      vim.defer_fn(function()
        if value.percentage and value.percentage < 100 then
          local percentage = ("%.0f%%%%"):format(value.percentage)
          local title = value.title or ""
          local message = value.message and (" " .. value.message) or ""

          utils.notify(title .. message .. " " .. percentage, "INFO", {
            title = client.name,
            timeout = 500,
          })
        end
      end, 500)
    end
  end,
  desc = "LSP Progress indicator",
})

-- Clean up location cache periodically (every 5 minutes)
vim.fn.timer_start(300000, function()
  -- Keep only recent entries (files accessed in last hour)
  local now = os.time()
  local new_cache = {}
  for file, _ in pairs(location_cache) do
    local stat = vim.loop.fs_stat(file)
    if stat and (now - stat.atime.sec) < 3600 then
      new_cache[file] = location_cache[file]
    end
  end
  location_cache = new_cache
end, { ["repeat"] = -1 })