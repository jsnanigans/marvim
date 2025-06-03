-- Formatting configuration with prettier and eslint for better TypeScript support
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      
      -- Check if file has prettier config
      local prettier_config_files = {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.js",
        ".prettierrc.cjs",
        ".prettierrc.yaml",
        ".prettierrc.yml",
        ".prettier.config.js",
        ".prettier.config.cjs",
        "package.json", -- can contain prettier config
      }
      
      local has_prettier_config = false
      for _, config_file in ipairs(prettier_config_files) do
        if vim.fn.findfile(config_file, ".;") ~= "" then
          has_prettier_config = true
          break
        end
      end
      
      -- For JS/TS files, only format if prettier config exists
      local filetype = vim.bo[bufnr].filetype
      local js_ts_types = {
        "javascript", "javascriptreact", "typescript", "typescriptreact", "vue"
      }
      
      for _, ft in ipairs(js_ts_types) do
        if filetype == ft and not has_prettier_config then
          return -- Don't format JS/TS without prettier config
        end
      end
      
      return {
        timeout_ms = 3000,
        lsp_format = "fallback",
      }
    end,
    formatters = {
      prettier = {
        condition = function(self, ctx)
          return vim.fs.find({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.yaml",
            ".prettierrc.yml",
            ".prettier.config.js",
            ".prettier.config.cjs",
          }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    
    -- Toggle command
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
} 