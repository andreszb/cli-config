{
  pkgs,
  userConfig,
  nvim-config,
  baseShell,
}: let
  # Import Python package configuration
  pythonConfig = import ../packages/python.nix {inherit pkgs;};
  pythonPackages = 
    if pythonConfig ? package
    then
      if builtins.isList pythonConfig.package
      then pythonConfig.package
      else [pythonConfig.package]
    else [];

  zshrc = pkgs.writeText "zshrc" ''
    # Load oh-my-posh
    eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config $OMP_CONFIG)"

    # History
    HISTSIZE=10000
    SAVEHIST=10000
    HISTFILE=~/.python-shell-history
    setopt EXTENDED_HISTORY HIST_IGNORE_DUPS SHARE_HISTORY

    # Completion
    autoload -Uz compinit && compinit

    # Basic aliases (Python shell includes basic CLI aliases)
    alias ls='eza --icons'
    alias ll='eza -la --icons --git'
    alias la='eza -a --icons'
    alias lt='eza --tree --icons'
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
    alias cat='bat'
    alias grep='rg'
    alias find='fd'

    # Python-specific aliases
    alias py='python'
    alias pip='python -m pip'
    alias venv='python -m venv'
    alias activate='source venv/bin/activate'
    alias pytest='python -m pytest'
    alias black='python -m black'
    alias flake8='python -m flake8'
    alias mypy='python -m mypy'

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

    # Python development functions
    mkproject() {
      if [[ -z "$1" ]]; then
        echo "Usage: mkproject <project-name>"
        return 1
      fi
      
      mkdir -p "$1" && cd "$1"
      python -m venv venv
      source venv/bin/activate
      
      # Create basic project structure
      touch requirements.txt
      touch README.md
      mkdir -p src tests
      
      echo "🐍 Python project '$1' created and virtual environment activated!"
      echo "📦 Install packages with: pip install <package>"
      echo "💾 Save dependencies with: pip freeze > requirements.txt"
    }
  '';
in
  baseShell.overrideAttrs (oldAttrs: {
    name = "python";
    buildInputs = (oldAttrs.buildInputs or []) ++ pythonPackages;

    shellHook = oldAttrs.shellHook + ''
      # Python-specific setup
      export CONFIG_DIR="$HOME/.config/python-shell-temp"
      mkdir -p "$CONFIG_DIR"
      
      export ZDOTDIR="$CONFIG_DIR"
      cp -f ${zshrc} "$CONFIG_DIR/.zshrc"

      echo "🐍 Python development environment"
      echo "📦 Additional tools: Python, pip, pytest, black, ruff, mypy"
    '';
  })