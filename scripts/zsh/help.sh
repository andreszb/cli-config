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
    
    # Get terminal width, default to 80 if not available
    local term_width=${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}
    
    # Calculate column widths dynamically
    local min_script_width=8
    local min_desc_width=15
    local min_example_width=10
    local padding=6  # 2 spaces between each column
    
    # Available width for content (excluding padding)
    local available_width=$((term_width - padding))
    
    # Calculate optimal column widths (proportional allocation)
    local script_width=$((available_width * 20 / 100))  # 20% for script
    local desc_width=$((available_width * 55 / 100))    # 55% for description
    local example_width=$((available_width * 25 / 100)) # 25% for example
    
    # Ensure minimum widths
    script_width=$((script_width < min_script_width ? min_script_width : script_width))
    desc_width=$((desc_width < min_desc_width ? min_desc_width : desc_width))
    example_width=$((example_width < min_example_width ? min_example_width : example_width))
    
    # Adjust if total width exceeds terminal width
    local total_width=$((script_width + desc_width + example_width + padding))
    if [[ $total_width -gt $term_width ]]; then
        # Reduce description width first, then example width
        local excess=$((total_width - term_width))
        if [[ $excess -le $((desc_width - min_desc_width)) ]]; then
            desc_width=$((desc_width - excess))
        else
            desc_width=$min_desc_width
            example_width=$((example_width - (excess - (desc_width - min_desc_width))))
            example_width=$((example_width < min_example_width ? min_example_width : example_width))
        fi
    fi
    
    # Create format strings
    local header_format="%-${script_width}s  %-${desc_width}s  %-${example_width}s\n"
    local row_format="%-${script_width}s  %-${desc_width}.${desc_width}s  %-${example_width}.${example_width}s\n"
    
    # Print table header
    printf "$header_format" "SCRIPT" "DESCRIPTION" "EXAMPLE"
    printf "$header_format" "$(printf '%*s' $script_width | tr ' ' '-')" "$(printf '%*s' $desc_width | tr ' ' '-')" "$(printf '%*s' $example_width | tr ' ' '-')"
    
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
                
                printf "$row_format" "$script_name" "$description" "$example"
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