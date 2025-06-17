{pkgs}: {
  package = pkgs.zoxide;

  homeManagerConfig = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };
}
