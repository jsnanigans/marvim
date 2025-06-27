return {
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
						or vim.fn.win_gettype(win) ~= ""
						or vim.wo[win].winbar ~= ""
						or vim.bo[buf].ft == "help"
					then
						return false
					end
					local exclude_ft = {
						"help",
						"dashboard",
						"Trouble",
						"trouble",
						"lazy",
						"mason",
						"notify",
						"toggleterm",
						"lazyterm",
						"alpha",
						"starter",
						"qf",
						"man",
						"gitcommit",
						"gitrebase",
						"",
					}
					if vim.tbl_contains(exclude_ft, vim.bo[buf].ft) then
						return false
					end
					local file_path = vim.api.nvim_buf_get_name(buf)
					if file_path ~= "" then
						local stat = vim.uv.fs_stat(file_path)
						if stat and stat.size > 512 * 1024 then
							return false
						end
					end
					return vim.bo[buf].ft == "markdown"
						or pcall(vim.treesitter.get_parser, buf)
						or not vim.tbl_isempty(vim.lsp.get_clients({
							bufnr = buf,
							method = "textDocument/documentSymbol",
						}))
				end,
				hover = true,
				sources = function(buf, _)
					local sources = require("dropbar.sources")
					local utils = require("dropbar.utils")
					local filename_only_path = {
						get_symbols = function(buf, win, cursor)
							local file_path = vim.api.nvim_buf_get_name(buf)
							if file_path == "" then
								return {}
							end
							local path_symbols = sources.path.get_symbols(buf, win, cursor)
							if not path_symbols or #path_symbols == 0 then
								return {}
							end
							return { path_symbols[#path_symbols] }
						end,
					}
					if vim.bo[buf].ft == "markdown" then
						return {
							filename_only_path,
							sources.markdown,
						}
					end
					if vim.bo[buf].buftype == "terminal" then
						return {
							sources.terminal,
						}
					end
					return {
						filename_only_path,
						utils.source.fallback({
							sources.lsp,
							sources.treesitter,
						}),
					}
				end,
				padding = { left = 1, right = 1 },
				pick = {
					pivots = "abcdefghijklmnopqrstuvwxyz",
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
					["q"] = "<C-w>q",
					["<Esc>"] = "<C-w>q",
					["<CR>"] = function()
						local menu = require("dropbar.utils").menu.get_current()
						if not menu then
							return
						end
						local cursor = vim.api.nvim_win_get_cursor(menu.win)
						local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
						if component then
							menu:click_on(component, nil, 1, "l")
						end
					end,
					["i"] = function()
						local menu = require("dropbar.utils").menu.get_current()
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
						String = "󰉾 ",
						Number = "󰎠 ",
						Boolean = "◩ ",
						Array = "󰅪 ",
						Object = "󰅩 ",
						Key = "󰌋 ",
						Null = "󰢤 ",
						EnumMember = " ",
						Struct = "󰆼 ",
						Event = " ",
						Operator = "󰆕 ",
						TypeParameter = "󰆩 ",
						Folder = "󰉋 ",
						Terminal = " ",
						Keyword = "󰌋 ",
						Snippet = "󰩫 ",
						Color = "󰏘 ",
						Unit = "󰑭 ",
						Value = "󰎠 ",
						Reference = "󰈇 ",
						IfStatement = "󰇉 ",
						ForStatement = "󰑖 ",
						WhileStatement = "󰑖 ",
						SwitchStatement = "󰺟 ",
						CaseStatement = "󱃙 ",
						BreakStatement = "󰙧 ",
						ContinueStatement = "→ ",
						Return = "󰌑 ",
						GotoStatement = "󰁔 ",
						MarkdownH1 = "󰉫 ",
						MarkdownH2 = "󰉬 ",
						MarkdownH3 = "󰉭 ",
						MarkdownH4 = "󰉮 ",
						MarkdownH5 = "󰉯 ",
						MarkdownH6 = "󰉰 ",
						Text = "󰉿 ",
						Identifier = "󰀫 ",
						Declaration = "󰙠 ",
						Statement = "󰅩 ",
						Macro = "󰁌 ",
						Delete = "󰩺 ",
						Log = "󰦪 ",
						Lsp = " ",
					},
					file_icon = function(path)
						local ok, devicons = pcall(require, "nvim-web-devicons")
						if ok then
							local icon, hl = devicons.get_icon_color(path)
							return icon or "󰈔 ", hl or "DropBarIconKindFile"
						end
						return "󰈔 ", "DropBarIconKindFile"
					end,
					dir_icon = function(path)
						local name = vim.fn.fnamemodify(path, ":t")
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
				lsp = {
					max_depth = 16,
					valid_symbols = {
						"File",
						"Module",
						"Namespace",
						"Package",
						"Class",
						"Method",
						"Property",
						"Field",
						"Constructor",
						"Enum",
						"Interface",
						"Function",
						"Variable",
						"Constant",
						"String",
						"Number",
						"Boolean",
						"Array",
						"Object",
						"Keyword",
						"Null",
						"EnumMember",
						"Struct",
						"Event",
						"Operator",
						"TypeParameter",
					},
				},
				treesitter = {
					max_depth = 16,
					valid_types = {
						"function",
						"method",
						"class",
						"struct",
						"enum",
						"interface",
						"module",
						"namespace",
						"package",
						"variable",
						"constant",
						"constructor",
						"field",
						"property",
						"array",
						"object",
					},
				},
				markdown = {
					max_depth = 6,
				},
			},
		},
		config = function(_, opts)
			local theme = require("utils.theme")
			local function setup_dropbar_highlights()
				local highlights = {
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
					DropBarIconUISeparator = { fg = theme.semantic.fg_muted, bold = true },
					DropBarIconUISeparatorMenu = { fg = theme.semantic.fg_muted },
					DropBarIconUIIndicator = { fg = theme.semantic.focus, bold = true },
					DropBarIconUIPickPivot = {
						fg = theme.semantic.bg_primary,
						bg = theme.semantic.error,
						bold = true,
					},
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
						bg = "NONE",
					},
					DropBarPreview = {
						bg = theme.semantic.selected,
						fg = theme.semantic.fg_primary,
					},
					DropBarFzfMatch = {
						fg = theme.semantic.focus,
						bold = true,
						underline = true,
					},
				}
				theme.set_highlights(highlights)
			end
			local group = vim.api.nvim_create_augroup("DropbarTheme", { clear = true })
			vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
				group = group,
				callback = function()
					if package.loaded["dropbar"] and vim.g.colors_name == "rose-pine" then
						vim.schedule(setup_dropbar_highlights)
					end
				end,
			})
			setup_dropbar_highlights()
			require("dropbar").setup(opts)
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},
}