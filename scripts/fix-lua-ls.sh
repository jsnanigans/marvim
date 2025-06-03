#!/bin/bash

# MARVIM lua_ls Installation Fix Script
# Attempts multiple methods to install lua_ls for Neovim

echo "🔧 MARVIM lua_ls Installation Fix"
echo "=================================="

# Check if we're on macOS, Linux, etc.
OS="$(uname -s)"
echo "Detected OS: $OS"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
echo ""
echo "📋 Checking dependencies..."

if command_exists nvim; then
    echo "✅ Neovim found: $(nvim --version | head -n1)"
else
    echo "❌ Neovim not found. Please install Neovim >= 0.10.0"
    exit 1
fi

if command_exists git; then
    echo "✅ Git found"
else
    echo "❌ Git not found. Please install git"
    exit 1
fi

# Method 1: Try system package manager
echo ""
echo "🎯 Method 1: System package manager installation"

case "$OS" in
    "Darwin")
        if command_exists brew; then
            echo "Installing lua-language-server via Homebrew..."
            brew install lua-language-server
            if [ $? -eq 0 ]; then
                echo "✅ lua-language-server installed via Homebrew"
                echo "Restart Neovim and lua_ls should work"
                exit 0
            fi
        else
            echo "Homebrew not found. Install Homebrew first: https://brew.sh"
        fi
        ;;
    "Linux")
        # Detect Linux distribution
        if [ -f /etc/debian_version ]; then
            echo "Detected Debian/Ubuntu"
            echo "Installing build dependencies..."
            sudo apt update
            sudo apt install -y ninja-build cmake build-essential
        elif [ -f /etc/arch-release ]; then
            echo "Detected Arch Linux"
            echo "Installing build dependencies..."
            sudo pacman -S --noconfirm ninja cmake gcc
        elif [ -f /etc/fedora-release ]; then
            echo "Detected Fedora"
            echo "Installing build dependencies..."
            sudo dnf install -y ninja-build cmake gcc-c++
        fi
        ;;
esac

# Method 2: Try manual Mason installation
echo ""
echo "🎯 Method 2: Manual Mason installation"
echo "This will open Neovim and attempt to install lua_ls manually..."
read -p "Press Enter to continue or Ctrl+C to abort"

# Create temporary Lua script for Mason installation
cat > /tmp/install_lua_ls.lua << 'EOF'
-- Attempt to install lua_ls via Mason
local mason_registry = require("mason-registry")

if not mason_registry.is_installed("lua_ls") then
    print("Installing lua_ls via Mason...")
    local pkg = mason_registry.get_package("lua_ls")
    pkg:install():once("closed", function()
        if mason_registry.is_installed("lua_ls") then
            print("✅ lua_ls installed successfully!")
        else
            print("❌ lua_ls installation failed")
        end
        vim.cmd("qa")
    end)
else
    print("✅ lua_ls already installed")
    vim.cmd("qa")
end
EOF

nvim -l /tmp/install_lua_ls.lua
rm /tmp/install_lua_ls.lua

# Method 3: Manual build
echo ""
echo "🎯 Method 3: Manual build (if other methods failed)"
read -p "Do you want to try building lua-language-server manually? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Building lua-language-server manually..."
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Clone and build
    git clone https://github.com/LuaLS/lua-language-server
    cd lua-language-server
    
    # Build
    if ./make.sh; then
        echo "✅ Built successfully!"
        echo "📁 Built in: $TEMP_DIR/lua-language-server"
        echo ""
        echo "To use this build:"
        echo "1. Copy to a permanent location: cp -r $TEMP_DIR/lua-language-server ~/.local/share/"
        echo "2. Add to PATH: export PATH=\"\$HOME/.local/share/lua-language-server/bin:\$PATH\""
        echo "3. Restart Neovim"
    else
        echo "❌ Build failed"
    fi
    
    cd ~
    echo "Temporary files in: $TEMP_DIR"
fi

# Method 4: Alternative configuration
echo ""
echo "🎯 Method 4: Alternative configuration"
echo "If lua_ls still doesn't work, you can:"
echo "1. Comment out lua_ls from ensure_installed in lua/plugins/lsp.lua"
echo "2. Use built-in Lua LSP or alternative"
echo ""
echo "Would you like me to create an alternative configuration?"
read -p "(y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    cat > /tmp/lsp_alternative.lua << 'EOF'
-- Alternative LSP configuration without lua_ls
-- Replace the ensure_installed section in lua/plugins/lsp.lua with:

mason_lspconfig.setup({
  ensure_installed = {
    "vtsls",  -- Using vtsls instead of ts_ls to avoid duplicates
    "html",
    "cssls", 
    "tailwindcss",
    -- "lua_ls",  -- Commented out due to installation issues
    "graphql",
    "emmet_ls",
    "prismals", 
    "pyright",
    "eslint",
  },
  automatic_installation = false,
})
EOF
    
    echo "Alternative configuration saved to /tmp/lsp_alternative.lua"
    echo "Copy the content to your lua/plugins/lsp.lua if needed"
fi

echo ""
echo "🏁 Fix script completed!"
echo "Try opening a .lua file in Neovim and run :LspInfo to check if lua_ls is working"
echo "If issues persist, check :checkhealth mason and :MasonLog for more details"