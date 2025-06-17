# Example flake showing how to integrate cli-config with other home-manager configurations
{
  description = "Example integration of cli-config with GUI applications";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Import the CLI configuration
    cli-config = {
      url = "github:andreszb/cli-config";  # or path:./path/to/cli-config
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, cli-config, ... }:
    let
      system = "x86_64-linux";  # or your system
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."yourusername" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        
        modules = [
          # Import the CLI configuration module
          cli-config.homeManagerModules.default
          
          # Your main configuration
          {
            home = {
              username = "yourusername";
              homeDirectory = "/home/yourusername";
              stateVersion = "24.05";
            };
            
            # Enable CLI configuration
            programs.cli-config = {
              enable = true;
              userConfig = {
                name = "Your Name";
                email = "your.email@example.com";
                username = "yourusername";
              };
              # Optional: pass neovim config from cli-config flake
              nvim-config = cli-config.inputs.nvim-config;
              # Optional: exclude specific packages
              excludePackages = [ "neofetch" ];  # if you don't want neofetch
            };
            
            # Your GUI applications and other configurations
            programs = {
              firefox.enable = true;
              vscode.enable = true;
              # ... other GUI programs
            };
            
            # GTK/Qt theming
            gtk = {
              enable = true;
              theme = {
                name = "Adwaita-dark";
                package = pkgs.gnome.gnome-themes-extra;
              };
            };
            
            # Desktop environment specific configs
            services = {
              dunst.enable = true;  # notifications
              # ... other services
            };
            
            # Additional packages for GUI
            home.packages = with pkgs; [
              discord
              spotify
              gimp
              # ... other GUI applications
            ];
          }
        ];
      };
    };
}