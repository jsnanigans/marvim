#!/bin/bash

# MARVIM Mason Fix Script
# Fixes common Mason installation issues
# Written by Marvin, who finds your dependency issues deeply depressing

echo "🔧 MARVIM Mason Fix Script"
echo "=========================="
echo "Fixing Mason because the universe is broken, as usual..."
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if NVIM_APPNAME is set, otherwise use default
NVIM_APPNAME="${NVIM_APPNAME:-nvim}"
echo "Using Neovim config: $NVIM_APPNAME"

# Set Mason directories
MASON_DIR="$HOME/.local/share/$NVIM_APPNAME/mason"
MASON_PACKAGES="$MASON_DIR/packages"
MASON_BIN="$MASON_DIR/bin"

echo ""
echo "📁 Mason directory: $MASON_DIR"

# Method 1: Clean up problematic symlinks
echo ""
echo "🎯 Method 1: Cleaning up problematic symlinks..."

if [ -d "$MASON_DIR" ]; then
    echo "Removing Mason schema symlinks..."
    rm -rf "$MASON_DIR/share/mason-schemas"
    
    # Also clean up any broken symlinks in bin directory
    if [ -d "$MASON_BIN" ]; then
        echo "Checking for broken symlinks in $MASON_BIN..."
        find "$MASON_BIN" -type l ! -exec test -e {} \; -print -delete
    fi
    
    echo "✅ Cleaned up Mason directories"
else
    echo "⚠️  Mason directory not found at $MASON_DIR"
    echo "Mason will create it on first package installation"
fi

# Method 2: Reset specific problematic packages
echo ""
echo "🎯 Method 2: Checking for problematic packages..."

PROBLEMATIC_PACKAGES=("lua-language-server" "typescript-language-server" "vtsls")

for pkg in "${PROBLEMATIC_PACKAGES[@]}"; do
    PKG_DIR="$MASON_PACKAGES/$pkg"
    if [ -d "$PKG_DIR" ]; then
        echo "Found potentially problematic package: $pkg"
        read -p "Remove and reinstall $pkg? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Removing $pkg..."
            rm -rf "$PKG_DIR"
            
            # Also remove the binary symlink
            BIN_NAME=$(echo "$pkg" | sed 's/-language-server$//' | sed 's/^typescript$/tsserver/')
            [ "$pkg" = "vtsls" ] && BIN_NAME="vtsls"
            [ "$pkg" = "lua-language-server" ] && BIN_NAME="lua-language-server"
            
            if [ -L "$MASON_BIN/$BIN_NAME" ]; then
                rm -f "$MASON_BIN/$BIN_NAME"
            fi
            
            echo "✅ Removed $pkg"
        fi
    fi
done

# Method 3: Fix TypeScript server conflicts
echo ""
echo "🎯 Method 3: Checking for TypeScript server conflicts..."

TS_SERVERS=("typescript-language-server" "vtsls")
TS_COUNT=0

for server in "${TS_SERVERS[@]}"; do
    if [ -d "$MASON_PACKAGES/$server" ]; then
        echo "Found: $server"
        ((TS_COUNT++))
    fi
done

if [ $TS_COUNT -gt 1 ]; then
    echo "⚠️  Multiple TypeScript servers detected!"
    echo "MARVIM recommends using vtsls and removing typescript-language-server"
    read -p "Remove typescript-language-server in favor of vtsls? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$MASON_PACKAGES/typescript-language-server"
        rm -f "$MASON_BIN/typescript-language-server"
        rm -f "$MASON_BIN/tsserver"
        echo "✅ Removed typescript-language-server"
    fi
fi

# Method 4: Clear Mason cache
echo ""
echo "🎯 Method 4: Clearing Mason cache..."

CACHE_DIRS=(
    "$HOME/.cache/nvim/mason"
    "$HOME/.cache/$NVIM_APPNAME/mason"
)

for cache_dir in "${CACHE_DIRS[@]}"; do
    if [ -d "$cache_dir" ]; then
        echo "Found cache at: $cache_dir"
        read -p "Clear this cache? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$cache_dir"
            echo "✅ Cleared cache"
        fi
    fi
done

# Method 5: Verify Neovim can access Mason
echo ""
echo "🎯 Method 5: Testing Mason in Neovim..."

# Create test script
cat > /tmp/test_mason.lua << 'EOF'
-- Test Mason functionality
local ok, mason = pcall(require, "mason")
if not ok then
    print("❌ Failed to load Mason: " .. tostring(mason))
    os.exit(1)
end

print("✅ Mason loaded successfully")

-- Check registry
local ok2, registry = pcall(require, "mason-registry")
if ok2 then
    print("✅ Mason registry loaded")
    local installed = registry.get_installed_package_names()
    if #installed > 0 then
        print("📦 Installed packages: " .. table.concat(installed, ", "))
    else
        print("📦 No packages currently installed")
    end
else
    print("❌ Failed to load Mason registry")
end

vim.cmd("qa")
EOF

echo "Testing Mason in Neovim..."
nvim --headless -u NONE -c "lua dofile('/tmp/test_mason.lua')" 2>&1 || {
    echo "⚠️  Mason test failed - you may need to install Mason first"
}
rm /tmp/test_mason.lua

# Final recommendations
echo ""
echo "🏁 Fix script completed!"
echo ""
echo "Recommendations:"
echo "1. Restart Neovim"
echo "2. Run :Mason to open the Mason interface"
echo "3. Run :MasonInstall vtsls (if TypeScript support needed)"
echo "4. Run :checkhealth mason for diagnostics"
echo ""
echo "If issues persist, check :MasonLog for detailed error messages"
echo ""
echo "Remember: The universe doesn't care about your package manager."