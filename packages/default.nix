{ pkgs, userConfig, ompTheme, shellAliases }:

let
  # Import all package configurations
  packages = {
    bat = import ./bat.nix { inherit pkgs; };
    eza = import ./eza.nix { inherit pkgs; };
    fzf = import ./fzf.nix { inherit pkgs; };
    git = import ./git.nix { inherit pkgs userConfig; };
    delta = import ./delta.nix { inherit pkgs; };
    neofetch = import ./neofetch.nix { inherit pkgs; };
    oh-my-posh = import ./oh-my-posh.nix { inherit pkgs; };
    openssh = import ./openssh.nix { inherit pkgs; };
    yazi = import ./yazi.nix { inherit pkgs; };
    zoxide = import ./zoxide.nix { inherit pkgs; };
    zsh = import ./zsh.nix { inherit pkgs userConfig ompTheme shellAliases; };
    direnv = import ./direnv.nix { inherit pkgs; };
    xclip = import ./xclip.nix { inherit pkgs; };
  };

  # Extract packages from package configurations
  getPackages = packages: 
    let
      collectPackages = packageConfig:
        if packageConfig ? package then
          if builtins.isList packageConfig.package then packageConfig.package
          else [ packageConfig.package ]
        else if packageConfig ? plugins then packageConfig.plugins
        else [];
    in
    builtins.concatLists (builtins.map collectPackages (builtins.attrValues packages));

  # Extract home-manager configurations with proper program names
  getHomeManagerConfigs = packages: {
    bat = packages.bat.homeManagerConfig or {};
    eza = packages.eza.homeManagerConfig or {};
    fzf = packages.fzf.homeManagerConfig or {};
    git = packages.git.homeManagerConfig or {};
    ssh = packages.openssh.homeManagerConfig or {};
    yazi = packages.yazi.homeManagerConfig or {};
    zoxide = packages.zoxide.homeManagerConfig or {};
    zsh = packages.zsh.homeManagerConfig or {};
    direnv = packages.direnv.homeManagerConfig or {};
  };

in {
  inherit packages;
  packageList = getPackages packages;
  homeManagerConfigs = getHomeManagerConfigs packages;
}