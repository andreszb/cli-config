{
  config,
  pkgs,
  userConfig,
  shellAliases,
  nvim-config,
  ...
}: let
  packagesConfig = import ../packages {inherit pkgs userConfig shellAliases;};
in
  {
    home = {
      packages =
        packagesConfig.packageList
        ++ [
          (nvim-config.packages.${pkgs.system}.default or pkgs.neovim)
        ];

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "bat";
      };
    };

    programs =
      {
        home-manager.enable = true;
      }
      // packagesConfig.homeManagerConfigs;
  }
  // packagesConfig.topLevelConfigs
