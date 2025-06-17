{
  description = "CLI tools with both temporary shell and permanent home-manager options";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nvim-config = {
      url = "github:andreszb/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nvim-config, ... }:
    let
      # Supported systems
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      
      # Helper function for all systems
      forAllSystems = nixpkgs.lib.genAttrs systems;
      
      # Import configurations
      userConfig = import ./user;
      shellAliases = import ./shells/aliases.nix;
      
      # Function to create temporary shell environment
      mkCliShell = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packagesConfig = import ./packages { inherit pkgs shellAliases; userConfig = userConfig.userConfig; };
        in
        import ./shells/temp-shell.nix {
          inherit pkgs shellAliases nvim-config;
          packages = packagesConfig.packageList;
          ompTheme = packagesConfig.packages.oh-my-posh.themeConfig;
          userConfig = userConfig.userConfig;
        };
      
    in {
      # For temporary shell: nix develop
      devShells = forAllSystems (system: {
        default = mkCliShell system;
      });
      
      # For permanent installation: home-manager
      homeConfigurations = {
        # Default configuration
        ${userConfig.userConfig.username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${builtins.currentSystem or "x86_64-linux"};
          
          modules = [
            (import ./home-manager {
              userConfig = userConfig.userConfig;
              inherit shellAliases nvim-config;
            })
            {
              home = {
                username = userConfig.userConfig.username;
                homeDirectory = 
                  if nixpkgs.legacyPackages.${builtins.currentSystem or "x86_64-linux"}.stdenv.isDarwin 
                  then "/Users/${userConfig.userConfig.username}"
                  else "/home/${userConfig.userConfig.username}";
                stateVersion = "24.05";
              };
            }
          ];
        };
      };
      
      # Convenience output for nix shell
      packages = forAllSystems (system: {
        default = self.devShells.${system}.default.inputDerivation;
      });
      
      # Home Manager module for use in other flakes
      homeManagerModules = {
        default = import ./module.nix;
        cli-config = import ./module.nix;
      };
      
      # Legacy alias for compatibility
      homeManagerModule = import ./module.nix;
    };
}