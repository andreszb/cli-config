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

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvim-config,
    ...
  }: let
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

    # Function to create base shell environment (no language-specific tools)
    mkBaseShell = system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      packagesConfig = import ./packages {
        inherit pkgs;
        userConfig = userConfig.userConfig;
      };
    in
      import ./shells/base-shell.nix {
        inherit pkgs nvim-config;
        packages = packagesConfig.packageList;
        userConfig = userConfig.userConfig;
      };

    # Function to create temporary shell environment (full environment)
    mkCliShell = system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      packagesConfig = import ./packages {
        inherit pkgs;
        userConfig = userConfig.userConfig;
      };
    in
      import ./shells/temp-shell.nix {
        inherit pkgs nvim-config;
        packages = packagesConfig.packageList;
        userConfig = userConfig.userConfig;
      };

    # Function to create Python shell environment (inherits from base)
    mkPythonShell = system: let
      baseShell = mkBaseShell system;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
      import ./shells/python-shell.nix {
        inherit pkgs nvim-config baseShell;
        userConfig = userConfig.userConfig;
      };

    # Function to create web development shell environment (inherits from base)
    mkWebShell = system: let
      baseShell = mkBaseShell system;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
      import ./shells/web-shell.nix {
        inherit pkgs nvim-config baseShell;
        userConfig = userConfig.userConfig;
      };
  in {
    # For temporary shell: nix develop
    devShells = forAllSystems (system: {
      default = mkCliShell system;
      python = mkPythonShell system;
      web = mkWebShell system;
      base = mkBaseShell system;
    });

    # For permanent installation: home-manager
    homeConfigurations = {
      # Default configuration
      ${userConfig.userConfig.username} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = builtins.currentSystem or "x86_64-linux";
          config.allowUnfree = true;
        };

        extraSpecialArgs = {
          userConfig = userConfig.userConfig;
          inherit nvim-config;
        };

        modules = [
          (import ./home-manager/default.nix)
          {
            home = {
              username = userConfig.userConfig.username;
              homeDirectory =
                if (import nixpkgs {
                  system = builtins.currentSystem or "x86_64-linux";
                  config.allowUnfree = true;
                }).stdenv.isDarwin
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
