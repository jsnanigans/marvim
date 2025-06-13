local M = {}

-- Setup LSP keymaps for a buffer
-- @param bufnr number The buffer number
function M.on_attach(bufnr)
  local keymaps = require("core.keymaps")
  
  local function buf_opts(desc)
    return { buffer = bufnr, desc = desc }
  end
  
  keymaps.register({
    n = {
      -- Go to definition/declaration
      ["gd"] = { vim.lsp.buf.definition, buf_opts("Go to definition") },
      ["gD"] = { vim.lsp.buf.declaration, buf_opts("Go to declaration") },
      ["gi"] = { vim.lsp.buf.implementation, buf_opts("Go to implementation") },
      ["gr"] = { vim.lsp.buf.references, buf_opts("Find references") },
      ["gt"] = { vim.lsp.buf.type_definition, buf_opts("Go to type definition") },
      
      -- Documentation and hover
      ["K"] = { vim.lsp.buf.hover, buf_opts("Show hover documentation") },
      ["<C-k>"] = { vim.lsp.buf.signature_help, buf_opts("Show signature help") },
      
      -- Code actions and refactoring
      ["<leader>ca"] = { vim.lsp.buf.code_action, buf_opts("Code action") },
      ["<leader>rn"] = { vim.lsp.buf.rename, buf_opts("Rename symbol") },
      ["<leader>f"] = { 
        function() vim.lsp.buf.format({ async = true }) end, 
        buf_opts("Format document") 
      },
      
      -- Workspace management
      ["<leader>wa"] = { vim.lsp.buf.add_workspace_folder, buf_opts("Add workspace folder") },
      ["<leader>wr"] = { vim.lsp.buf.remove_workspace_folder, buf_opts("Remove workspace folder") },
      ["<leader>wl"] = { 
        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 
        buf_opts("List workspace folders") 
      },
      
      -- Diagnostics
      ["<leader>d"] = { vim.diagnostic.open_float, buf_opts("Show line diagnostics") },
      ["[d"] = { vim.diagnostic.goto_prev, buf_opts("Previous diagnostic") },
      ["]d"] = { vim.diagnostic.goto_next, buf_opts("Next diagnostic") },
      ["<leader>q"] = { vim.diagnostic.setloclist, buf_opts("Set location list") },
      
      -- Additional helpers
      ["<leader>li"] = { ":LspInfo<CR>", buf_opts("LSP info") },
      ["<leader>lr"] = { ":LspRestart<CR>", buf_opts("Restart LSP") },
    },
    
    v = {
      -- Visual mode code actions
      ["<leader>ca"] = { vim.lsp.buf.code_action, buf_opts("Code action") },
      ["<leader>f"] = { 
        function() vim.lsp.buf.format({ async = true }) end, 
        buf_opts("Format selection") 
      },
    },
    
    i = {
      -- Insert mode helpers
      ["<C-k>"] = { vim.lsp.buf.signature_help, buf_opts("Show signature help") },
    }
  })
end

-- Setup default LSP keymaps (not buffer-specific)
function M.setup()
  local keymaps = require("core.keymaps")
  
  keymaps.register({
    n = {
      -- LSP management commands
      ["<leader>lI"] = { ":LspInstall<CR>", { desc = "Install LSP server" } },
      ["<leader>lU"] = { ":LspUninstall<CR>", { desc = "Uninstall LSP server" } },
      ["<leader>ls"] = { ":LspStart<CR>", { desc = "Start LSP" } },
      ["<leader>lS"] = { ":LspStop<CR>", { desc = "Stop LSP" } },
      ["<leader>ll"] = { ":LspLog<CR>", { desc = "Show LSP log" } },
    }
  })
end

return M