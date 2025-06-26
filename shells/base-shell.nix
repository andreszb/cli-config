{
  pkgs,
  userConfig,
  shellAliases,
  nvim-config,
  packages,
}: let

  zshrc = pkgs.writeText "zshrc" ''
    # Load oh-my-posh
    eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config $OMP_CONFIG)"

    # History
    HISTSIZE=10000
    SAVEHIST=10000
    HISTFILE=~/.base-shell-history
    setopt EXTENDED_HISTORY HIST_IGNORE_DUPS SHARE_HISTORY

    # Completion
    autoload -Uz compinit && compinit

    # Aliases
    ${builtins.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (k: v: "alias ${k}='${v}'") shellAliases)}

    # FZF
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    source ${pkgs.fzf}/share/fzf/completion.zsh

    # Zoxide
    eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"

    # Syntax highlighting and autosuggestions
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  '';
in
  pkgs.mkShell {
    name = "base";
    packages =
      packages
      ++ [
        (nvim-config.packages.${pkgs.system}.default or pkgs.neovim)
      ];

    shellHook = ''
      export EDITOR=nvim
      export VISUAL=nvim
      export PAGER="${pkgs.bat}/bin/bat"

      # Set up temporary configs
      export CONFIG_DIR="$HOME/.config/base-shell-temp"
      mkdir -p "$CONFIG_DIR"

      export OMP_CONFIG="${../themes/oh-my-posh/theme.json}"
      export ZDOTDIR="$CONFIG_DIR"
      cp -f ${zshrc} "$CONFIG_DIR/.zshrc"

      echo "⚡ Base development environment"
      echo "📦 Tools: Git, Neovim, system utilities (no Python/Node.js)"
      echo ""

      exec ${pkgs.zsh}/bin/zsh
    '';
  }