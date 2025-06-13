{ pkgs }:

{
  package = pkgs.yazi;
  
  homeManagerConfig = {
    enable = true;
    enableZshIntegration = true;
  };
}