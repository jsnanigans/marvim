#!/bin/bash

# Test session functionality
echo "Testing Neovim session management..."

# Create test directories
TEST_DIR1="/tmp/nvim-session-test-1"
TEST_DIR2="/tmp/nvim-session-test-2"

mkdir -p "$TEST_DIR1" "$TEST_DIR2"

# Create test files
echo "Test file 1 in directory 1" > "$TEST_DIR1/file1.txt"
echo "Test file 2 in directory 1" > "$TEST_DIR1/file2.txt"
echo "Test file 1 in directory 2" > "$TEST_DIR2/file1.txt"
echo "Test file 2 in directory 2" > "$TEST_DIR2/file2.txt"

echo "Test setup complete. Two test directories created:"
echo "  - $TEST_DIR1"
echo "  - $TEST_DIR2"
echo ""
echo "To test session functionality:"
echo "1. cd $TEST_DIR1 && nvim file1.txt file2.txt"
echo "2. Make some changes, then exit Neovim (:qa)"
echo "3. cd $TEST_DIR1 && nvim (should auto-load the session)"
echo "4. Verify files are restored, then :cd $TEST_DIR2"
echo "5. Notice 'Session context changed' message"
echo "6. Exit and re-enter from $TEST_DIR2 - should not overwrite TEST_DIR1 session"
echo ""
echo "Session keybindings:"
echo "  <leader>ps - Restore session for current directory"
echo "  <leader>pl - Restore last session"
echo "  <leader>pd - Stop session recording"
echo "  <leader>pS - Save current session"
echo "  <leader>pc - Clear session for current directory"