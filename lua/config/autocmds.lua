-- Autocommands for power user workflow
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General settings group
local general = augroup("General", { clear = true })


-- Auto format on save for specific filetypes (excluding JS/TS - handled by eslint/prettier)
autocmd("BufWritePre", {
  group = general,
  pattern = { "*.lua", "*.py", "*.json", "*.md" },
  callback = function()
    -- Check if current file is a JS/TS file and skip formatting
    local filetype = vim.bo.filetype
    local js_ts_types = {
      "javascript", "javascriptreact", "typescript", "typescriptreact", "vue"
    }
    
    for _, ft in ipairs(js_ts_types) do
      if filetype == ft then
        return
      end
    end
    
    vim.lsp.buf.format({ async = false })
  end,
  desc = "Auto format on save (excluding JS/TS)",
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  callback = function()
    -- Save cursor position
    local save_cursor = vim.fn.getpos(".")
    -- Remove trailing whitespace
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    -- Restore cursor position
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace",
})


-- Auto resize splits when terminal is resized
autocmd("VimResized", {
  group = general,
  pattern = "*",
  command = "tabdo wincmd =",
  desc = "Auto resize splits",
})

-- Close some filetypes with <q>
autocmd("FileType", {
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

-- Performance optimization group
local perf = augroup("Performance", { clear = true })

-- Check for large files and disable heavy features
autocmd({ "BufReadPre", "FileReadPre" }, {
  group = perf,
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.fn.expand("<afile>"))
    if ok and stats and stats.size > 1024 * 1024 then -- 1MB
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
    end
  end,
  desc = "Optimize for large files",
})

-- Terminal settings
local terminal = augroup("Terminal", { clear = true })

autocmd("TermOpen", {
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
local filetypes = augroup("FileTypes", { clear = true })

-- JSON files
autocmd("FileType", {
  group = filetypes,
  pattern = "json",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = "JSON settings",
})

-- Disable format options for all files to prevent auto-commenting
-- Use BufWinEnter instead of BufEnter to reduce frequency
autocmd("BufWinEnter", {
  group = filetypes,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable auto-commenting",
})

-- Alpha (dashboard) settings
autocmd("User", {
  group = general,
  pattern = "AlphaReady",
  callback = function()
    vim.cmd([[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
    ]])
  end,
  desc = "Hide tabline in Alpha",
})

-- Auto create parent directories on save
autocmd("BufWritePre", {
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

-- Better yank highlighting
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 200,
    })
  end,
  desc = "Highlight yanked text",
})

-- Auto reload files changed outside of Neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = general,
  command = "checktime",
  desc = "Check for file changes",
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
  group = general,
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last location when opening a buffer",
})

-- Show cursor line only in active window
local cursorline_group = augroup("CursorLine", { clear = true })
autocmd({ "InsertLeave", "WinEnter" }, {
  group = cursorline_group,
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
  desc = "Show cursorline in active window",
})

autocmd({ "InsertEnter", "WinLeave" }, {
  group = cursorline_group,
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
  desc = "Hide cursorline in inactive window",
})

-- Auto toggle hlsearch
local hlsearch_group = augroup("HlSearch", { clear = true })
autocmd("CmdlineEnter", {
  group = hlsearch_group,
  callback = function()
    local cmd = vim.v.event.cmdtype
    if cmd == "/" or cmd == "?" then
      vim.opt.hlsearch = true
    end
  end,
  desc = "Auto enable hlsearch when searching",
})

autocmd("CmdlineLeave", {
  group = hlsearch_group,
  callback = function()
    vim.defer_fn(function()
      vim.opt.hlsearch = false
    end, 50)
  end,
  desc = "Auto disable hlsearch after searching",
})

-- LSP Progress indicator (only show for long operations)
autocmd("LspProgress", {
  group = general,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value

    if not client or type(value) ~= "table" then
      return
    end

    -- Only show notifications for operations that take more than 100ms
    if value.kind == "begin" then
      vim.defer_fn(function()
        if value.percentage and value.percentage < 100 then
          local percentage = ("%.0f%%%%"):format(value.percentage)
          local title = value.title or ""
          local message = value.message and (" " .. value.message) or ""

          vim.notify(title .. message .. " " .. percentage, vim.log.levels.INFO, {
            title = client.name,
            timeout = 500,
          })
        end
      end, 100)
    end
  end,
  desc = "LSP Progress indicator",
}) 