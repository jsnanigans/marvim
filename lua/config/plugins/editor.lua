return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    opts = {
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
      default_file_explorer = false,
    },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" }
    },
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, {
          desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference",
          buffer = buffer,
        })
      end
      map("]]i", "next")
      map("[[i", "prev")
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]i", "next", buffer)
          map("[[i", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]i", desc = "Next Reference" },
      { "[[i", desc = "Prev Reference" },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    event = "VeryLazy",
    opts = {
      picker = {
        enabled = true,
        sources = {
          grep = {
            cmd = "rg",
            args = {
              "--column",
              "--line-number", 
              "--no-heading",
              "--color=never",
              "--smart-case",
              "--with-filename",
            },
          },
          files = {
            cmd = "fd",
            args = {
              "--type=file",
              "--hidden",
              "--exclude", "node_modules",
              "--exclude", ".git",
              "--exclude", "dist",
              "--exclude", "build",
              "--exclude", ".next",
              "--exclude", "coverage",
              "--exclude", "__pycache__",
              "--exclude", ".pytest_cache",
              "--exclude", ".DS_Store",
            },
          },
        },
        layout = {
          preset = "ivy",
        },
        icons = {
          enabled = true,
        },
        ui = {
          select = true,
        },
        win = {
          input = {
            keys = {
              ["<C-c>"] = { "close", mode = { "n", "i" } },
              ["<C-j>"] = { "move_down", mode = { "i", "n" } },
              ["<C-k>"] = { "move_up", mode = { "i", "n" } },
            },
          },
          list = {
            cursorline = true,
          },
        },
      },
    },
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      ignore = "^$",
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ a = { "@block.outer", "@conditional.outer", "@loop.outer" }, i = { "@block.inner", "@conditional.inner", "@loop.inner" } }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
  },
}
