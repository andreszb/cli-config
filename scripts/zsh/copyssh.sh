#!/usr/bin/env zsh

copyssh() {
  # Handle --help option
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "copyssh - Generate SSH key and configure GitHub authentication"
    echo ""
    echo "DESCRIPTION:"
    echo "  Automates the complete SSH key setup process for GitHub, including:"
    echo "  • Generates Ed25519 SSH key if it doesn't exist"
    echo "  • Starts SSH agent and adds the key"
    echo "  • Copies public key to clipboard"
    echo "  • Configures commit signing with SSH"
    echo "  • Provides step-by-step GitHub setup instructions"
    echo ""
    echo "USAGE:"
    echo "  copyssh           # Run the SSH setup process"
    echo "  copyssh --help    # Show this help message"
    echo ""
    echo "REQUIREMENTS:"
    echo "  • ssh-keygen (for key generation)"
    echo "  • ssh-agent (for key management)"
    echo "  • pbcopy (macOS) or xclip (Linux) for clipboard access"
    echo "  • git (for commit signing configuration)"
    echo ""
    echo "FILES CREATED:"
    echo "  ~/.ssh/id_ed25519         # Private SSH key"
    echo "  ~/.ssh/id_ed25519.pub     # Public SSH key"
    echo "  ~/.ssh/allowed_signers    # Git commit signing configuration"
    echo ""
    echo "NEXT STEPS:"
    echo "  After running copyssh, visit https://github.com/settings/keys"
    echo "  to add your SSH key to GitHub."
    return 0
  fi

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