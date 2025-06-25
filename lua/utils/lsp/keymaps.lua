-- LSP keymaps
-- Key mappings for LSP functionality

local M = {}

function M.on_attach(client, buffer)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = buffer
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- LSP actions (all using Snacks picker for consistent UI)
  map("n", "gd", function() require("snacks").picker.lsp_definitions() end, { desc = "Go to Definition", nowait = true })
  map("n", "gr", function() require("snacks").picker.lsp_references() end, { desc = "References", nowait = true })
  map("n", "gD", function() require("snacks").picker.lsp_declarations() end, { desc = "Go to Declaration", nowait = true })
  map("n", "gI", function() require("snacks").picker.lsp_implementations() end, { desc = "Go to Implementation", nowait = true })
  map("n", "gy", function() require("snacks").picker.lsp_type_definitions() end, { desc = "Go to Type Definition", nowait = true })
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  map("n", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

  -- Code actions
  map({ "n", "v" }, "<leader>ca", function() require("snacks").picker.lsp_code_actions() end, { desc = "Code Action" })
  map("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
  map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh Codelens" })
  map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

  -- Format
  map({ "n", "v" }, "<leader>cf", function()
    require("utils.lsp").format({ buf = buffer })
  end, { desc = "Format" })

  -- Diagnostics
  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

  -- Workspace
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove Workspace Folder" })
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List Workspace Folders" })

  -- Toggle inlay hints
  if client:supports_method("textDocument/inlayHint") then
    map("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }), { bufnr = buffer })
    end, { desc = "Toggle Inlay Hints" })
  end

  -- TypeScript specific
  if client.name == "vtsls" then
    map("n", "<leader>co", function()
      vim.lsp.buf.execute_command({ command = "typescript.organizeImports", arguments = { vim.api.nvim_buf_get_name(0) } })
    end, { desc = "Organize Imports" })
    map("n", "<leader>cR", function()
      require("utils.lsp").rename_file()
    end, { desc = "Rename File" })
  end
end

return M