{ pkgs }:

{
  package = pkgs.bat;
  
  homeManagerConfig = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };
}