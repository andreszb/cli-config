{ pkgs }:

{
  package = pkgs.zsh;
  plugins = [
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-autosuggestions
  ];
}