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
        # zsh-autocomplete configuration
        zstyle ':autocomplete:*' min-input 1
        zstyle ':autocomplete:*' delay 0.1
        zstyle ':autocomplete:tab:*' insert-unambiguous yes
        zstyle ':autocomplete:tab:*' widget-style menu-select
        zstyle ':autocomplete:*' default-context ""
        zstyle ':autocomplete:*' max-lines 10
        
        # fzf-tab configuration
        zstyle ':fzf-tab:complete:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath 2>/dev/null'
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath 2>/dev/null'
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath 2>/dev/null'
        zstyle ':fzf-tab:complete:zi:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath 2>/dev/null'
        zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border
        zstyle ':fzf-tab:*' switch-group ',' '.'
        
        # zoxide integration with zsh-autocomplete
        zstyle ':autocomplete:*' ignored-input 'z ##'
        zstyle ':autocomplete:*' ignored-input 'zi ##'
        
        # Enable zoxide completions with fzf-tab
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath 2>/dev/null'

        setopt HIST_FIND_NO_DUPS
        setopt autocd  # cd without writing 'cd'
        setopt globdots # show dotfiles in autocomplete list
      '';
    };
    syntaxHighlighting.enable = true;
    autosuggestion = {
      enable = true;
      strategy = ["history" "completion"];
      highlight = "fg=8";
    };
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