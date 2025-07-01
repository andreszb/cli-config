{
  pkgs,
  userConfig,
}: {
  package = pkgs.texlive.combined.scheme-full;

  homeManagerConfig = {
    enable = false; # No specific home-manager configuration needed
  };
}