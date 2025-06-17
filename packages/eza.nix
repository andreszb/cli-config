# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Eza - A modern replacement for ls with color support and Git integration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Common use cases:
#   eza                        # List files and directories
#   eza -l                     # Long listing format
#   eza -la                    # List all files (including hidden ones)
#   eza -T                     # Recursive tree view
#   eza --icons                # Show file icons
#   eza --git                  # Show Git status
#   eza -l --sort=size         # Sort by file size
#
# Configuration options and more information: https://github.com/eza-community/eza
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
{pkgs}: {
  package = pkgs.eza;

  homeManagerConfig = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraOptions = [
      "-1" # List one file per line
      "--icons" # Show file type icons
      "--git" # Show git status for files
      "-a" # Show hidden files
      "--group-directories-first" # Show directories before files
      "--header" # Display column headers
      "--classify" # Add file type indicators
      "--time-style=relative" # Show human-readable timestamps
    ];
  };
}
