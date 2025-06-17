{ pkgs, userConfig, ompTheme, shellAliases }:

{
  package = pkgs.zsh;
  plugins = [
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-autosuggestions
  ];
  
  homeManagerConfig = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    inherit shellAliases;
    
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "colored-man-pages" "command-not-found" "aliases" "fzf" ];
    };
    
    initContent = ''
      # Set scripts directory environment variable
      export SCRIPTS="$HOME/.config/scripts/zsh"
      
      # Oh-my-posh
      eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"
      
      # Source all Zsh functions
      for script in ~/.config/scripts/zsh/*.sh; do
        [[ -r "$script" ]] && source "$script"
      done
    '';
  };
  
  fileConfig = {
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

}
