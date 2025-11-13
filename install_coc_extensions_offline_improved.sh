#!/bin/bash

# coc.nvim Offline Extension Installation Script (Improved)
# This version copies only necessary files, avoiding .git directory issues

set -e

SOURCE_DIR="$HOME/coc_extensions_offline"
TARGET_DIR="$HOME/.config/coc/extensions"

echo "Installing coc.nvim extensions from offline package..."

# Create target directory
mkdir -p "$TARGET_DIR"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Extensions directory not found: $SOURCE_DIR"
    echo "Please copy the coc_extensions_offline directory to your home directory first."
    exit 1
fi

# Function to copy extension without .git
install_extension() {
    local ext_dir="$1"
    local ext_name=$(basename "$ext_dir")
    local target_ext_dir="$TARGET_DIR/$ext_name"
    
    echo "Installing $ext_name..."
    
    # Remove existing extension
    if [ -d "$target_ext_dir" ]; then
        rm -rf "$target_ext_dir"
    fi
    
    # Create target directory
    mkdir -p "$target_ext_dir"
    
    # Copy all files except .git directory
    cd "$ext_dir"
    find . -type f ! -path "./.git/*" -exec cp --parents {} "$target_ext_dir" \;
    
    echo "✓ $ext_name installed"
}

# Install each extension
for ext_dir in "$SOURCE_DIR"/*; do
    if [ -d "$ext_dir" ]; then
        install_extension "$ext_dir"
    fi
done

echo ""
echo "All extensions installed to: $TARGET_DIR"
echo ""
echo "Restart Vim to load the extensions."
echo "You can verify installation with: :CocList extensions"
echo ""
echo "If you encounter issues, try:"
echo "  :CocCommand workspace.showOutput"
echo "  :CocCommand extensions.checkHealth"