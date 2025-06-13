{ config, pkgs, userConfig, gitConfig, ompTheme, shellAliases, nvim-config, ... }:

{
  home = {
    packages = (import ../packages { inherit pkgs; }) ++ [
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
    
    git = {
      enable = true;
    } // gitConfig;
    
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      history = {
        size = 100000;
        save = 100000;
        share = true;
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
      };
      
      inherit shellAliases;
      
      initExtra = ''
        # Oh-my-posh
        eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"
        
        # Additional functions
        mkcd() {
          mkdir -p "$1" && cd "$1"
        }
      '';
    };
    
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        pager = "less -FR";
      };
    };
    
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
      ];
    };
    
    ssh = {
      enable = true;
      compression = true;
      controlMaster = "auto";
      controlPath = "~/.ssh/control/%C";
      controlPersist = "10m";
    };
    
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}