-- MARVIM Ultimate Winbar
-- File breadcrumbs and LSP context display
-- Because knowing where you are is apparently important

local M = {}
local config = require("core.config")

-- Winbar state
M.cache = {}
M.timer = nil

-- Initialize winbar
function M.setup()
  local winbar_config = config.get("ui.winbar", {})
  
  if not winbar_config.enabled then
    return
  end
  
  -- Set up winbar autocmds
  M._setup_autocmds()
  
  -- Set up refresh timer
  M._setup_refresh_timer()
  
  -- Initial update
  M.update()
end

-- Set up winbar autocmds
function M._setup_autocmds()
  local utils = require("core.utils")
  local group = utils.augroup("marvim_winbar")
  
  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWinEnter",
    "CursorMoved",
    "CursorMovedI",
    "LspProgress",
  }, {
    group = group,
    callback = function()
      M.update()
    end,
  })
  
  -- Clear winbar for certain filetypes
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = config.get("ui.winbar.exclude_filetypes", { "help", "neo-tree", "lazy", "mason" }),
    callback = function()
      vim.opt_local.winbar = ""
    end,
  })
end

-- Set up refresh timer
function M._setup_refresh_timer()
  if M.timer then
    vim.fn.timer_stop(M.timer)
  end
  
  M.timer = vim.fn.timer_start(2000, function()
    M._update_cache()
    M.update()
  end, { ["repeat"] = -1 })
end

-- Update winbar cache
function M._update_cache()
  -- Cache LSP symbols for current buffer
  M.cache.symbols = M._get_lsp_symbols()
  
  -- Cache file path components
  M.cache.file_path = M._get_file_path_components()
end

-- Update winbar display
function M.update()
  local winbar_config = config.get("ui.winbar", {})
  
  if not winbar_config.enabled then
    return
  end
  
  -- Skip for excluded filetypes
  local filetype = vim.bo.filetype
  local exclude_filetypes = winbar_config.exclude_filetypes or {}
  for _, excluded in ipairs(exclude_filetypes) do
    if filetype == excluded then
      vim.opt_local.winbar = ""
      return
    end
  end
  
  local components = {}
  
  -- Add file path if enabled
  if winbar_config.show_file_path then
    local file_path = M._render_file_path()
    if file_path ~= "" then
      table.insert(components, file_path)
    end
  end
  
  -- Add LSP symbols if enabled
  if winbar_config.show_symbols then
    local symbols = M._render_symbols()
    if symbols ~= "" then
      table.insert(components, symbols)
    end
  end
  
  -- Set winbar
  if #components > 0 then
    vim.opt_local.winbar = table.concat(components, " %#WinBarSeparator#|%* ")
  else
    vim.opt_local.winbar = ""
  end
end

-- Render file path component
function M._render_file_path()
  local file_name = vim.fn.expand("%:t")
  if file_name == "" then
    return ""
  end
  
  local file_path = vim.fn.expand("%:~:.:h")
  if file_path == "." then
    file_path = ""
  end
  
  -- Get file icon
  local file_icon = ""
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local extension = vim.fn.expand("%:e")
    local icon, hl = devicons.get_icon(file_name, extension, { default = true })
    if icon then
      file_icon = string.format("%%#%s#%s%%*", hl or "Normal", icon)
    end
  end
  
  -- Build breadcrumb path
  local path_parts = {}
  if file_path ~= "" then
    for part in file_path:gmatch("[^/]+") do
      table.insert(path_parts, "%#WinBarPath#" .. part .. "%*")
    end
  end
  
  -- Add file name
  local modified = vim.bo.modified and " %#WinBarModified#●%*" or ""
  table.insert(path_parts, file_icon .. " %#WinBarFile#" .. file_name .. "%*" .. modified)
  
  return table.concat(path_parts, " %#WinBarSeparator#/%* ")
end

-- Render LSP symbols component
function M._render_symbols()
  if not M.cache.symbols or #M.cache.symbols == 0 then
    return ""
  end
  
  local symbol_parts = {}
  for i, symbol in ipairs(M.cache.symbols) do
    local icon = M._get_symbol_icon(symbol.kind)
    local hl_group = M._get_symbol_highlight(symbol.kind)
    
    local symbol_text = string.format(
      "%%#%s#%s%s%%*",
      hl_group,
      icon,
      symbol.name
    )
    
    table.insert(symbol_parts, symbol_text)
    
    -- Limit depth to avoid clutter
    if i >= 3 then
      break
    end
  end
  
  return table.concat(symbol_parts, " %#WinBarSeparator#>%* ")
end

-- Get file path components
function M._get_file_path_components()
  local file_path = vim.fn.expand("%:~:.:h")
  if file_path == "." then
    return {}
  end
  
  local components = {}
  for part in file_path:gmatch("[^/]+") do
    table.insert(components, part)
  end
  
  return components
end

-- Get LSP symbols for current cursor position
function M._get_lsp_symbols()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  if #clients == 0 then
    return {}
  end
  
  local params = vim.lsp.util.make_position_params()
  local symbols = {}
  
  for _, client in pairs(clients) do
    if client.server_capabilities.documentSymbolProvider then
      local success, result = pcall(vim.lsp.buf_request_sync, 0, "textDocument/documentSymbol", params, 1000)
      if success and result and result[client.id] and result[client.id].result then
        symbols = M._extract_current_symbols(result[client.id].result, params.position)
        break
      end
    end
  end
  
  return symbols
end

-- Extract symbols that contain the current cursor position
function M._extract_current_symbols(document_symbols, position)
  local function contains_position(range, pos)
    local start_line = range.start.line
    local start_char = range.start.character
    local end_line = range["end"].line
    local end_char = range["end"].character
    
    if pos.line < start_line or pos.line > end_line then
      return false
    end
    
    if pos.line == start_line and pos.character < start_char then
      return false
    end
    
    if pos.line == end_line and pos.character > end_char then
      return false
    end
    
    return true
  end
  
  local function extract_symbols(symbols, current_symbols)
    for _, symbol in ipairs(symbols) do
      local range = symbol.range or symbol.location.range
      if contains_position(range, position) then
        table.insert(current_symbols, {
          name = symbol.name,
          kind = symbol.kind,
          range = range,
        })
        
        -- Recursively check children
        if symbol.children then
          extract_symbols(symbol.children, current_symbols)
        end
      end
    end
  end
  
  local current_symbols = {}
  extract_symbols(document_symbols, current_symbols)
  
  return current_symbols
end

-- Get symbol icon based on LSP symbol kind
function M._get_symbol_icon(kind)
  local icons = {
    [1] = "󰈙", -- File
    [2] = "", -- Module
    [3] = "", -- Namespace
    [4] = "", -- Package
    [5] = "󰠱", -- Class
    [6] = "󰆧", -- Method
    [7] = "󰜢", -- Property
    [8] = "󰇽", -- Field
    [9] = "", -- Constructor
    [10] = "", -- Enum
    [11] = "", -- Interface
    [12] = "󰊕", -- Function
    [13] = "󰂡", -- Variable
    [14] = "󰏿", -- Constant
    [15] = "", -- String
    [16] = "󰎠", -- Number
    [17] = "", -- Boolean
    [18] = "", -- Array
    [19] = "", -- Object
    [20] = "", -- Key
    [21] = "󰟢", -- Null
    [22] = "", -- EnumMember
    [23] = "", -- Struct
    [24] = "", -- Event
    [25] = "󰆕", -- Operator
    [26] = "󰅲", -- TypeParameter
  }
  
  return (icons[kind] or "") .. " "
end

-- Get symbol highlight group based on LSP symbol kind
function M._get_symbol_highlight(kind)
  local highlights = {
    [1] = "WinBarFile", -- File
    [2] = "WinBarModule", -- Module
    [3] = "WinBarNamespace", -- Namespace
    [4] = "WinBarPackage", -- Package
    [5] = "WinBarClass", -- Class
    [6] = "WinBarMethod", -- Method
    [7] = "WinBarProperty", -- Property
    [8] = "WinBarField", -- Field
    [9] = "WinBarConstructor", -- Constructor
    [10] = "WinBarEnum", -- Enum
    [11] = "WinBarInterface", -- Interface
    [12] = "WinBarFunction", -- Function
    [13] = "WinBarVariable", -- Variable
    [14] = "WinBarConstant", -- Constant
    [15] = "WinBarString", -- String
    [16] = "WinBarNumber", -- Number
    [17] = "WinBarBoolean", -- Boolean
    [18] = "WinBarArray", -- Array
    [19] = "WinBarObject", -- Object
    [20] = "WinBarKey", -- Key
    [21] = "WinBarNull", -- Null
    [22] = "WinBarEnumMember", -- EnumMember
    [23] = "WinBarStruct", -- Struct
    [24] = "WinBarEvent", -- Event
    [25] = "WinBarOperator", -- Operator
    [26] = "WinBarTypeParameter", -- TypeParameter
  }
  
  return highlights[kind] or "WinBarSymbol"
end

-- Disable winbar
function M.disable()
  if M.timer then
    vim.fn.timer_stop(M.timer)
    M.timer = nil
  end
  
  vim.opt_local.winbar = ""
end

-- Refresh winbar
function M.refresh()
  M._update_cache()
  M.update()
end

return M