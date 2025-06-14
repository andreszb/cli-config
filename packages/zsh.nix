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
  };
}