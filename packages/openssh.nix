{ pkgs }:

{
  package = pkgs.openssh;
  
  homeManagerConfig = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/control/%C";
    controlPersist = "10m";
  };
}