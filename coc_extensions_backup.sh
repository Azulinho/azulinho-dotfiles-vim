#!/bin/bash

# coc.nvim Extension Backup and Restore Script

set -e

BACKUP_DIR="$HOME/.vim/coc_extensions_backup"
EXTENSIONS_DIR="$HOME/.config/coc/extensions"

case "$1" in
    "backup")
        echo "Backing up coc.nvim extensions..."
        
        if [ ! -d "$EXTENSIONS_DIR" ]; then
            echo "No extensions directory found at $EXTENSIONS_DIR"
            exit 1
        fi
        
        mkdir -p "$BACKUP_DIR"
        
        # Create timestamped backup
        timestamp=$(date +"%Y%m%d_%H%M%S")
        backup_file="$BACKUP_DIR/coc_extensions_$timestamp.tar.gz"
        
        tar -czf "$backup_file" -C "$(dirname "$EXTENSIONS_DIR")" "$(basename "$EXTENSIONS_DIR")"
        
        echo "✓ Extensions backed up to: $backup_file"
        
        # Also create a list of installed extensions
        echo "Installed extensions:" > "$BACKUP_DIR/extensions_list_$timestamp.txt"
        if command -v vim &> /dev/null; then
            vim -es -c "try | CocList extensions | call writefile(getline(1, '$'), '$BACKUP_DIR/extensions_list_$timestamp.txt') | finally | qa!" 2>/dev/null || echo "Could not get extension list" >> "$BACKUP_DIR/extensions_list_$timestamp.txt"
        fi
        ;;
        
    "restore")
        echo "Restoring coc.nvim extensions..."
        
        if [ ! -d "$BACKUP_DIR" ]; then
            echo "No backup directory found at $BACKUP_DIR"
            exit 1
        fi
        
        # Find latest backup
        latest_backup=$(ls -t "$BACKUP_DIR"/coc_extensions_*.tar.gz 2>/dev/null | head -1)
        
        if [ -z "$latest_backup" ]; then
            echo "No backup files found in $BACKUP_DIR"
            exit 1
        fi
        
        echo "Restoring from: $latest_backup"
        
        # Remove existing extensions
        if [ -d "$EXTENSIONS_DIR" ]; then
            echo "Removing existing extensions..."
            rm -rf "$EXTENSIONS_DIR"
        fi
        
        # Create extensions directory
        mkdir -p "$EXTENSIONS_DIR"
        
        # Restore from backup
        tar -xzf "$latest_backup" -C "$(dirname "$EXTENSIONS_DIR")"
        
        echo "✓ Extensions restored to: $EXTENSIONS_DIR"
        echo "Restart Vim to load the restored extensions."
        ;;
        
    "list")
        echo "Available backups:"
        ls -la "$BACKUP_DIR"/coc_extensions_*.tar.gz 2>/dev/null || echo "No backups found"
        ;;
        
    *)
        echo "Usage: $0 {backup|restore|list}"
        echo ""
        echo "Commands:"
        echo "  backup  - Backup current extensions"
        echo "  restore - Restore latest backup"
        echo "  list    - List available backups"
        echo ""
        echo "Examples:"
        echo "  $0 backup   # Backup current extensions"
        echo "  $0 restore  # Restore from latest backup"
        echo "  $0 list     # Show all backups"
        exit 1
        ;;
esac