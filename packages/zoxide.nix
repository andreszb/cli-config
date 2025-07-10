{pkgs}: {
  package = pkgs.zoxide;

  homeManagerConfig = {
    enable = true;
    enableZshIntegration = true;
  };
}
