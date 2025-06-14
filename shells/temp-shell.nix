{ pkgs, userConfig, ompTheme, shellAliases, nvim-config, packages }:

let
  # Create config files for temporary shell
  gitConfigFile = pkgs.writeText "gitconfig" ''
    [user]
        name = ${userConfig.name}
        email = ${userConfig.email}
        signingkey = ~/.ssh/id_ed25519.pub
    
    [init]
        defaultBranch = main
    
    [pull]
        rebase = true
    
    [push]
        autoSetupRemote = true
    
    [core]
        editor = nvim
    
    [merge]
        tool = nvim
    
    [diff]
        colorMoved = default
    
    [gpg]
        format = ssh
    
    [gpg "ssh"]
        allowedSignersFile = ~/.ssh/allowed_signers
    
    [commit]
        gpgsign = true
    
    [tag]
        gpgsign = true
    
    [alias]
        co = checkout
        ci = commit
        st = status
        br = branch
        lg = log --oneline --graph --decorate
        undo = reset --soft HEAD^
  '';
  
  zshrc = pkgs.writeText "zshrc" ''
    # Load oh-my-posh
    eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config $OMP_CONFIG)"
    
    # History
    HISTSIZE=10000
    SAVEHIST=10000
    HISTFILE=~/.cli-shell-history
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
    
    # Additional functions
    mkcd() {
      mkdir -p "$1" && cd "$1"
    }
    
    # SSH Setup with GitHub
    copyssh() {
      local email="${userConfig.email}"
      local ssh_key_path="$HOME/.ssh/id_ed25519"
      local pub_key_path="$ssh_key_path.pub"
      
      echo "🔐 Setting up SSH key for GitHub..."
      echo "📧 Using email: $email"
      echo ""
      
      # Step 1: Generate SSH key if it doesn't exist
      if [[ ! -f "$ssh_key_path" ]]; then
        echo "1️⃣  Generating SSH key..."
        ssh-keygen -t ed25519 -C "$email" -f "$ssh_key_path"
        echo "✅ SSH key generated"
      else
        echo "1️⃣  SSH key already exists at $ssh_key_path"
      fi
      
      # Step 2: Start SSH agent
      echo "2️⃣  Starting SSH agent..."
      eval "$(ssh-agent -s)"
      
      # Step 3: Add key to agent
      echo "3️⃣  Adding key to SSH agent..."
      ssh-add "$ssh_key_path"
      echo "📋 Keys in agent:"
      ssh-add -l
      echo ""
      
      # Step 4: Copy public key to clipboard
      echo "4️⃣  Copying public key to clipboard..."
      if command -v pbcopy >/dev/null 2>&1; then
        cat "$pub_key_path" | pbcopy
        echo "✅ Public key copied to clipboard (macOS)"
      elif command -v xclip >/dev/null 2>&1; then
        cat "$pub_key_path" | xclip -selection clipboard
        echo "✅ Public key copied to clipboard (Linux)"
      else
        echo "📄 Public key content:"
        cat "$pub_key_path"
      fi
      echo ""
      
      # Step 5: Create allowed_signers file for commit verification
      echo "5️⃣  Setting up commit signing..."
      echo "$email $(cat $pub_key_path)" > ~/.ssh/allowed_signers
      git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
      echo "✅ Commit signing configured"
      echo ""
      
      # Instructions
      echo "🎯 Next steps:"
      echo "   1. Visit: https://github.com/settings/keys"
      echo "   2. Click 'New SSH key'"
      echo "   3. Paste the key from clipboard"
      echo "   4. Set key type to 'Authentication Key' and optionally 'Signing Key'"
      echo "   5. Test connection: ssh -T git@github.com"
      echo ""
      echo "🔍 Troubleshooting:"
      echo "   • View public key: cat $pub_key_path"
      echo "   • Test GitHub connection: ssh -T git@github.com"
      echo "   • Check SSH agent: ssh-add -l"
    }
  '';
  
in pkgs.mkShell {
  name = "cli-environment";
  packages = packages ++ [
    (nvim-config.packages.${pkgs.system}.default or pkgs.neovim)
  ];
  
  shellHook = ''
    export EDITOR=nvim
    export VISUAL=nvim
    export PAGER="${pkgs.bat}/bin/bat"
    
    # Set up temporary configs
    export CONFIG_DIR="$HOME/.config/cli-shell-temp"
    mkdir -p "$CONFIG_DIR"
    
    export GIT_CONFIG_GLOBAL="$CONFIG_DIR/gitconfig"
    cp -f ${gitConfigFile} "$GIT_CONFIG_GLOBAL"
    
    export OMP_CONFIG="${pkgs.writeText "omp.json" (builtins.toJSON ompTheme)}"
    export ZDOTDIR="$CONFIG_DIR"
    cp -f ${zshrc} "$CONFIG_DIR/.zshrc"
    
    echo "🚀 Entering temporary CLI environment..."
    echo "📦 All tools loaded! Type 'exit' to leave."
    echo ""
    
    exec ${pkgs.zsh}/bin/zsh
  '';
}