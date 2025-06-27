-- LSP capability caching utility for performance optimization
-- Reduces redundant capability calculations during server setup

local M = {}

-- Capability cache to avoid recalculation
local _cached_capabilities = nil

-- Get cached LSP capabilities or calculate once
function M.get_capabilities()
  if _cached_capabilities then
    return vim.deepcopy(_cached_capabilities)
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Try blink.cmp first (preferred)
  local has_blink, blink = pcall(require, "blink.cmp")
  if has_blink then
    local ok, blink_caps = pcall(blink.get_lsp_capabilities)
    if ok then
      capabilities = vim.tbl_deep_extend("force", capabilities, blink_caps)
    end
  end

  -- Cache the result
  _cached_capabilities = capabilities
  return vim.deepcopy(_cached_capabilities)
end

-- Reset cache (useful for testing or config changes)
function M.reset_cache()
  _cached_capabilities = nil
end

return M
