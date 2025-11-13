#!/bin/bash

# coc.nvim Offline Extension Download Script (Clone Only)
# This version only clones repositories, no dependency installation

# Don't exit on first error - continue with other extensions

EXTENSIONS_DIR="$HOME/.vim/coc_extensions_offline"
EXTENSIONS=(
    "coc-go:josa42"
    "coc-pyright:fannheyward"
    "coc-tsserver:neoclide"
    "coc-json:neoclide"
    "coc-yaml:neoclide"
    "coc-html:neoclide"
    "coc-css:neoclide"
    "coc-vimlsp:iamcco"
    "coc-texlab:fannheyward"
    "coc-eslint:fannheyward"
    "terraform-ls:hashicorp"
)

echo "Creating coc.nvim extensions offline package (Clone Only)..."
mkdir -p "$EXTENSIONS_DIR"

# Force git to use SSH
export GIT_SSH_COMMAND="ssh -oBatchMode=yes -oStrictHostKeyChecking=no"
export GIT_TERMINAL_PROMPT=0

success_count=0
total_count=${#EXTENSIONS[@]}

for ext in "${EXTENSIONS[@]}"; do
    echo "Downloading $ext..."
    cd "$EXTENSIONS_DIR"

    # Parse extension name and owner
    ext_name=$(echo "$ext" | cut -d: -f1)
    ext_owner=$(echo "$ext" | cut -d: -f2)

    # Clone extension repository
    if [ -d "$ext_name" ]; then
        echo "Removing existing $ext_name directory..."
        rm -rf "$ext_name"
    fi

    # Force SSH clone with error handling
    echo "Cloning: git@github.com:$ext_owner/$ext_name.git"
    if git clone --depth 1 "git@github.com:$ext_owner/$ext_name.git" 2>&1; then
        echo "✓ $ext_name cloned successfully"
        ((success_count++))
    else
        echo "❌ Failed to clone $ext_name"
        echo "   Repository: git@github.com:$ext_owner/$ext_name.git"
        echo "   Trying HTTPS fallback..."
        if git clone --depth 1 "https://github.com/$ext_owner/$ext_name.git" 2>&1; then
            echo "✓ $ext_name cloned via HTTPS"
            ((success_count++))
        else
            echo "❌ Failed to clone $ext_name via both SSH and HTTPS"
        fi
    fi
done

echo ""
echo "=== Summary ==="
echo "Successfully cloned: $success_count/$total_count extensions"
echo "Extensions directory: $EXTENSIONS_DIR"
echo ""
echo "Next steps:"
echo "1. Copy extensions directory to offline machine"
echo "2. Run: ~/.vim/install_coc_extensions_offline.sh"
echo "3. coc.nvim will install dependencies on first use"
echo ""
if [ $success_count -eq $total_count ]; then
    echo "🎉 All extensions cloned successfully!"
else
    echo "⚠️  Some extensions failed to clone"
    echo "   Check network connection and SSH keys"
fi