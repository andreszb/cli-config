{ pkgs }:

{
  package = pkgs.eza;
  
  homeManagerConfig = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}