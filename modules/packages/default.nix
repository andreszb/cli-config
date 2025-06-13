{ pkgs }:

with pkgs; [
  bat
  eza
  fzf
  git
  delta
  neofetch
  oh-my-posh
  openssh
  yazi
  zoxide
  zsh
  
  # Zsh plugins (for temporary shell)
  zsh-syntax-highlighting
  zsh-autosuggestions
] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
  xclip
]