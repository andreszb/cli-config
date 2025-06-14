{ config, pkgs, userConfig, ompTheme, shellAliases, nvim-config, ... }:

let
  packagesConfig = import ./packages { inherit pkgs userConfig ompTheme shellAliases; };
in
{
  home = {
    packages = packagesConfig.packageList ++ [
      (nvim-config.packages.${pkgs.system}.default or pkgs.neovim)
    ];
    
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "bat";
    };
    
    file.".config/oh-my-posh/theme.json".text = builtins.toJSON ompTheme;
  };
  
  programs = {
    home-manager.enable = true;
  } // packagesConfig.homeManagerConfigs;
}