{pkgs}: {
  # direnv is typically only configured via home-manager, not as a standalone package
  homeManagerConfig = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
