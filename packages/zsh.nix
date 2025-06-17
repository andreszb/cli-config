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
      # Oh-my-posh
      eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"
      
      # Source all Zsh functions
      for script in ~/.config/cli-config/scripts/zsh/*.sh; do
        [[ -r "$script" ]] && source "$script"
      done
    '';
  };

  home.file = {
    source = ./scripts;
    recursive = true;
  };

}
