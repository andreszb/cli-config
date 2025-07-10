{
  pkgs,
  userConfig,
  ompTheme,
}: {
  package = pkgs.zsh;
  plugins = [
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-autosuggestions
    pkgs.zsh-autocomplete
    pkgs.zsh-fzf-tab
    pkgs.zsh-nix-shell
    pkgs.zsh-you-should-use
    pkgs.zsh-abbr
  ];

  homeManagerConfig = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["sudo" "colored-man-pages" "command-not-found" "aliases" "fzf"];
      extraConfig = ''
        # Required for autocomplete with box: https://unix.stackexchange.com/a/778868
        zstyle ':completion:*' completer _expand _complete _ignored _approximate _expand_alias
        zstyle ':autocomplete:*' default-context curcontext
        zstyle ':autocomplete:*' min-input 0

        setopt HIST_FIND_NO_DUPS

        autoload -Uz compinit
        compinit

        setopt autocd  # cd without writing 'cd'
        setopt globdots # show dotfiles in autocomplete list
      '';
    };
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    zsh-abbr = {
      enable = true;
      abbreviations = import ./zsh-abbr.nix;
    };
    initContent = ''
      # Set scripts directory environment variable
      export SCRIPTS="$HOME/.config/scripts/zsh"

      # Oh-my-posh
      eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"

      # Auto-list files when changing directories
      _list_files_after_cd() {
        local file_count=$(ls -1 2>/dev/null | wc -l)
        if [ $file_count -le 20 ]; then
          eza --icons --group-directories-first -t modified 2>/dev/null
        else
          eza --icons --group-directories-first -t modified 2>/dev/null | head -20
        fi
      }

      # Hook to list files after cd (using zsh chpwd hook)
      chpwd() {
        _list_files_after_cd
      }

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

    ".config/scripts/zsh/shell.sh" = {
      source = ../scripts/zsh/shell.sh;
      executable = true;
    };
  };
}
