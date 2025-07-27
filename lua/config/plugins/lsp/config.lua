return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      "mason-org/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- Add delay for better performance
          delay = 300,
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        -- Float window appears after delay
        float = {
          delay = 300,
        },
      },
      inlay_hints = {
        enabled = true,
      },
      codelens = {
        enabled = true,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        ts_ls = {
          enabled = false,
        },
      },
      setup = {
        ts_ls = function()
          return true
        end,
      },
    },
    config = function(_, opts)
      -- Configure LSP handlers with borders
      vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
        config = config or {}
        config.border = config.border or "rounded"
        config.winhighlight = config.winhighlight or "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
        if
          not result
          or not result.contents
          or (type(result.contents) == "table" and vim.tbl_isempty(result.contents))
          or (type(result.contents) == "string" and result.contents == "")
        then
          return
        end
        return vim.lsp.handlers.hover(_, result, ctx, config)
      end

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      })

      vim.diagnostic.config({
        float = {
          border = "rounded",
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      })

      local Util = require("utils.lsp")
      Util.setup()
      Util.on_attach(function(client, buffer)
        local ok, keymaps = pcall(require, "config.keymaps")
        if ok and keymaps.setup_lsp_keybindings then
          keymaps.setup_lsp_keybindings(client, buffer)
        end
      end)
      local lsp_cache = require("utils.lsp_cache")
      local server_configs = require("utils.lsp_servers")

      -- Use cached capabilities for performance
      local capabilities = vim.tbl_deep_extend("force", lsp_cache.get_capabilities(), opts.capabilities or {})

      -- Merge lazy-loaded server configs with opts.servers
      local servers = vim.tbl_deep_extend("force", {
        lua_ls = server_configs.get_server_config("lua_ls"),
        vtsls = server_configs.get_server_config("vtsls"),
        eslint = server_configs.get_server_config("eslint"),
        jsonls = server_configs.get_server_config("jsonls"),
        clangd = server_configs.get_server_config("clangd"),
        pyright = server_configs.get_server_config("pyright"),
        dartls = server_configs.get_server_config("dartls"),
      }, opts.servers)
      local function setup(server)
        if server == "ts_ls" then
          return
        end
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = mlsp.get_available_servers()
      end
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled == false then
            goto continue
          end
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
        ::continue::
      end
      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end
      vim.diagnostic.config(vim.deepcopy(Util.get_config("diagnostics")))
      -- Defer heavy features until buffer is actually used
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = vim.api.nvim_create_augroup("lsp_deferred_features", { clear = true }),
        once = true,
        callback = function()
          local inlay_hint = Util.get_config("inlay_hints")
          if inlay_hint.enabled then
            Util.on_attach(function(client, buffer)
              if client:supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
              end
            end)
          end

          local codelens = Util.get_config("codelens")
          if codelens.enabled then
            Util.on_attach(function(client, buffer)
              if client:supports_method("textDocument/codeLens") then
                vim.defer_fn(function()
                  if vim.api.nvim_buf_is_valid(buffer) then
                    local codelens_augroup = vim.api.nvim_create_augroup("lsp_codelens_" .. buffer, { clear = true })
                    pcall(vim.lsp.codelens.refresh, { bufnr = buffer })

                    -- Debounced codelens refresh
                    local refresh_timer = nil
                    local function debounced_refresh()
                      if refresh_timer then
                        vim.fn.timer_stop(refresh_timer)
                      end
                      refresh_timer = vim.fn.timer_start(500, function()
                        if vim.g.codelens_enabled ~= false and vim.api.nvim_buf_is_valid(buffer) then
                          pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
                        end
                      end)
                    end

                    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
                      buffer = buffer,
                      group = codelens_augroup,
                      callback = debounced_refresh,
                    })

                    -- Less frequent refresh for text changes
                    vim.api.nvim_create_autocmd({ "TextChanged" }, {
                      buffer = buffer,
                      group = codelens_augroup,
                      callback = function()
                        if refresh_timer then
                          vim.fn.timer_stop(refresh_timer)
                        end
                        refresh_timer = vim.fn.timer_start(2000, function() -- 2 second delay for text changes
                          if vim.g.codelens_enabled ~= false and vim.api.nvim_buf_is_valid(buffer) then
                            pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
                          end
                        end)
                      end,
                    })

                    vim.api.nvim_create_autocmd("BufDelete", {
                      buffer = buffer,
                      callback = function()
                        pcall(vim.api.nvim_del_augroup_by_name, "lsp_codelens_" .. buffer)
                      end,
                    })
                  end
                end, 100)
              end
            end)
          end
        end,
      })
    end,
  },
}
