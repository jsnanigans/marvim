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
      ["<leader>cr"] = { 
        function()
          local curr_name = vim.fn.expand("<cword>")
          vim.ui.input({
            prompt = "New name: ",
            default = curr_name,
          }, function(new_name)
            if new_name then
              vim.lsp.buf.rename(new_name)
            end
          end)
        end,
        buf_opts("Rename symbol") 
      },
      ["<leader>cf"] = { 
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
      
      -- Diagnostics (using [e and ]e to avoid conflicts)
      ["<leader>cd"] = { vim.diagnostic.open_float, buf_opts("Show line diagnostics") },
      ["[d"] = { vim.diagnostic.goto_prev, buf_opts("Previous diagnostic") },
      ["]d"] = { vim.diagnostic.goto_next, buf_opts("Next diagnostic") },
      ["[D"] = { function() vim.diagnostic.goto_prev({scope="workspace"}) end, buf_opts("Previous workspace diagnostic") },
      ["]D"] = { function() vim.diagnostic.goto_next({scope="workspace"}) end, buf_opts("Next workspace diagnostic") },
      ["<leader>cq"] = { vim.diagnostic.setloclist, buf_opts("Set location list") },
      
      -- Call hierarchy
      ["<leader>ci"] = { vim.lsp.buf.incoming_calls, buf_opts("Show incoming calls") },
      ["<leader>co"] = { vim.lsp.buf.outgoing_calls, buf_opts("Show outgoing calls") },
      
      -- Codelens
      ["<leader>cl"] = { vim.lsp.codelens.run, buf_opts("Run codelens") },
      ["<leader>cL"] = { vim.lsp.codelens.refresh, buf_opts("Refresh codelens") },
      
      -- Additional helpers
      ["<leader>li"] = { ":LspInfo<CR>", buf_opts("LSP info") },
      ["<leader>lR"] = { ":LspRestart<CR>", buf_opts("Restart LSP") },
      ["<leader>uh"] = { 
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({bufnr=0}), {bufnr=0})
        end, 
        buf_opts("Toggle inlay hints (buffer)") 
      },
    },
    
    v = {
      -- Visual mode code actions
      ["<leader>ca"] = { vim.lsp.buf.code_action, buf_opts("Code action") },
      ["<leader>cf"] = { 
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