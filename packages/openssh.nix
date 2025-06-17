{pkgs}: {
  package = pkgs.openssh;

  homeManagerConfig = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/control/%C";
    controlPersist = "10m";
  };

  # Create control socket directory to prevent "cannot bind to path" errors
  # when using SSH connection multiplexing (controlMaster = "auto")
  fileConfig = {
    ".ssh/control/.keep" = {
      text = "";
    };
  };
}
