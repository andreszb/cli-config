{ pkgs }:

{
  package = with pkgs; [
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    font-manager
    font-awesome_5
    noto-fonts
  ];
  
  homeManagerConfig = {
    fontconfig.enable = true;
  };
}