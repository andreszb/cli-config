#!/bin/bash

# CLI Config Help Script
# Shows available zsh scripts in the cli-config

help() {
    echo "CLI Config - Available Zsh Scripts:"
    echo "==================================="
    
    # Use the SCRIPTS environment variable
    if [[ -z "$SCRIPTS" ]]; then
        echo "Error: SCRIPTS environment variable not set"
        return 1
    fi
    
    # List all .sh files in the zsh scripts directory
    # Use array to handle case where no .sh files exist
    local scripts=("$SCRIPTS"/*.sh)
    if [[ -f "${scripts[1]}" ]]; then
        for script in "${scripts[@]}"; do
            if [[ -f "$script" && "$(basename "$script")" != "help.sh" ]]; then
                local script_name=$(basename "$script" .sh)
                echo "  • $script_name"
            fi
        done
    else
        echo "  No scripts found"
    fi
    
    echo ""
    echo "Usage: Run any script name as a command"
    echo "Example: mkcd my-new-directory"
}

# Only run help if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" && $# -eq 0 ]]; then
    help
fi