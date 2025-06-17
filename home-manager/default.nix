{ config, pkgs, userConfig, shellAliases, nvim-config, ... }:

let
  packagesConfig = import ../packages { inherit pkgs userConfig shellAliases; };
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
    
    file = packagesConfig.fileConfigs // {
      ".config/scripts/zsh/copyssh.sh" = {
        text = builtins.replaceStrings ["''${userConfig.email}"] [userConfig.email] (builtins.readFile ../scripts/zsh/copyssh.sh);
        executable = true;
      };
      ".config/scripts/zsh/help.sh" = {
        source = ../scripts/zsh/help.sh;
        executable = true;
      };
      ".config/scripts/zsh/mkcd.sh" = {
        source = ../scripts/zsh/mkcd.sh;
        executable = true;
      };
    };
  };
  
  programs = {
    home-manager.enable = true;
  } // packagesConfig.homeManagerConfigs;
} // packagesConfig.topLevelConfigs