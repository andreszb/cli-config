# Reusable Home Manager module for CLI configuration
# This module can be imported by other flakes that use home-manager
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.cli-config;
in
{
  options.programs.cli-config = {
    enable = mkEnableOption "CLI configuration with modern tools";
    
    userConfig = mkOption {
      type = types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "User's full name for git configuration";
          };
          email = mkOption {
            type = types.str;
            description = "User's email for git configuration";
          };
          username = mkOption {
            type = types.str;
            description = "Username for system paths";
          };
        };
      };
      description = "User configuration for CLI tools";
    };
    
    nvim-config = mkOption {
      type = types.attrs;
      default = {};
      description = "Neovim configuration flake input (optional)";
    };
    
    shellAliases = mkOption {
      type = types.attrsOf types.str;
      default = import ./shells/aliases.nix;
      description = "Shell aliases to include";
    };
    
    excludePackages = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of package names to exclude from installation";
      example = [ "neofetch" "btop" ];
    };
  };

  config = mkIf cfg.enable (
    let
      # Import the packages configuration
      packagesConfig = import ./packages {
        inherit pkgs;
        userConfig = cfg.userConfig;
        shellAliases = cfg.shellAliases;
      };
      
      # Filter out excluded packages
      filteredPackages = builtins.filter (pkg: 
        let
          pkgName = if builtins.isString pkg then pkg else pkg.pname or pkg.name or "unknown";
        in
        !(builtins.elem pkgName cfg.excludePackages)
      ) packagesConfig.packageList;
      
      # Add neovim from flake input if provided
      finalPackages = filteredPackages ++ 
        (if cfg.nvim-config != {} then 
          [ (cfg.nvim-config.packages.${pkgs.system}.default or pkgs.neovim) ]
        else 
          [ pkgs.neovim ]
        );
        
    in {
      home.packages = finalPackages;
      
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "bat";
      };
      
      home.file = packagesConfig.fileConfigs;
      
      programs = packagesConfig.homeManagerConfigs;
    }
  );
}