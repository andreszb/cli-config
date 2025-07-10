{
  pkgs,
  userConfig,
  nvim-config,
  packages,
}: let
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

    # Aliases are handled by zsh-abbr in permanent configuration
    # For temporary shell, we use basic aliases
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
      echo "   • Check SSH agent: ssh -add -l"
    }

    # Install permanent configuration
    install-permanent() {
      echo "🏠 Installing permanent CLI configuration..."
      echo ""

      # Check if we're in the right directory
      if [[ ! -f "flake.nix" ]]; then
        echo "❌ Error: flake.nix not found. Please run this from the cli-config directory."
        return 1
      fi

      # Check if home-manager is available
      if ! command -v home-manager >/dev/null 2>&1; then
        echo "📦 Installing home-manager..."

        # Add home-manager channel
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update

        # Install home-manager
        nix-shell '<home-manager>' -A install

        if ! command -v home-manager >/dev/null 2>&1; then
          echo "❌ Failed to install home-manager. Trying alternative method..."

          # Alternative: install via nix profile
          nix profile install nixpkgs#home-manager

          if ! command -v home-manager >/dev/null 2>&1; then
            echo "❌ Could not install home-manager. Please install manually:"
            echo "   https://nix-community.github.io/home-manager/index.html#installation"
            return 1
          fi
        fi

        echo "✅ home-manager installed"
      else
        echo "✅ home-manager already available"
      fi

      echo ""
      echo "🔧 Applying permanent configuration..."

      # Apply the configuration
      if home-manager switch --flake .; then
        echo ""
        echo "🎉 Permanent configuration installed successfully!"
        echo ""
        echo "🎯 What changed:"
        echo "   • All CLI tools are now permanently available"
        echo "   • Shell configuration applied to your default shell"
        echo "   • Configuration files installed in ~/.config/"
        echo ""
        echo "🔄 To update the configuration:"
        echo "   home-manager switch --flake ."
        echo ""
        echo "🗑️  To remove:"
        echo "   home-manager uninstall"
        echo ""
        echo "💡 You can now exit this temporary shell and enjoy your permanent setup!"
      else
        echo "❌ Failed to apply home-manager configuration"
        echo "🔍 Check the error messages above for details"
        return 1
      fi
    }

    # Uninstall permanent configuration
    uninstall-permanent() {
      echo "🗑️  Uninstalling permanent CLI configuration..."
      echo ""

      # Check if home-manager is available
      if ! command -v home-manager >/dev/null 2>&1; then
        echo "❌ home-manager not found. Configuration may not be installed."
        return 1
      fi

      # Confirm before proceeding
      echo "⚠️  This will:"
      echo "   • Remove all CLI tools installed by this configuration"
      echo "   • Restore your previous shell configuration"
      echo "   • Clean up home-manager configuration files"
      echo "   • Remove generated configuration files"
      echo ""
      echo -n "Are you sure you want to continue? (y/N): "
      read -r response

      if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Uninstall cancelled."
        return 0
      fi

      echo ""
      echo "📦 Creating backup of current configuration..."

      # Create backup directory with timestamp
      local backup_dir="$HOME/.config/cli-config-backup-$(date +%Y%m%d-%H%M%S)"
      mkdir -p "$backup_dir"

      # Backup important files that might be modified
      for file in ~/.zshrc ~/.bashrc ~/.config/git/config ~/.gitconfig; do
        if [[ -f "$file" ]]; then
          cp "$file" "$backup_dir/" 2>/dev/null && echo "✅ Backed up $file"
        fi
      done

      echo ""
      echo "🔧 Removing home-manager configuration..."

      # Get the current generation before removal
      local current_gen
      current_gen=$(home-manager generations | head -1 | awk '{print $5}' 2>/dev/null || echo "")

      # Remove the home-manager configuration
      if home-manager uninstall 2>/dev/null; then
        echo "✅ home-manager configuration removed"
      else
        echo "⚠️  home-manager uninstall not available, trying manual cleanup..."

        # Manual cleanup of home-manager files
        local hm_files=(
          ~/.config/home-manager
          ~/.local/state/home-manager
          ~/.local/share/home-manager
        )

        for file in "''${hm_files[@]}"; do
          if [[ -e "$file" ]]; then
            rm -rf "$file" && echo "✅ Removed $file"
          fi
        done
      fi

      echo ""
      echo "🧹 Cleaning up configuration files..."

      # Clean up specific configuration files created by our tools
      local config_files=(
        ~/.config/bat
        ~/.config/btop
        ~/.config/yazi
        ~/.config/oh-my-posh
        ~/.config/direnv
      )

      for file in "''${config_files[@]}"; do
        if [[ -e "$file" ]] && [[ -w "$file" ]]; then
          echo -n "Remove $file? (y/N): "
          read -r remove_response
          if [[ "$remove_response" =~ ^[Yy]$ ]]; then
            rm -rf "$file" && echo "✅ Removed $file"
          else
            echo "⏭️  Skipped $file"
          fi
        fi
      done

      echo ""
      echo "🔄 Cleaning up shell modifications..."

      # Check for home-manager shell integration and offer to remove
      for shell_file in ~/.zshrc ~/.bashrc; do
        if [[ -f "$shell_file" ]] && grep -q "home-manager" "$shell_file" 2>/dev/null; then
          echo "⚠️  Found home-manager references in $shell_file"
          echo -n "Remove home-manager lines from $shell_file? (y/N): "
          read -r remove_shell
          if [[ "$remove_shell" =~ ^[Yy]$ ]]; then
            # Create backup
            cp "$shell_file" "$shell_file.pre-uninstall-backup"
            # Remove home-manager lines
            sed -i.bak '/home-manager/d' "$shell_file" 2>/dev/null && echo "✅ Cleaned $shell_file"
          fi
        fi
      done

      echo ""
      echo "🧽 Cleaning up environment variables..."

      # Remove session variables file if it exists
      local session_vars="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      if [[ -f "$session_vars" ]]; then
        echo "⚠️  Found session variables file: $session_vars"
        echo "   This will be cleaned up when you restart your shell."
      fi

      echo ""
      echo "🎯 Uninstall Summary:"
      echo "   ✅ Configuration backed up to: $backup_dir"
      echo "   ✅ home-manager configuration removed"
      echo "   ✅ CLI-specific config files cleaned"
      echo "   ✅ Shell modifications cleaned"
      echo ""
      echo "🔄 Next steps:"
      echo "   1. Restart your shell or run: source ~/.zshrc (or ~/.bashrc)"
      echo "   2. Your system should be back to its previous state"
      echo "   3. If you experience issues, restore from: $backup_dir"
      echo ""
      echo "💡 To reinstall later:"
      echo "   cd $(pwd) && nix develop, then run: install-permanent"
      echo ""
      echo "🎉 Uninstall completed successfully!"
    }
  '';
in
  pkgs.mkShell {
    name = "cli-environment";
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
      export CONFIG_DIR="$HOME/.config/cli-shell-temp"
      mkdir -p "$CONFIG_DIR"

      export GIT_CONFIG_GLOBAL="$CONFIG_DIR/gitconfig"
      cp -f ${gitConfigFile} "$GIT_CONFIG_GLOBAL"

      export OMP_CONFIG="${../themes/oh-my-posh/theme.json}"
      export ZDOTDIR="$CONFIG_DIR"
      cp -f ${zshrc} "$CONFIG_DIR/.zshrc"

      echo "🚀 Entering temporary CLI environment..."
      echo "📦 All tools loaded! Type 'exit' to leave."
      echo "🔖 Version: $(git -C ${../.} rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
      echo ""
      echo "💡 Available commands:"
      echo "   • copyssh             - Set up SSH keys for GitHub"
      echo "   • install-permanent   - Install this configuration permanently"
      echo "   • uninstall-permanent - Remove permanent installation and restore system"
      echo ""
      echo "ℹ️  Note: This temporary shell uses basic aliases. For zsh-abbr abbreviations,"
      echo "   run 'install-permanent' to get the full permanent configuration."
      echo ""

      exec ${pkgs.zsh}/bin/zsh
    '';
  }
