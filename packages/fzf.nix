{pkgs}: {
  package = pkgs.fzf;

  homeManagerConfig = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%" # Use 40% of screen height
      "--layout=reverse" # Reverse layout (input at top)
      "--border" # Show border around fzf
      "--ansi" # Enable ANSI color codes
      "--multi" # Enable multi-select with Tab
      "--preview-window=right:60%" # Preview window on right, 60% width
      "--preview='bat --color=always --style=numbers --line-range=:500 {}'" # Preview files with bat
      "--bind=ctrl-u:preview-page-up" # Ctrl+U for preview page up
      "--bind=ctrl-d:preview-page-down" # Ctrl+D for preview page down
      "--bind=ctrl-f:preview-page-down" # Ctrl+F for preview page down
      "--bind=ctrl-b:preview-page-up" # Ctrl+B for preview page up
      "--color=fg:#d0d0d0,bg:#121212,hl:#5f87af" # Custom color scheme
      "--color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff" # Selected item colors
      "--color=info:#afaf87,prompt:#d7005f,pointer:#af5fff" # UI element colors
      "--color=marker:#87ff00,spinner:#af5fff,header:#87afaf" # Additional UI colors
    ];
  };
}
