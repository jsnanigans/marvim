return {
  {
    "rcarriga/nvim-notify",
    keys = function()
      return require("config.keymaps").notify_keys
    end,
    opts = function()
      return {
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
        background_colour = function()
          local ok, theme = pcall(require, "utils.theme")
          if ok then
            return theme.semantic.bg_float
          end
          return "#1f1d2e"
        end,
        stages = "fade_in_slide_out",
        render = "wrapped-compact",
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      }
    end,
    init = function()
      if not pcall(require, "telescope") then
        local function notify(...)
          require("lazy").load({ plugins = { "nvim-notify" } })
          return vim.notify(...)
        end
        vim.notify = notify
      end
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
              },
            },
            view = "mini",
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        views = {
          cmdline_popup = {
            border = {
              style = "rounded",
              highlight = "FloatBorder",
            },
            win_options = {
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = 8,
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              highlight = "FloatBorder",
            },
            win_options = {
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            },
          },
        },
      }
    end,
    keys = function()
      return require("config.keymaps").noice_keys
    end,
  },
}
