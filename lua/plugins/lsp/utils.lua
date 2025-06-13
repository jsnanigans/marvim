local M = {}

-- Load and merge server configuration
-- @param server_name string The name of the LSP server
-- @return table The server configuration
function M.load_server_config(server_name)
  local ok, server_config = pcall(require, "plugins.lsp.servers." .. server_name)
  if not ok then
    return {}
  end
  return server_config
end

-- Create on_attach function with server-specific overrides
-- @param on_attach function The base on_attach function
-- @param server_config table The server configuration
-- @return function The merged on_attach function
function M.create_on_attach(on_attach, server_config)
  if not server_config.on_attach then
    return on_attach
  end
  
  return function(client, bufnr)
    -- Call base on_attach
    on_attach(client, bufnr)
    -- Call server-specific on_attach
    server_config.on_attach(client, bufnr)
  end
end

-- Merge capabilities with server-specific overrides
-- @param capabilities table The base capabilities
-- @param server_config table The server configuration
-- @return table The merged capabilities
function M.merge_capabilities(capabilities, server_config)
  if not server_config.capabilities then
    return capabilities
  end
  
  if type(server_config.capabilities) == "function" then
    return server_config.capabilities(capabilities)
  end
  
  return vim.tbl_deep_extend("force", capabilities, server_config.capabilities)
end

-- Get server configuration for lspconfig
-- @param server_name string The name of the LSP server
-- @param base_opts table Base options (on_attach, capabilities, etc.)
-- @return table The complete server configuration
function M.get_server_opts(server_name, base_opts)
  local server_config = M.load_server_config(server_name)
  
  local opts = vim.tbl_deep_extend("force", base_opts, {
    settings = server_config.settings or {},
    filetypes = server_config.filetypes,
    init_options = server_config.init_options,
    root_dir = server_config.root_dir,
  })
  
  -- Handle on_attach
  opts.on_attach = M.create_on_attach(base_opts.on_attach, server_config)
  
  -- Handle capabilities
  opts.capabilities = M.merge_capabilities(base_opts.capabilities, server_config)
  
  -- Remove nil values
  for k, v in pairs(opts) do
    if v == nil then
      opts[k] = nil
    end
  end
  
  return opts
end

-- Check if a server has a custom configuration
-- @param server_name string The name of the LSP server
-- @return boolean Whether the server has a custom configuration
function M.has_custom_config(server_name)
  local ok, _ = pcall(require, "plugins.lsp.servers." .. server_name)
  return ok
end

-- Get all available server configurations
-- @return table List of server names with custom configurations
function M.get_available_servers()
  local servers = {}
  local server_dir = vim.fn.stdpath("config") .. "/lua/plugins/lsp/servers"
  
  if vim.fn.isdirectory(server_dir) == 1 then
    local files = vim.fn.glob(server_dir .. "/*.lua", false, true)
    for _, file in ipairs(files) do
      local server_name = vim.fn.fnamemodify(file, ":t:r")
      table.insert(servers, server_name)
    end
  end
  
  return servers
end

return M