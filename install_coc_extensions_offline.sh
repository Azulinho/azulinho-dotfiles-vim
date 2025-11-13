#!/bin/bash

# coc.nvim Offline Extension Installation Script
# Run this on the offline machine to install extensions

set -e

SOURCE_DIR="$HOME/coc_extensions_offline"  # Change this to where you copied extensions
TARGET_DIR="$HOME/.config/coc/extensions"

echo "Installing coc.nvim extensions from offline package..."

# Create target directory
mkdir -p "$TARGET_DIR"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Extensions directory not found: $SOURCE_DIR"
    echo "Please copy the coc_extensions_offline directory to your home directory first."
    exit 1
fi

# Install each extension
for ext_dir in "$SOURCE_DIR"/*; do
    if [ -d "$ext_dir" ]; then
        ext_name=$(basename "$ext_dir")
        target_ext_dir="$TARGET_DIR/$ext_name"
        
        echo "Installing $ext_name..."
        
        # Copy extension to target directory
        cp -r "$ext_dir" "$target_ext_dir"
        
        # Create package.json if it doesn't exist (some extensions need this)
        if [ ! -f "$target_ext_dir/package.json" ] && [ -f "$target_ext_dir/package.json" ]; then
            cp "$target_ext_dir/package.json" "$target_ext_dir/"
        fi
        
        echo "✓ $ext_name installed"
    fi
done

echo ""
echo "All extensions installed to: $TARGET_DIR"
echo ""
echo "Restart Vim to load the extensions."
echo "You can verify installation with: :CocList extensions"