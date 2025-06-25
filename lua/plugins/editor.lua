-- Editor enhancement plugins
-- File navigation, search, and editing improvements

return {
  -- File explorer (Oil from bvim)
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
      -- Handle directory arguments properly
      default_file_explorer = true,
    },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
    config = function(_, opts)
      require("oil").setup(opts)
      
      -- Auto-open Oil when nvim is opened on a directory
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local args = vim.fn.argv()
          if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
            vim.cmd("Oil " .. args[1])
          end
        end,
      })
    end,
  },

  -- Snacks Picker (modern telescope replacement)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
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
      -- Keybindings now handled in config/keybindings.lua
    end,
  },

  -- Harpoon (from bvim) - keybindings in config/keybindings.lua
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Flash (better f/t motions) - keybindings in config/keybindings.lua
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto pairs
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

  -- Comments - keybindings in config/keybindings.lua
  {
    "numToStr/Comment.nvim",
    opts = {
      ignore = "^$",
    },
  },

  -- Better text objects
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

  -- Surround - keybindings in config/keybindings.lua
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

  -- Buffer remove - keybindings in config/keybindings.lua
  {
    "echasnovski/mini.bufremove",
  },
}