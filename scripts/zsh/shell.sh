#!/bin/bash

# Shell switcher script for different development environments
# Usage: shell <environment>
# Available environments: web, python, base

shell() {
    local env="$1"
    local current_dir="$(pwd)"
    
    # Find cli-config directory using fd
    local config_dir=$(fd -t d -H "cli-config" "$HOME" 2>/dev/null | while read dir; do
        if [[ -f "$dir/flake.nix" && -d "$dir/shells" ]]; then
            echo "$dir"
            break
        fi
    done)
    
    if [[ -z "$config_dir" ]]; then
        echo "Error: Could not find cli-config directory with flake.nix"
        return 1
    fi
    
    case "$env" in
        "web")
            echo "Switching to web development shell..."
            nix develop "$config_dir#web-shell"
            ;;
        "python")
            echo "Switching to Python development shell..."
            nix develop "$config_dir#python-shell"
            ;;
        "base")
            echo "Switching to base development shell..."
            nix develop "$config_dir#base-shell"
            ;;
        "")
            echo "Usage: shell <environment>"
            echo "Available environments:"
            echo "  web     - Web development environment"
            echo "  python  - Python development environment"
            echo "  base    - Base development environment"
            ;;
        *)
            echo "Unknown environment: $env"
            echo "Available environments: web, python, base"
            return 1
            ;;
    esac
}