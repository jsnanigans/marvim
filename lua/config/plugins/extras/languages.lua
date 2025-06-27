return {
  {
    "nvim-java/nvim-java",
    enabled = false,
    ft = "java",
    config = function()
      require("java").setup()
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    enabled = false,
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        ui = {
          border = "rounded",
          notification_style = "nvim-notify",
        },
        decorations = {
          statusline = {
            app_version = false,
            device = true,
          },
        },
        debugger = {
          enabled = false,
          run_via_dap = false,
        },
        flutter_lookup_cmd = "asdf where flutter",
        fvm = false,
        widget_guides = {
          enabled = false,
        },
        closing_tags = {
          highlight = "ErrorMsg",
          prefix = "//",
          enabled = true,
        },
        dev_log = {
          enabled = true,
          notify_errors = false,
          open_cmd = "tabnew",
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },
        lsp = {
          color = {
            enabled = false,
            background = false,
            background_color = nil,
            foreground = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          on_attach = function(client, bufnr) end,
          capabilities = function(config)
            config.textDocument.completion.completionItem.snippetSupport = true
            return config
          end,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = { vim.fn.expand("$HOME/AppData/Local/Pub/Cache") },
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        },
      })
    end,
  },
}
