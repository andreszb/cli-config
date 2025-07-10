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
    enableZshIntegration = false;  # Disabled - using zsh-abbr instead
  };
}
