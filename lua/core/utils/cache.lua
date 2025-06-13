local M = {}

-- Cache storage
local cache = {}

-- Cache metadata (for TTL and other features)
local cache_meta = {}

-- Default TTL in seconds (5 minutes)
local DEFAULT_TTL = 300

-- Memoize a function with optional TTL
-- @param fn function The function to memoize
-- @param key string A unique key for this cache entry
-- @param ttl number Optional TTL in seconds
-- @return function The memoized function
function M.memoize(fn, key, ttl)
  ttl = ttl or DEFAULT_TTL
  
  return function(...)
    local args = { ... }
    local cache_key = key .. ":" .. vim.inspect(args)
    
    -- Check if cached value exists and is still valid
    if cache[cache_key] then
      local meta = cache_meta[cache_key]
      if meta and os.time() < meta.expires_at then
        return cache[cache_key]
      end
    end
    
    -- Call the function and cache the result
    local result = fn(...)
    cache[cache_key] = result
    cache_meta[cache_key] = {
      expires_at = os.time() + ttl,
      created_at = os.time(),
    }
    
    return result
  end
end

-- Get a value from cache
-- @param key string The cache key
-- @return any|nil The cached value or nil
function M.get(key)
  if cache[key] then
    local meta = cache_meta[key]
    if meta and os.time() < meta.expires_at then
      return cache[key]
    else
      -- Expired, clean up
      M.delete(key)
    end
  end
  return nil
end

-- Set a value in cache
-- @param key string The cache key
-- @param value any The value to cache
-- @param ttl number Optional TTL in seconds
function M.set(key, value, ttl)
  ttl = ttl or DEFAULT_TTL
  cache[key] = value
  cache_meta[key] = {
    expires_at = os.time() + ttl,
    created_at = os.time(),
  }
end

-- Delete a cache entry
-- @param key string The cache key
function M.delete(key)
  cache[key] = nil
  cache_meta[key] = nil
end

-- Clear all cache entries
function M.clear()
  cache = {}
  cache_meta = {}
end

-- Clear expired entries
function M.cleanup()
  local now = os.time()
  for key, meta in pairs(cache_meta) do
    if now >= meta.expires_at then
      M.delete(key)
    end
  end
end

-- Get cache statistics
-- @return table Statistics about the cache
function M.stats()
  local total = 0
  local expired = 0
  local now = os.time()
  
  for key, meta in pairs(cache_meta) do
    total = total + 1
    if now >= meta.expires_at then
      expired = expired + 1
    end
  end
  
  return {
    total_entries = total,
    expired_entries = expired,
    active_entries = total - expired,
  }
end

-- Debounced cache cleanup (runs every 5 minutes)
local cleanup_timer = nil
local function schedule_cleanup()
  if cleanup_timer then
    vim.fn.timer_stop(cleanup_timer)
  end
  cleanup_timer = vim.fn.timer_start(300000, function()
    M.cleanup()
    schedule_cleanup()
  end)
end

-- Start the cleanup timer
schedule_cleanup()

return M