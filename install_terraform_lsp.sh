#!/bin/bash

# Install terraform-ls for coc.nvim

echo "=== Installing terraform-ls ==="
echo ""

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed"
    echo "Install Go first:"
    echo "  - Ubuntu/Debian: sudo apt install golang-go"
    echo "  - Or: https://golang.org/dl/"
    exit 1
fi

echo "✅ Go found: $(go version)"

# Install terraform-ls
echo "Installing terraform-ls..."
if go install github.com/hashicorp/terraform-ls@latest; then
    echo "✅ terraform-ls installed successfully"

    # Check if it's in PATH
    if command -v terraform-ls &> /dev/null; then
        echo "✅ terraform-ls available in PATH: $(which terraform-ls)"
    else
        echo "⚠️  terraform-ls installed but not in PATH"
        echo "   Add to PATH: export PATH=\$PATH:$(go env GOPATH)/bin"
        echo "   Or restart your shell"
    fi
else
    echo "❌ Failed to install terraform-ls"
    exit 1
fi

echo ""
echo "=== Configuration ==="
echo "terraform-ls is now configured in coc.nvim settings:"
echo "  - Language: terraform"
echo "  - Server: terraform-ls"
echo "  - Auto-start: enabled"
echo ""
echo "Restart Vim to start using terraform-ls!"
echo "Test with: terraform validate"
echo "=== Installation Complete ==="