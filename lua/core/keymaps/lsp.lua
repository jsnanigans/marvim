local M = {}

-- Setup LSP keymaps for a buffer
-- @param bufnr number The buffer number
function M.on_attach(bufnr)
  local keymaps = require("core.keymaps")
  local smart_nav = require("plugins.lsp.smart_navigation")
  
  local function buf_opts(desc)
    return { buffer = bufnr, desc = desc }
  end
  
  keymaps.register({
    n = {
      -- Smart navigation with intelligent fallbacks
      ["gd"] = { smart_nav.smart_goto_definition, buf_opts("Go to definition (smart fallback)") },
      ["gi"] = { smart_nav.smart_goto_implementation, buf_opts("Go to implementation (smart fallback)") },
      
      -- Direct navigation methods (with centering)
      ["gD"] = { smart_nav.goto_declaration, buf_opts("Go to declaration") },
      ["gt"] = { smart_nav.goto_type_definition, buf_opts("Go to type definition") },
      
      -- Additional navigation
      ["gr"] = { smart_nav.goto_references, buf_opts("Find references") },
      
      
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
      ["<leader>lI"] = { ":LspInfo<CR>", buf_opts("LSP info") },
      ["<leader>lR"] = { ":LspRestart<CR>", buf_opts("Restart LSP") },
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
  local smart_nav = require("plugins.lsp.smart_navigation")
  
  keymaps.register({
    n = {
      -- Direct LSP navigation (global, always available)
      ["<leader>Gd"] = { smart_nav.goto_definition, { desc = "Go to definition (direct)" } },
      ["<leader>GD"] = { smart_nav.goto_declaration, { desc = "Go to declaration (direct)" } },
      ["<leader>Gi"] = { smart_nav.goto_implementation, { desc = "Go to implementation (direct)" } },
      ["<leader>Gt"] = { smart_nav.goto_type_definition, { desc = "Go to type definition (direct)" } },
      ["<leader>Gr"] = { smart_nav.goto_references, { desc = "Find references (direct)" } },
      
      -- LSP management commands (using <leader>lm prefix for "LSP management")
      ["<leader>lmI"] = { ":LspInstall<CR>", { desc = "Install LSP server" } },
      ["<leader>lmU"] = { ":LspUninstall<CR>", { desc = "Uninstall LSP server" } },
      ["<leader>lms"] = { ":LspStart<CR>", { desc = "Start LSP" } },
      ["<leader>lmS"] = { ":LspStop<CR>", { desc = "Stop LSP" } },
      ["<leader>lml"] = { ":LspLog<CR>", { desc = "Show LSP log" } },
    }
  })
end

return M