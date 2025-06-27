local M = {}

-- Import UI subcategories
local function merge_tables(...)
	local result = {}
	for _, tbl in ipairs({ ... }) do
		for _, spec in ipairs(tbl) do
			table.insert(result, spec)
		end
	end
	return result
end

return merge_tables(
	require("config.plugins.ui.theme"),
	require("config.plugins.ui.statusline"),
	require("config.plugins.ui.notifications"),
	require("config.plugins.ui.dashboard"),
	require("config.plugins.ui.indentation"),
	require("config.plugins.ui.breadcrumbs")
)