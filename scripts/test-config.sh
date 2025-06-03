#!/bin/bash

# Test Neovim configuration for errors
echo "Testing MARVIM configuration..."

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    echo "ERROR: Neovim not found"
    exit 1
fi

# Test loading without errors
echo -e "\nChecking for startup errors..."
nvim --headless -c 'if v:errmsg != "" | cquit | else | quit | endif' 2>&1

if [ $? -eq 0 ]; then
    echo "✓ No startup errors detected"
else
    echo "✗ Startup errors found"
fi

# Check for checkhealth issues
echo -e "\nRunning health check..."
nvim --headless -c 'checkhealth' -c 'quit' 2>&1 | grep -E "(ERROR|WARNING)" | head -20

# Test loading time
echo -e "\nMeasuring startup time..."
hyperfine --warmup 3 'nvim --headless +quit' 2>/dev/null || nvim --startuptime /tmp/nvim-startup.log --headless +quit && echo "Startup log saved to /tmp/nvim-startup.log"

echo -e "\nConfiguration test complete!"