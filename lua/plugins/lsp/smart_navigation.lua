-- Smart LSP navigation with fallbacks
local M = {}

-- Center cursor after navigation
local function center_cursor()
  vim.schedule(function()
    vim.cmd("normal! zz")
  end)
end

-- Enhanced go to with multiple fallbacks and better error handling
local function enhanced_goto(primary_method, fallback_methods, method_names)
  local params = vim.lsp.util.make_position_params()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  
  if #clients == 0 then
    vim.notify("No active LSP clients", vim.log.levels.WARN)
    return
  end

  -- Try primary method first
  local function try_method(method, method_name, fallbacks)
    vim.lsp.buf_request(0, method, params, function(err, result, ctx, config)
      if err then
        vim.notify(string.format("Error with %s: %s", method_name, err.message), vim.log.levels.ERROR)
        return
      end
      
      -- Check if we got valid results
      if result and (vim.islist(result) and #result > 0 or not vim.islist(result)) then
        -- Handle the response and center cursor
        local handler = vim.lsp.handlers[method]
        if handler then
          handler(err, result, ctx, config)
          center_cursor()
        end
      else
        -- Try next fallback method
        if fallbacks and #fallbacks > 0 then
          local next_method = table.remove(fallbacks, 1)
          local next_name = table.remove(method_names, 1)
          vim.defer_fn(function()
            try_method(next_method, next_name, fallbacks)
          end, 100)
        else
          vim.notify("No definition or implementation found", vim.log.levels.INFO)
        end
      end
    end)
  end
  
  -- Start with primary method
  try_method(primary_method, method_names[1], fallback_methods)
end

-- Smart go to definition: go to definition, if already there go to implementation
function M.smart_goto_definition()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local current_buf = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_position_params()
  
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
    if err then
      vim.notify("Error getting definition: " .. err.message, vim.log.levels.ERROR)
      return
    end
    
    if not result or vim.tbl_isempty(result) then
      -- No definition found, try implementation as fallback
      vim.notify("No definition found, trying implementation...", vim.log.levels.INFO)
      vim.defer_fn(function()
        M.goto_implementation()
      end, 100)
      return
    end
    
    -- Check if we're already at the definition location
    local target_location = result[1] or result
    local target_uri = target_location.uri or target_location.targetUri
    local target_range = target_location.range or target_location.targetRange
    
    local current_uri = vim.uri_from_bufnr(current_buf)
    local target_line = target_range.start.line
    local current_line = current_pos[1] - 1  -- Convert to 0-based
    
    if target_uri == current_uri and math.abs(target_line - current_line) <= 1 then
      -- Already at definition, go to implementation instead
      vim.notify("Already at definition, going to implementation...", vim.log.levels.INFO)
      vim.defer_fn(function()
        M.goto_implementation()
      end, 100)
    else
      -- Go to definition
      vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
      center_cursor()
    end
  end)
end

-- Smart go to implementation: go to implementation, if already there go to definition  
function M.smart_goto_implementation()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local current_buf = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_position_params()
  
  vim.lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
    if err then
      vim.notify("Error getting implementation: " .. err.message, vim.log.levels.ERROR)
      return
    end
    
    if not result or vim.tbl_isempty(result) then
      -- No implementation found, try definition as fallback
      vim.notify("No implementation found, trying definition...", vim.log.levels.INFO)
      vim.defer_fn(function()
        M.goto_definition()
      end, 100)
      return
    end
    
    -- Check if we're already at the implementation location
    local target_location = result[1] or result
    local target_uri = target_location.uri or target_location.targetUri
    local target_range = target_location.range or target_location.targetRange
    
    local current_uri = vim.uri_from_bufnr(current_buf)
    local target_line = target_range.start.line
    local current_line = current_pos[1] - 1  -- Convert to 0-based
    
    if target_uri == current_uri and math.abs(target_line - current_line) <= 1 then
      -- Already at implementation, go to definition instead
      vim.notify("Already at implementation, going to definition...", vim.log.levels.INFO)
      vim.defer_fn(function()
        M.goto_definition()
      end, 100)
    else
      -- Go to implementation
      vim.lsp.handlers["textDocument/implementation"](err, result, ctx, config)
      center_cursor()
    end
  end)
end

-- Direct go to definition (with centering)
function M.goto_definition()
  vim.lsp.buf.definition()
  center_cursor()
end

-- Direct go to implementation (with centering)
function M.goto_implementation()
  vim.lsp.buf.implementation()
  center_cursor()
end

-- Direct go to type definition (with centering)
function M.goto_type_definition()
  vim.lsp.buf.type_definition()
  center_cursor()
end

-- Direct go to declaration (with centering)
function M.goto_declaration()
  vim.lsp.buf.declaration()
  center_cursor()
end

-- Enhanced references (with better handling and filtering)
function M.goto_references()
  vim.lsp.buf.references(nil, {
    on_list = function(options)
      -- Filter out test files and node_modules
      local filtered_items = {}
      for _, item in ipairs(options.items) do
        local filename = item.filename or ""
        local should_exclude = false
        
        -- Skip node_modules
        if filename:match("node_modules/") then
          should_exclude = true
        end
        
        -- Skip test files (common patterns)
        if filename:match("%.test%.") or 
           filename:match("%.spec%.") or
           filename:match("/test/") or
           filename:match("/tests/") or
           filename:match("/__tests__/") or
           filename:match("/%.spec/") or
           filename:match("/%.test/") then
          should_exclude = true
        end
        
        if not should_exclude then
          table.insert(filtered_items, item)
        end
      end
      
      -- Update options with filtered items
      local filtered_options = vim.tbl_extend("force", options, { items = filtered_items })
      
      vim.fn.setqflist({}, ' ', filtered_options)
      if #filtered_items > 1 then
        vim.cmd("copen")
      elseif #filtered_items == 1 then
        -- If only one reference, jump directly and center
        vim.cmd("cfirst")
        center_cursor()
      else
        vim.notify("No references found (after filtering)", vim.log.levels.INFO)
      end
    end
  })
end

return M