{
  pkgs,
  userConfig,
  nvim-config,
  baseShell,
}: let
  # Import Node.js package configuration
  nodejsConfig = import ../packages/nodejs.nix {inherit pkgs;};
  webPackages = 
    if nodejsConfig ? package
    then
      if builtins.isList nodejsConfig.package
      then nodejsConfig.package
      else [nodejsConfig.package]
    else [];

  zshrc = pkgs.writeText "zshrc" ''
    # Load oh-my-posh
    eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config $OMP_CONFIG)"

    # History
    HISTSIZE=10000
    SAVEHIST=10000
    HISTFILE=~/.web-shell-history
    setopt EXTENDED_HISTORY HIST_IGNORE_DUPS SHARE_HISTORY

    # Completion
    autoload -Uz compinit && compinit

    # Basic aliases (Web shell includes basic CLI aliases)
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

    # Web development aliases
    alias nr='npm run'
    alias ni='npm install'
    alias nid='npm install --save-dev'
    alias nig='npm install --global'
    alias nis='npm install --save'
    alias nit='npm init'
    alias nk='npm link'
    alias nl='npm list'
    alias nls='npm list --depth=0'
    alias nt='npm test'
    alias nu='npm uninstall'
    alias nup='npm update'
    alias ncl='npm cache clean --force'

    # Yarn aliases
    alias ya='yarn add'
    alias yad='yarn add --dev'
    alias yag='yarn global add'
    alias yi='yarn install'
    alias yr='yarn run'
    alias ys='yarn start'
    alias yt='yarn test'
    alias yu='yarn upgrade'

    # pnpm aliases
    alias pi='pnpm install'
    alias pa='pnpm add'
    alias pad='pnpm add --save-dev'
    alias pr='pnpm run'
    alias pt='pnpm test'
    alias pu='pnpm update'

    # Development server aliases
    alias dev='npm run dev'
    alias start='npm start'
    alias build='npm run build'
    alias serve='npm run serve || npx serve'

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

    # Web development functions
    mkapp() {
      if [[ -z "$1" ]]; then
        echo "Usage: mkapp <app-name> [template]"
        echo "Templates: react, vue, vanilla, typescript"
        return 1
      fi
      
      local template=''${2:-react}
      
      case $template in
        react)
          npx create-react-app "$1"
          ;;
        vue)
          npx create-vue@latest "$1"
          ;;
        typescript)
          npx create-react-app "$1" --template typescript
          ;;
        vanilla)
          mkdir -p "$1" && cd "$1"
          npm init -y
          mkdir -p src public
          echo '<!DOCTYPE html><html><head><title>'$1'</title></head><body><div id="root"></div><script src="src/index.js"></script></body></html>' > public/index.html
          echo 'console.log("Hello from '$1'!");' > src/index.js
          ;;
        *)
          echo "Unknown template: $template"
          return 1
          ;;
      esac
      
      echo "🚀 '$1' created with $template template!"
    }
  '';
in
  baseShell.overrideAttrs (oldAttrs: {
    name = "web";
    buildInputs = (oldAttrs.buildInputs or []) ++ webPackages;

    shellHook = oldAttrs.shellHook + ''
      # Web development-specific setup
      export CONFIG_DIR="$HOME/.config/web-shell-temp"
      mkdir -p "$CONFIG_DIR"
      
      export ZDOTDIR="$CONFIG_DIR"
      cp -f ${zshrc} "$CONFIG_DIR/.zshrc"

      echo "🌐 Web development environment"
      echo "📦 Additional tools: Node.js, npm, yarn, pnpm, TypeScript, ESLint, Prettier"
    '';
  })