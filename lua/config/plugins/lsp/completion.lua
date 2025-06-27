return {
  {
    "saghen/blink.cmp",
    priority = 800,
    event = { "InsertEnter", "CmdlineEnter" },
    version = "v0.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "echasnovski/mini.icons",
    },
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            score_offset = 90,
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 3,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = false,
            },
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 85,
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath("config") .. "/snippets" },
              global_snippets = { "all" },
              extended_filetypes = {},
              ignored_filetypes = {},
            },
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            score_offset = -3,
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  if not vim.api.nvim_buf_is_valid(buf) then
                    return false
                  end
                  local ok, byte_size = pcall(vim.api.nvim_buf_get_offset, buf, vim.api.nvim_buf_line_count(buf))
                  if not ok then
                    return false
                  end
                  return byte_size < 1024 * 1024
                end, vim.api.nvim_list_bufs())
              end,
              min_keyword_length = 2,
              max_items = 5,
            },
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "rounded",
          scrolloff = 2,
          scrollbar = true,
          direction_priority = { "s", "n" },
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          auto_show = function(ctx)
            local buftype = vim.bo[ctx.bufnr] and vim.bo[ctx.bufnr].buftype or ""
            return ctx.mode ~= "c" and not vim.tbl_contains({ "nofile", "prompt" }, buftype)
          end,
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          treesitter_highlighting = true,
          window = {
            border = "rounded",
          },
        },
        ghost_text = {
          enabled = false,
        },
        list = {
          max_items = 200,
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        max_typos = function(keyword)
          return math.floor(#keyword / 4)
        end,
        use_frecency = true,
        use_proximity = true,
        sorts = { "score", "sort_text" },
        prebuilt_binaries = {
          download = true,
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
