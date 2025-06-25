#!/usr/bin/env lua

-- MARVIM Keymap Conflict Analysis Tool
-- This script analyzes all keymap registrations and detects conflicts

local M = {}

-- Table to store all found keymaps
M.keymaps = {}
M.conflicts = {}
M.sources = {}

-- Parse a single keymap registration
function M.parse_keymap_block(content, filename, line_start)
    local keymaps = {}
    local current_mode = nil
    local in_mapping = false
    
    for i, line in ipairs(content) do
        local line_num = line_start + i - 1
        
        -- Find mode definitions
        local mode = line:match("^%s*([nivxtoc])%s*=%s*{")
        if mode then
            current_mode = mode
            keymaps[mode] = keymaps[mode] or {}
        end
        
        -- Find keymap definitions
        local key, mapping = line:match('%s*%["([^"]+)"%]%s*=%s*{%s*([^,}]+)')
        if key and current_mode then
            local desc = line:match('desc%s*=%s*"([^"]+)"')
            keymaps[current_mode][key] = {
                mapping = mapping,
                desc = desc or "No description",
                file = filename,
                line = line_num
            }
        end
    end
    
    return keymaps
end

-- Check for conflicts
function M.check_conflicts(new_keymaps, source)
    for mode, mappings in pairs(new_keymaps) do
        for key, mapping in pairs(mappings) do
            local key_id = mode .. ":" .. key
            
            if M.keymaps[key_id] then
                table.insert(M.conflicts, {
                    key = key,
                    mode = mode,
                    existing = M.keymaps[key_id],
                    new = mapping,
                    new_source = source
                })
            else
                M.keymaps[key_id] = mapping
                M.sources[key_id] = source
            end
        end
    end
end

-- Analyze a specific file
function M.analyze_file(filepath)
    local file = io.open(filepath, "r")
    if not file then
        return
    end
    
    local content = file:read("*all")
    file:close()
    
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    
    -- Find keymaps.register calls
    local in_register = false
    local register_start = nil
    local brace_count = 0
    
    for i, line in ipairs(lines) do
        if line:match("keymaps%.register%s*%(") then
            in_register = true
            register_start = i
            brace_count = 0
        end
        
        if in_register then
            local open_braces = select(2, line:gsub("{", ""))
            local close_braces = select(2, line:gsub("}", ""))
            brace_count = brace_count + open_braces - close_braces
            
            if brace_count <= 0 and line:match("%))") then
                -- End of register block
                local block_lines = {}
                for j = register_start, i do
                    table.insert(block_lines, lines[j])
                end
                
                local keymaps = M.parse_keymap_block(block_lines, filepath, register_start)
                M.check_conflicts(keymaps, filepath)
                
                in_register = false
                register_start = nil
            end
        end
    end
end

-- Main analysis function
function M.analyze_codebase()
    local files_to_analyze = {
        "lua/core/keymaps/init.lua",
        "lua/core/keymaps/lsp.lua", 
        "lua/core/keymaps/editor.lua",
        "lua/core/keymaps/picker.lua",
        "lua/core/keymaps/window.lua",
        "lua/config/keymaps.lua",
        "lua/config/project-utils.lua",
        "lua/plugins/testing.lua",
        "lua/plugins/utils.lua",
        "lua/plugins/folding.lua",
        "lua/plugins/git.lua",
        "lua/plugins/refactoring.lua",
        "lua/plugins/search-replace.lua",
        "lua/plugins/copilot.lua",
        "lua/plugins/file-explorer.lua",
        "lua/plugins/linting.lua",
        "lua/config/performance.lua"
    }
    
    for _, file in ipairs(files_to_analyze) do
        M.analyze_file(file)
    end
end

-- Generate report
function M.generate_report()
    print("=== MARVIM KEYMAP ANALYSIS REPORT ===\n")
    
    print("Total keymaps found:", #M.keymaps)
    print("Total conflicts found:", #M.conflicts)
    print()
    
    if #M.conflicts > 0 then
        print("CONFLICTS DETECTED:")
        print(string.rep("=", 50))
        
        for _, conflict in ipairs(M.conflicts) do
            print(string.format("\n🚨 CONFLICT: %s mode '%s'", conflict.mode, conflict.key))
            print(string.format("   Existing: %s (%s:%d)", 
                conflict.existing.desc, 
                conflict.existing.file, 
                conflict.existing.line))
            print(string.format("   New:      %s (%s:%d)", 
                conflict.new.desc, 
                conflict.new.file, 
                conflict.new.line))
        end
    else
        print("✅ No conflicts detected!")
    end
    
    print("\n" .. string.rep("=", 50))
    print("KEYMAP SUMMARY BY MODE:")
    
    local mode_counts = {}
    for key_id, _ in pairs(M.keymaps) do
        local mode = key_id:match("^([^:]+):")
        mode_counts[mode] = (mode_counts[mode] or 0) + 1
    end
    
    for mode, count in pairs(mode_counts) do
        print(string.format("  %s mode: %d keymaps", mode, count))
    end
end

-- Run the analysis
M.analyze_codebase()
M.generate_report()

return M