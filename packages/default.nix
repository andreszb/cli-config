{
  pkgs,
  userConfig,
  shellAliases,
}: let
  # Import oh-my-posh first to get the theme config
  oh-my-posh = import ./oh-my-posh.nix {inherit pkgs;};
  ompTheme = oh-my-posh.themeConfig;

  # Import all package configurations
  packages = {
    bat = import ./bat.nix {inherit pkgs;};
    eza = import ./eza.nix {inherit pkgs;};
    fzf = import ./fzf.nix {inherit pkgs;};
    git = import ./git.nix {inherit pkgs userConfig;};
    delta = import ./delta.nix {inherit pkgs;};
    neofetch = import ./neofetch.nix {inherit pkgs;};
    inherit oh-my-posh;
    openssh = import ./openssh.nix {inherit pkgs;};
    yazi = import ./yazi.nix {inherit pkgs;};
    zoxide = import ./zoxide.nix {inherit pkgs;};
    zsh = import ./zsh.nix {inherit pkgs userConfig shellAliases ompTheme;};
    direnv = import ./direnv.nix {inherit pkgs;};
    xclip = import ./xclip.nix {inherit pkgs;};
    alejandra = import ./alejandra.nix {inherit pkgs;};
    # Utility packages
    fd = import ./fd.nix {inherit pkgs;};
    ripgrep = import ./ripgrep.nix {inherit pkgs;};
    jq = import ./jq.nix {inherit pkgs;};
    btop = import ./btop.nix {inherit pkgs;};
    httpie = import ./httpie.nix {inherit pkgs;};
    procs = import ./procs.nix {inherit pkgs;};
    tldr = import ./tldr.nix {inherit pkgs;};
    zip = import ./zip.nix {inherit pkgs;};
    coreutils = import ./coreutils.nix {inherit pkgs;};
    claude-code = import ./claude-code.nix {inherit pkgs;};
  };

  # Extract packages from package configurations
  getPackages = packages: let
    collectPackages = packageConfig:
      if packageConfig ? package
      then
        if builtins.isList packageConfig.package
        then packageConfig.package
        else [packageConfig.package]
      else if packageConfig ? plugins
      then packageConfig.plugins
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
    oh-my-posh = packages.oh-my-posh.homeManagerConfig or {};
  };

  # Extract top-level configurations
  getTopLevelConfigs = packages: {};

  # Extract file configurations
  getFileConfigs = packages: let
    collectFileConfigs = packageConfig:
      if packageConfig ? fileConfig
      then packageConfig.fileConfig
      else {};
  in
    builtins.foldl' (acc: fileConfig: acc // fileConfig) {}
    (builtins.map collectFileConfigs (builtins.attrValues packages));
in {
  inherit packages;
  packageList = getPackages packages;
  homeManagerConfigs = getHomeManagerConfigs packages;
  topLevelConfigs = getTopLevelConfigs packages;
  fileConfigs = getFileConfigs packages;
}
