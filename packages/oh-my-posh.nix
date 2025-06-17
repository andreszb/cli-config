# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Oh-my-posh - Cross-platform prompt theme engine
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Provides a comprehensive prompt theme with:
#   - OS and context information
#   - Git status integration
#   - Language runtime detection (Python, Java, .NET, Rust, etc.)
#   - Battery status and time display
#   - TTY-compatible fallback for basic terminals
#
# Configuration options and more information: https://ohmyposh.dev/
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
{pkgs}: let
  # Path to the external theme file
  themeFile = ../themes/oh-my-posh/theme.json;
in {
  package = pkgs.oh-my-posh;

  # Home manager configuration for oh-my-posh
  homeManagerConfig = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };

  # File configuration for theme.json
  fileConfig = {
    ".config/oh-my-posh/theme.json".source = themeFile;
  };
}
