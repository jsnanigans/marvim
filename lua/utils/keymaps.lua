local M = {}

-- ============================================================================
-- SHARED UTILITIES FOR KEYMAP MANAGEMENT
-- ============================================================================

-- Registry to track registered keymaps for conflict detection
local keymap_registry = {}
local error_log = {}

-- Check if a module is available without throwing errors
function M.is_available(module)
  local ok, mod = pcall(require, module)
  return ok and mod ~= nil, mod
end

-- Check if a plugin is loaded
function M.plugin_loaded(plugin_name)
  return package.loaded[plugin_name] ~= nil
end

-- Enhanced keymap setting with conflict detection and error handling
function M.safe_keymap_set(mode, lhs, rhs, opts, source)
  opts = opts or {}
  source = source or "unknown"

  -- Create unique key for registry
  local key_id = table.concat(type(mode) == "table" and mode or { mode }, ",") .. ":" .. lhs

  -- Check for conflicts
  if keymap_registry[key_id] then
    local conflict_msg = string.format(
      "Keymap conflict detected: %s already registered by %s, now being overridden by %s",
      key_id,
      keymap_registry[key_id],
      source
    )
    table.insert(error_log, { type = "conflict", message = conflict_msg, key = key_id })
    vim.notify(conflict_msg, vim.log.levels.WARN)
  end

  -- Attempt to set keymap with error handling
  local success, err = pcall(vim.keymap.set, mode, lhs, rhs, opts)
  if not success then
    local error_msg = string.format("Failed to set keymap %s (%s): %s", key_id, source, err)
    table.insert(error_log, { type = "error", message = error_msg, key = key_id, source = source })
    vim.notify(error_msg, vim.log.levels.ERROR)
    return false
  end

  -- Register successful keymap
  keymap_registry[key_id] = source
  return true
end

-- Bulk keymap registration with validation
function M.register_keymap_table(keys, source)
  if not keys or type(keys) ~= "table" then
    local error_msg = string.format("Invalid keymap table provided by %s", source or "unknown")
    table.insert(error_log, { type = "error", message = error_msg, source = source })
    vim.notify(error_msg, vim.log.levels.ERROR)
    return false
  end

  local success_count = 0
  local total_count = #keys

  for i, keymap in ipairs(keys) do
    if type(keymap) ~= "table" or not keymap[1] or not keymap[2] then
      local error_msg = string.format("Invalid keymap entry %d in %s: missing key or action", i, source or "unknown")
      table.insert(error_log, { type = "error", message = error_msg, source = source })
      vim.notify(error_msg, vim.log.levels.WARN)
    else
      local mode = keymap.mode or "n"
      local lhs = keymap[1]
      local rhs = keymap[2]
      local opts = vim.tbl_deep_extend("force", {}, keymap)
      opts[1] = nil
      opts[2] = nil
      opts.mode = nil

      if M.safe_keymap_set(mode, lhs, rhs, opts, source) then
        success_count = success_count + 1
      end
    end
  end

  if success_count < total_count then
    vim.notify(
      string.format("Keymap registration for %s: %d/%d successful", source, success_count, total_count),
      vim.log.levels.WARN
    )
  end

  return success_count == total_count
end

-- Enhanced module loading with better error reporting
function M.safe_require(module, context)
  local ok, result = pcall(require, module)
  if not ok then
    local error_msg =
      string.format("Failed to load module '%s' in context '%s': %s", module, context or "unknown", result)
    table.insert(error_log, { type = "module_error", message = error_msg, module = module, context = context })
    vim.notify(error_msg, vim.log.levels.ERROR)
    return nil
  end
  return result
end

-- Deferred keymap setup with proper error handling
function M.setup_deferred(setup_fn, delay, context)
  delay = delay or 100
  context = context or "unknown"

  vim.defer_fn(function()
    local success, err = pcall(setup_fn)
    if not success then
      local error_msg = string.format("Deferred setup failed for %s: %s", context, err)
      table.insert(error_log, { type = "deferred_error", message = error_msg, context = context })
      vim.notify(error_msg, vim.log.levels.ERROR)
    end
  end, delay)
end

-- Keymap diagnostics and reporting
function M.get_keymap_diagnostics()
  return {
    registered_count = vim.tbl_count(keymap_registry),
    error_count = #error_log,
    registry = keymap_registry,
    errors = error_log,
  }
end

-- Print keymap diagnostics
function M.print_diagnostics()
  local diag = M.get_keymap_diagnostics()

  print("=== Keymap Diagnostics ===")
  print(string.format("Registered keymaps: %d", diag.registered_count))
  print(string.format("Errors encountered: %d", diag.error_count))

  if diag.error_count > 0 then
    print("\n--- Errors ---")
    for i, error in ipairs(diag.errors) do
      print(string.format("%d. [%s] %s", i, error.type, error.message))
    end
  end

  -- Show conflicts
  local conflicts = {}
  for key, source in pairs(diag.registry) do
    for _, error in ipairs(diag.errors) do
      if error.type == "conflict" and error.key == key then
        table.insert(conflicts, { key = key, source = source, error = error })
      end
    end
  end

  if #conflicts > 0 then
    print("\n--- Active Conflicts ---")
    for i, conflict in ipairs(conflicts) do
      print(string.format("%d. %s (current: %s)", i, conflict.key, conflict.source))
    end
  end
end

-- Clear diagnostics (useful for testing)
function M.clear_diagnostics()
  keymap_registry = {}
  error_log = {}
end

-- Validate that required dependencies are available
function M.validate_dependencies(deps, context)
  context = context or "unknown"
  local missing = {}

  for _, dep in ipairs(deps) do
    local available = M.is_available(dep)
    if not available then
      table.insert(missing, dep)
    end
  end

  if #missing > 0 then
    local error_msg = string.format("Missing dependencies for %s: %s", context, table.concat(missing, ", "))
    table.insert(error_log, {
      type = "dependency_error",
      message = error_msg,
      context = context,
      missing = missing,
    })
    vim.notify(error_msg, vim.log.levels.WARN)
    return false, missing
  end

  return true, {}
end

-- Helper to create a safe keymap function bound to a specific source
function M.create_safe_mapper(source)
  return function(mode, lhs, rhs, opts)
    return M.safe_keymap_set(mode, lhs, rhs, opts, source)
  end
end

return M
