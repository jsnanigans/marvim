-- UI and theming plugins
-- Status line, themes, and visual enhancements

-- Load unified theme
local theme = require('utils.theme')
theme.setup()

return {
  -- Colorschemes
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
      highlight_groups = {
        Comment = { italic = true },
        ["@keyword"] = { italic = true },
        ["@function"] = { bold = true },
        ["@variable"] = { italic = false },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  -- Alternative colorschemes
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "folke/tokyonight.nvim", lazy = true },
  { "nyoom-engineering/oxocarbon.nvim", lazy = true },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = " "
      else
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = {
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      }

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },

          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_x = {
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = { fg = "#ff9e64" },
            },
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = { fg = "#ff9e64" },
            },
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = { fg = "#ff9e64" },
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = "#ff9e64" },
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  -- Better vim.notify
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },
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
        -- Use unified Rose Pine theme colors
        background_colour = theme.semantic.bg_float,
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

  -- Better UI
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
        -- Apply unified Rose Pine theme
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
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = function()
      local logo = [[
███╗   ███╗ █████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗ ████║██╔══██╗██╔══██╗██║   ██║██║████╗ ████║
██╔████╔██║███████║██████╔╝██║   ██║██║██╔████╔██║
██║╚██╔╝██║██╔══██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚═╝ ██║██║  ██║██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            { action = "lua require('snacks').picker.files()", desc = " Find File", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
            { action = "lua require('snacks').picker.recent()", desc = " Recent Files", icon = " ", key = "r" },
            { action = "lua require('snacks').picker.grep()", desc = " Find Text", icon = " ", key = "g" },
            { action = "e $MYVIMRC", desc = " Config", icon = " ", key = "c" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },

  -- Active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Enhanced breadcrumbs with dropbar.nvim (better alternative to barbecue)
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      bar = {
        enable = function(buf, win, _)
          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ''
            or vim.wo[win].winbar ~= ''
            or vim.bo[buf].ft == 'help'
          then
            return false
          end

          -- Exclude certain filetypes
          local exclude_ft = {
            "help", "dashboard", "neo-tree", "Trouble", "trouble",
            "lazy", "mason", "notify", "toggleterm", "lazyterm",
            "alpha", "starter", "qf", "man", "gitcommit", "gitrebase",
            "",
          }
          
          if vim.tbl_contains(exclude_ft, vim.bo[buf].ft) then
            return false
          end

          -- Disable for large files (>1MB)
          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then
            return false
          end

          return vim.bo[buf].ft == 'markdown'
            or pcall(vim.treesitter.get_parser, buf)
            or not vim.tbl_isempty(vim.lsp.get_clients({
              bufnr = buf,
              method = 'textDocument/documentSymbol',
            }))
        end,
        hover = true,
        sources = function(buf, _)
          local sources = require('dropbar.sources')
          local utils = require('dropbar.utils')
          
          -- Custom path source for monorepo structure
          local custom_path = {
            get_symbols = function(buf, win, cursor)
              local path_symbols = sources.path.get_symbols(buf, win, cursor)
              if not path_symbols or #path_symbols == 0 then
                return path_symbols
              end
              
              -- Always include root directory
              local filtered = { path_symbols[1] }
              
              -- For monorepo support: look for apps/packages structure
              local found_package_or_app = false
              for i = 2, #path_symbols - 1 do
                local symbol = path_symbols[i]
                local prev_symbol = path_symbols[i - 1]
                
                -- Check if current symbol is under apps/ or packages/
                if prev_symbol and prev_symbol.name then
                  local prev_name = prev_symbol.name:lower()
                  if prev_name == "apps" or prev_name == "packages" or 
                     prev_name == "app" or prev_name == "package" then
                    table.insert(filtered, symbol)
                    found_package_or_app = true
                    break
                  end
                end
                
                -- Also check if current symbol IS apps/packages (for direct navigation)
                if symbol.name then
                  local curr_name = symbol.name:lower()
                  if curr_name == "apps" or curr_name == "packages" or
                     curr_name == "app" or curr_name == "package" then
                    -- Don't include the apps/packages directory itself, 
                    -- but check the next level for the actual app/package
                    if i + 1 <= #path_symbols - 1 then
                      table.insert(filtered, path_symbols[i + 1])
                      found_package_or_app = true
                      break
                    end
                  end
                end
              end
              
              -- Always include the current file (last symbol)
              if #path_symbols > 1 then
                table.insert(filtered, path_symbols[#path_symbols])
              end
              
              return filtered
            end
          }
          
          if vim.bo[buf].ft == 'markdown' then
            return {
              custom_path,
              sources.markdown,
            }
          end
          
          if vim.bo[buf].buftype == 'terminal' then
            return {
              sources.terminal,
            }
          end
          
          return {
            custom_path,
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
        padding = { left = 1, right = 1 },
        pick = {
          pivots = 'abcdefghijklmnopqrstuvwxyz',
        },
        truncate = true,
      },
      menu = {
        preview = true,
        hover = true,
        quick_navigation = true,
        scrollbar = {
          enable = true,
          background = true,
        },
        entry = {
          padding = { left = 1, right = 1 },
        },
        keymaps = {
          ['q'] = '<C-w>q',
          ['<Esc>'] = '<C-w>q',
          ['<CR>'] = function()
            local menu = require('dropbar.utils').menu.get_current()
            if not menu then
              return
            end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
            if component then
              menu:click_on(component, nil, 1, 'l')
            end
          end,
          ['i'] = function()
            local menu = require('dropbar.utils').menu.get_current()
            if menu then
              menu:fuzzy_find_open()
            end
          end,
        },
        win_configs = {
          border = "rounded",
          style = "minimal",
        },
      },
      fzf = {
        win_configs = {
          border = "rounded", 
        },
        prompt = "%#DropBarIconUIIndicator#  ",
      },
      icons = {
        enable = true,
        kinds = {
          symbols = {
            -- Programming constructs
            File = "󰈔 ",
            Module = "󰏗 ",
            Namespace = "󰅩 ",
            Package = "󰆦 ",
            Class = "󰠱 ",
            Method = "󰆧 ",
            Property = "󰜢 ",
            Field = "󰇽 ",
            Constructor = " ",
            Enum = " ",
            Interface = "󰜰 ",
            Function = "󰊕 ",
            Variable = "󰀫 ",
            Constant = "󰏿 ",
            
            -- Data types
            String = "󰉾 ",
            Number = "󰎠 ",
            Boolean = "◩ ",
            Array = "󰅪 ",
            Object = "󰅩 ",
            Key = "󰌋 ",
            Null = "󰢤 ",
            EnumMember = " ",
            Struct = "󰆼 ",
            
            -- Special symbols
            Event = " ",
            Operator = "󰆕 ",
            TypeParameter = "󰆩 ",
            Folder = "󰉋 ",
            Terminal = " ",
            
            -- Additional programming constructs
            Keyword = "󰌋 ",
            Snippet = "󰩫 ",
            Color = "󰏘 ",
            Unit = "󰑭 ",
            Value = "󰎠 ",
            Reference = "󰈇 ",
            
            -- Control flow
            IfStatement = "󰇉 ",
            ForStatement = "󰑖 ",
            WhileStatement = "󰑖 ",
            SwitchStatement = "󰺟 ",
            CaseStatement = "󱃙 ",
            BreakStatement = "󰙧 ",
            ContinueStatement = "→ ",
            Return = "󰌑 ",
            GotoStatement = "󰁔 ",
            
            -- Markdown headings
            MarkdownH1 = "󰉫 ",
            MarkdownH2 = "󰉬 ",
            MarkdownH3 = "󰉭 ",
            MarkdownH4 = "󰉮 ",
            MarkdownH5 = "󰉯 ",
            MarkdownH6 = "󰉰 ",
            
            -- Other useful symbols
            Text = "󰉿 ",
            Identifier = "󰀫 ",
            Declaration = "󰙠 ",
            Statement = "󰅩 ",
            Macro = "󰁌 ",
            Delete = "󰩺 ",
            Log = "󰦪 ",
            Lsp = " ",
          },
          -- File type specific icons (dynamic based on file extension)
          file_icon = function(path)
            local ok, devicons = pcall(require, "nvim-web-devicons")
            if ok then
              local icon, hl = devicons.get_icon_color(path)
              return icon or "󰈔 ", hl or "DropBarIconKindFile"
            end
            return "󰈔 ", "DropBarIconKindFile"
          end,
          -- Directory icons with improved styling
          dir_icon = function(path)
            local name = vim.fn.fnamemodify(path, ":t")
            -- Special directory icons
            local special_dirs = {
              [".git"] = " ",
              ["node_modules"] = " ",
              ["src"] = "󰉋 ",
              ["lib"] = "󰌘 ",
              ["config"] = " ",
              ["docs"] = "󰈙 ",
              ["test"] = "󰙨 ",
              ["tests"] = "󰙨 ",
              ["spec"] = "󰙨 ",
              ["assets"] = "󰉏 ",
              ["public"] = "󰉋 ",
              ["build"] = "󰉋 ",
              ["dist"] = "󰉋 ",
            }
            return special_dirs[name] or "󰉋 ", "DropBarIconKindFolder"
          end,
        },
        ui = {
          bar = {
            separator = " ",
            extends = "󰇘",
          },
          menu = {
            separator = " ",
            indicator = " ",
          },
        },
      },
      sources = {
        path = {
          relative_to = function(buf, win)
            -- Use project root if available, otherwise current working directory
            local ok_root, root_utils = pcall(require, "utils.root")
            if ok_root then
              return root_utils.find_root(buf)
            end
            
            local ok, cwd = pcall(vim.fn.getcwd, win)
            return ok and cwd or vim.fn.getcwd()
          end,
          filter = function(name, path)
            -- Filter out certain directories/files from path display
            local exclude = { ".git", "node_modules", ".DS_Store" }
            return not vim.tbl_contains(exclude, name)
          end,
          modified = function(sym)
            -- Show modified indicator for unsaved files
            return sym:merge({
              name = sym.name .. (vim.bo.modified and " ●" or ""),
              name_hl = vim.bo.modified and "DiffAdded" or sym.name_hl,
            })
          end,
        },
        lsp = {
          max_depth = 16,
          valid_symbols = {
            'File', 'Module', 'Namespace', 'Package', 'Class', 'Method',
            'Property', 'Field', 'Constructor', 'Enum', 'Interface',
            'Function', 'Variable', 'Constant', 'String', 'Number',
            'Boolean', 'Array', 'Object', 'Keyword', 'Null', 'EnumMember',
            'Struct', 'Event', 'Operator', 'TypeParameter',
          },
        },
        treesitter = {
          max_depth = 16,
          valid_types = {
            'function', 'method', 'class', 'struct', 'enum', 'interface',
            'module', 'namespace', 'package', 'variable', 'constant',
            'constructor', 'field', 'property', 'array', 'object',
          },
        },
        markdown = {
          max_depth = 6,
        },
      },
    },
    config = function(_, opts)
      -- Set up unified Rose Pine theme for dropbar
      local theme = require('utils.theme')
      
      local function setup_dropbar_highlights()
        local highlights = {
          -- Dropbar winbar styling
          DropBarCurrentContext = {
            bg = theme.semantic.focus,
            fg = theme.semantic.bg_primary,
            bold = true,
          },
          
          DropBarHover = {
            bg = theme.semantic.hover,
            fg = theme.semantic.fg_primary,
            bold = true,
          },

          -- Icon highlights by category using semantic colors
          DropBarIconKindFile = { fg = theme.semantic.info, bold = true },
          DropBarIconKindFolder = { fg = theme.semantic.warning, bold = true },
          DropBarIconKindFunction = { fg = theme.semantic.function_name, bold = true },
          DropBarIconKindMethod = { fg = theme.semantic.method, bold = true },
          DropBarIconKindClass = { fg = theme.semantic.class, bold = true },
          DropBarIconKindInterface = { fg = theme.semantic.type, bold = true },
          DropBarIconKindVariable = { fg = theme.semantic.variable },
          DropBarIconKindConstant = { fg = theme.semantic.constant, bold = true },
          DropBarIconKindString = { fg = theme.semantic.string },
          DropBarIconKindNumber = { fg = theme.semantic.number },
          DropBarIconKindBoolean = { fg = theme.semantic.boolean },
          DropBarIconKindArray = { fg = theme.semantic.type },
          DropBarIconKindObject = { fg = theme.semantic.type },
          DropBarIconKindEnum = { fg = theme.semantic.type, bold = true },
          DropBarIconKindModule = { fg = theme.semantic.class, bold = true },
          DropBarIconKindNamespace = { fg = theme.semantic.class, bold = true },

          -- Symbol kind name highlights
          DropBarKindFile = { fg = theme.semantic.fg_primary },
          DropBarKindFolder = { fg = theme.semantic.fg_primary, bold = true },
          DropBarKindFunction = { fg = theme.semantic.fg_primary, italic = true },
          DropBarKindMethod = { fg = theme.semantic.fg_primary, italic = true },
          DropBarKindClass = { fg = theme.semantic.fg_primary, bold = true },
          DropBarKindInterface = { fg = theme.semantic.fg_primary, bold = true },
          DropBarKindVariable = { fg = theme.semantic.fg_primary },
          DropBarKindConstant = { fg = theme.semantic.fg_primary, bold = true },
          DropBarKindModule = { fg = theme.semantic.fg_primary, bold = true },
          DropBarKindNamespace = { fg = theme.semantic.fg_primary, bold = true },

          -- UI elements
          DropBarIconUISeparator = { fg = theme.semantic.fg_muted, bold = true },
          DropBarIconUISeparatorMenu = { fg = theme.semantic.fg_muted },
          DropBarIconUIIndicator = { fg = theme.semantic.focus, bold = true },
          DropBarIconUIPickPivot = { 
            fg = theme.semantic.bg_primary, 
            bg = theme.semantic.error, 
            bold = true 
          },

          -- Menu styling with proper Rose Pine colors
          DropBarMenuCurrentContext = {
            bg = theme.semantic.selected,
            fg = theme.semantic.fg_primary,
            bold = true,
          },
          
          DropBarMenuHoverEntry = {
            bg = theme.semantic.hover,
            fg = theme.semantic.fg_primary,
          },
          
          DropBarMenuHoverIcon = {
            bg = theme.semantic.active,
            fg = theme.semantic.fg_primary,
            bold = true,
          },
          
          DropBarMenuHoverSymbol = {
            bg = theme.semantic.hover,
            fg = theme.semantic.fg_primary,
            bold = true,
          },

          DropBarMenuFloatBorder = {
            fg = theme.semantic.border_focus,
            bg = 'NONE',
          },

          -- Preview highlight
          DropBarPreview = {
            bg = theme.semantic.selected,
            fg = theme.semantic.fg_primary,
          },

          -- Fuzzy finder match
          DropBarFzfMatch = {
            fg = theme.semantic.focus,
            bold = true,
            underline = true,
          },
        }
        
        theme.set_highlights(highlights)
      end

      -- Apply highlights after colorscheme loads
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = setup_dropbar_highlights,
      })
      
      -- Apply highlights now
      setup_dropbar_highlights()
      
      require('dropbar').setup(opts)
      
      -- Set up keybindings
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
  },
}