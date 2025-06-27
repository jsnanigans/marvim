local M = {}

-- Utility function
local function is_available(module)
  local ok, mod = pcall(require, module)
  return ok and mod ~= nil
end

-- ============================================================================
-- LSP KEYBINDINGS
-- ============================================================================

function M.setup_lsp_keybindings(client, buffer)
  local function lsp_map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = buffer
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Navigation (using Snacks picker if available, fallback to built-in)
  if is_available("snacks") then
    local snacks = require("snacks")
    if snacks.picker then
      lsp_map("n", "gd", function()
        snacks.picker.lsp_definitions()
      end, { desc = "Go to Definition", nowait = true })
      lsp_map("n", "gr", function()
        snacks.picker.lsp_references()
      end, { desc = "References", nowait = true })
      lsp_map("n", "gD", function()
        snacks.picker.lsp_declarations()
      end, { desc = "Go to Declaration", nowait = true })
      lsp_map("n", "gI", function()
        snacks.picker.lsp_implementations()
      end, { desc = "Go to Implementation", nowait = true })
      lsp_map("n", "gy", function()
        snacks.picker.lsp_type_definitions()
      end, { desc = "Go to Type Definition", nowait = true })
    else
      -- Fallback to built-in LSP functions
      lsp_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      lsp_map("n", "gr", vim.lsp.buf.references, { desc = "References" })
      lsp_map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
      lsp_map("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
      lsp_map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
    end
  else
    -- Fallback to built-in LSP functions
    lsp_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    lsp_map("n", "gr", vim.lsp.buf.references, { desc = "References" })
    lsp_map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
    lsp_map("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
    lsp_map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
  end

  -- Documentation and help
  lsp_map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  lsp_map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  lsp_map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  lsp_map("n", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

  -- Code actions and refactoring
  if is_available("snacks") then
    local snacks = require("snacks")
    if snacks.picker and snacks.picker.lsp_code_actions then
      lsp_map({ "n", "v" }, "<leader>ca", function()
        snacks.picker.lsp_code_actions()
      end, { desc = "Code Action" })
    else
      lsp_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    end
  else
    lsp_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  end

  lsp_map("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
  lsp_map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh Codelens" })
  lsp_map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

  -- Formatting
  lsp_map({ "n", "v" }, "<leader>cf", function()
    local ok, lsp_utils = pcall(require, "utils.lsp")
    if ok then
      lsp_utils.format({ buf = buffer })
    else
      vim.lsp.buf.format({ async = true })
    end
  end, { desc = "Format" })

  -- Diagnostics
  lsp_map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  lsp_map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostic Quickfix" })

  -- Advanced diagnostics navigation
  lsp_map("n", "[D", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Previous Error" })
  lsp_map("n", "]D", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Next Error" })

  -- Workspace management
  lsp_map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
  lsp_map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove Workspace Folder" })
  lsp_map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List Workspace Folders" })

  -- Symbol search
  if is_available("snacks") then
    local snacks = require("snacks")
    if snacks.picker then
      lsp_map("n", "<leader>ds", function()
        snacks.picker.lsp_document_symbols()
      end, { desc = "Document Symbols" })
      lsp_map("n", "<leader>ws", function()
        snacks.picker.lsp_workspace_symbols()
      end, { desc = "Workspace Symbols" })
    end
  end

  -- Call hierarchy (if supported)
  if client:supports_method("callHierarchy/incomingCalls") then
    lsp_map("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Incoming Calls" })
  end
  if client:supports_method("callHierarchy/outgoingCalls") then
    lsp_map("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Outgoing Calls" })
  end

  -- UI toggles
  if client:supports_method("textDocument/inlayHint") then
    lsp_map("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }), { bufnr = buffer })
    end, { desc = "Toggle Inlay Hints (Buffer)" })
    lsp_map("n", "<leader>uH", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle Inlay Hints (Global)" })
  end

  -- Code lens toggle
  if client:supports_method("textDocument/codeLens") then
    lsp_map("n", "<leader>ul", function()
      local is_enabled = vim.g.codelens_enabled ~= false
      vim.g.codelens_enabled = not is_enabled
      if vim.g.codelens_enabled then
        vim.lsp.codelens.refresh({ bufnr = buffer })
      else
        vim.lsp.codelens.clear(nil, buffer)
      end
    end, { desc = "Toggle Code Lens" })
  end

  -- LSP management
  lsp_map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
  lsp_map("n", "<leader>lR", function()
    vim.cmd("LspRestart")
    vim.notify("LSP Restarted", vim.log.levels.INFO)
  end, { desc = "Restart LSP" })

  -- Document highlighting (if supported)
  if client:supports_method("textDocument/documentHighlight") then
    local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight_" .. buffer, { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = buffer,
      group = highlight_augroup,
      callback = function()
        pcall(vim.lsp.buf.document_highlight)
      end,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = buffer,
      group = highlight_augroup,
      callback = function()
        pcall(vim.lsp.buf.clear_references)
      end,
    })
    -- Clean up when buffer is deleted
    vim.api.nvim_create_autocmd("BufDelete", {
      buffer = buffer,
      callback = function()
        pcall(vim.api.nvim_del_augroup_by_name, "lsp_document_highlight_" .. buffer)
      end,
    })
  end

  -- Language-specific keybindings
  if client.name == "vtsls" then
    -- TypeScript-specific actions using proper vtsls commands
    lsp_map("n", "<leader>cI", function()
      -- Use the standard source.organizeImports code action
      vim.lsp.buf.code_action({
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { desc = "Organize Imports" })

    lsp_map("n", "<leader>cR", function()
      local ok, lsp_utils = pcall(require, "utils.lsp")
      if ok then
        lsp_utils.rename_file()
      end
    end, { desc = "Rename File" })

    lsp_map("n", "<leader>cA", function()
      -- Use code action for adding missing imports
      vim.lsp.buf.code_action({
        context = {
          only = { "source.addMissingImports" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { desc = "Add Missing Imports" })

    lsp_map("n", "<leader>cu", function()
      -- Use code action for removing unused imports
      vim.lsp.buf.code_action({
        context = {
          only = { "source.removeUnused" },
          diagnostics = {},
        },
        apply = true,
      })
    end, { desc = "Remove Unused Imports" })
  end
end

-- ============================================================================
-- GITSIGNS KEYBINDINGS
-- ============================================================================

function M.setup_gitsigns_keybindings(buffer)
  local gs = package.loaded.gitsigns
  if not gs then
    return
  end

  local function git_map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
  end

  -- Hunk navigation
  git_map("n", "]h", gs.next_hunk, "Next Hunk")
  git_map("n", "[h", gs.prev_hunk, "Prev Hunk")

  -- Hunk actions
  git_map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
  git_map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
  git_map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
  git_map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
  git_map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
  git_map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
  git_map("n", "<leader>ghb", function()
    gs.blame_line({ full = true })
  end, "Blame Line")
  git_map("n", "<leader>ghd", gs.diffthis, "Diff This")
  git_map("n", "<leader>ghD", function()
    gs.diffthis("~")
  end, "Diff This ~")

  -- Text objects
  git_map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
end

return M
