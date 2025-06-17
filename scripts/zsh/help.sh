#!/bin/bash

# CLI Config Help Script
# Shows available zsh scripts in the cli-config

help() {
    echo "CLI Config - Available Zsh Scripts:"
    echo "==================================="
    
    # Get the directory where this script is located
    local script_dir="$(dirname "${BASH_SOURCE[0]}")"
    
    # List all .sh files in the zsh scripts directory
    for script in "$script_dir"/*.sh; do
        if [[ -f "$script" && "$(basename "$script")" != "help.sh" ]]; then
            local script_name=$(basename "$script" .sh)
            echo "  • $script_name"
        fi
    done
    
    echo ""
    echo "Usage: Run any script name as a command"
    echo "Example: mkcd my-new-directory"
}

# If no arguments provided, show help
if [[ $# -eq 0 ]]; then
    help
fi