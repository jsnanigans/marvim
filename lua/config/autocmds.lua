local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Root utilities setup
local ok_root, root_utils = pcall(require, "utils.root")
if ok_root then
  root_utils.setup()
end

-- Highlight yanked text
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 150,
      on_visual = true,
    })
  end,
})

-- Resize splits when window resizes
augroup("ResizeSplits", { clear = true })
autocmd({ "VimResized" }, {
  group = "ResizeSplits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Close certain windows with 'q'
augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = "CloseWithQ",
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

-- Enable wrap and spell for text files
augroup("WrapSpell", { clear = true })
autocmd("FileType", {
  group = "WrapSpell",
  pattern = { "*.txt", "*.md", "*.tex", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Disable conceallevel for JSON files
augroup("JsonConceal", { clear = true })
autocmd({ "FileType" }, {
  group = "JsonConceal",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto-create directories when saving files
augroup("AutoCreateDir", { clear = true })
autocmd({ "BufWritePre" }, {
  group = "AutoCreateDir",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Check for file changes when gaining focus
augroup("CheckTime", { clear = true })
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = "CheckTime",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Remember last cursor position
augroup("LastPosition", { clear = true })
autocmd("BufReadPost", {
  group = "LastPosition",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Enhanced filetype detection with Treesitter fallback
augroup("FiletypeDetect", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
  group = "FiletypeDetect",
  callback = function(event)
    local buf = event.buf
    local filename = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].filetype == "" and filename ~= "" then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("filetype detect")
      end)
    end
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype ~= "" then
        local ok, _ = pcall(vim.treesitter.start, buf)
        if not ok then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("syntax enable")
          end)
        end
      end
    end, 100)
  end,
})
