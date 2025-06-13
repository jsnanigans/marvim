-- Formatting configuration with prettier and eslint for better TypeScript support
local config = require("core.config")
local utils = require("core.utils")

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = config.formatting.formatters_by_ft,
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      -- Skip if format on save is disabled globally
      if not config.editor.format_on_save then
        return
      end
      
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      
      -- Check if filetype is in the format-on-save list
      local filetype = vim.bo[bufnr].filetype
      local should_format = false
      
      for _, ft in ipairs(config.formatting.format_on_save_filetypes) do
        if filetype == ft then
          should_format = true
          break
        end
      end
      
      if not should_format then
        return
      end
      
      -- Check if file has prettier config for JS/TS files
      local js_ts_types = {
        "javascript", "javascriptreact", "typescript", "typescriptreact", "vue"
      }
      
      local is_js_ts = vim.tbl_contains(js_ts_types, filetype)
      
      if is_js_ts then
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
        
        -- Don't format JS/TS without prettier config
        if not has_prettier_config then
          return
        end
      end
      
      return {
        timeout_ms = config.editor.format_timeout,
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
    
    -- Toggle commands
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
    
    -- Manual format command
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  end,
}