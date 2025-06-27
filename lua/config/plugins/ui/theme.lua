return {
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
			vim.schedule(function()
				local ok, theme = pcall(require, "utils.theme")
				if ok then
					theme.setup()
				end
			end)
		end,
	},
}