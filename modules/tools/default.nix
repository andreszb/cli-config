{ pkgs }:

let
  # Import all tool configurations
  tools = {
    bat = import ./bat.nix { inherit pkgs; };
    eza = import ./eza.nix { inherit pkgs; };
    fzf = import ./fzf.nix { inherit pkgs; };
    git = import ./git.nix { inherit pkgs; };
    delta = import ./delta.nix { inherit pkgs; };
    neofetch = import ./neofetch.nix { inherit pkgs; };
    oh-my-posh = import ./oh-my-posh.nix { inherit pkgs; };
    openssh = import ./openssh.nix { inherit pkgs; };
    yazi = import ./yazi.nix { inherit pkgs; };
    zoxide = import ./zoxide.nix { inherit pkgs; };
    zsh = import ./zsh.nix { inherit pkgs; };
    direnv = import ./direnv.nix { inherit pkgs; };
    xclip = import ./xclip.nix { inherit pkgs; };
  };

  # Extract packages from tool configurations
  getPackages = tools: 
    let
      collectPackages = toolConfig:
        if toolConfig ? package then
          if builtins.isList toolConfig.package then toolConfig.package
          else [ toolConfig.package ]
        else if toolConfig ? plugins then toolConfig.plugins
        else [];
    in
    builtins.concatLists (builtins.map collectPackages (builtins.attrValues tools));

  # Extract home-manager configurations with proper program names
  getHomeManagerConfigs = tools: {
    bat = tools.bat.homeManagerConfig or {};
    eza = tools.eza.homeManagerConfig or {};
    fzf = tools.fzf.homeManagerConfig or {};
    ssh = tools.openssh.homeManagerConfig or {};
    yazi = tools.yazi.homeManagerConfig or {};
    zoxide = tools.zoxide.homeManagerConfig or {};
    direnv = tools.direnv.homeManagerConfig or {};
  };

in {
  inherit tools;
  packages = getPackages tools;
  homeManagerConfigs = getHomeManagerConfigs tools;
}