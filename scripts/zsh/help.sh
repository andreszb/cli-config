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
    
    # Define script descriptions and examples
    declare -A script_info
    script_info[copyssh]="Generate SSH key and configure GitHub|copyssh"
    script_info[mkcd]="Create directory and cd into it|mkcd new-folder"
    
    # Print table header
    printf "%-12s %-35s %s\n" "SCRIPT" "DESCRIPTION" "EXAMPLE"
    printf "%-12s %-35s %s\n" "------" "-----------" "-------"
    
    # List all .sh files in the zsh scripts directory
    local scripts=("$SCRIPTS"/*.sh)
    if [[ -f "${scripts[1]}" ]]; then
        for script in "${scripts[@]}"; do
            if [[ -f "$script" && "$(basename "$script")" != "help.sh" ]]; then
                local script_name=$(basename "$script" .sh)
                
                # Get description and example from the associative array
                local info_string="${script_info[$script_name]:-"No description available|$script_name"}"
                local description="${info_string%|*}"
                local example="${info_string#*|}"
                
                printf "%-12s %-35s %s\n" "$script_name" "$description" "$example"
            fi
        done
    else
        echo "  No scripts found"
    fi
    
    echo ""
    echo "Usage: Run any script name as a command from anywhere in your system"
}

# Only run help if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" && $# -eq 0 ]]; then
    help
fi