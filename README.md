# CLI Configuration

A comprehensive, modular Nix flake that provides a modern CLI development environment with consistent tooling across platforms.

## Overview

This configuration offers two deployment modes:
- **Temporary Shell**: Quick access via `nix develop` for testing or temporary use
- **Permanent Installation**: Home-manager integration for persistent system-wide configuration

### Features

- 🚀 **Modern CLI Tools**: bat, eza, fzf, ripgrep, fd, btop, and more
- 🎨 **Custom Oh-my-posh Theme**: Comprehensive prompt with git integration, language detection, and TTY fallback
- 🔧 **Enhanced Zsh**: Syntax highlighting, autosuggestions, and custom functions
- 📝 **Git Integration**: Pre-configured with Delta diff viewer and useful aliases
- 🖥️ **Cross-platform**: Supports Linux (x86_64/aarch64) and macOS (x86_64/aarch64)
- 🧩 **Modular Design**: Each tool is self-contained and easily configurable

## Quick Start

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled

### Temporary Shell (Try it out)

```bash
# Clone the repository
git clone https://github.com/andreszb/cli-config.git
cd cli-config

# Enter the development shell
nix develop
```

This gives you immediate access to all configured tools in an isolated environment.

### Permanent Installation

#### 1. Configure User Settings

Edit `user/default.nix` with your information:

```nix
{
  userConfig = {
    name = "Your Name";
    email = "your.email@example.com";
    username = "yourusername";
  };
}
```

#### 2. Install Permanently

```bash
# Clone the repository
git clone https://github.com/andreszb/cli-config.git
cd cli-config

# Enter temporary shell
nix develop

# Install permanently (automatically installs home-manager if needed)
install-permanent
```

This method automatically installs home-manager if it's not already available, then applies the permanent configuration.

#### Alternative: Manual Installation

If you already have home-manager installed:

```bash
# Install with Home Manager
home-manager switch --flake .
```

## Usage

### Available Tools

#### Core Development
- **zsh**: Enhanced shell with plugins and custom functions
- **git**: Version control with Delta diff viewer
- **neovim**: Text editor (custom configuration from separate flake)
- **oh-my-posh**: Beautiful, informative prompt theme

#### File Management
- **bat**: Syntax-highlighted file viewer (`cat` replacement)
- **eza**: Modern directory listing (`ls` replacement)
- **fzf**: Fuzzy file finder
- **yazi**: Terminal file manager
- **zoxide**: Smart directory navigation (`cd` replacement)

#### System Utilities
- **fd**: Fast file finder (`find` replacement)
- **ripgrep**: Fast text search (`grep` replacement)
- **btop**: System monitor (`top` replacement)
- **procs**: Process viewer (`ps` replacement)
- **httpie**: User-friendly HTTP client
- **jq**: JSON processor
- **tldr**: Simplified man pages

#### Development Utilities
- **direnv**: Directory-based environment variables
- **delta**: Git diff viewer
- **zip/unzip**: Archive utilities

### Custom Features

#### Built-in Commands
The shell environment includes helpful commands:

```bash
copyssh           # Set up SSH keys for GitHub (copies to clipboard)
install-permanent # Install configuration permanently (from temporary shell)
```

#### Shell Aliases
Common aliases are pre-configured:
- `ll` → `eza -la`
- `tree` → `eza --tree`
- `cat` → `bat`
- And many more...

### Configuration Structure

```
├── user/                    # User-specific settings
├── packages/               # Individual tool configurations
│   ├── bat.nix            # File viewer
│   ├── git.nix            # Git with Delta
│   ├── oh-my-posh.nix     # Prompt theme
│   ├── zsh.nix            # Shell configuration
│   └── ...                # All other tools
├── shells/                # Shell environments
└── home-manager/          # Home-manager integration
```

## Development

### Testing Changes

```bash
# Test configuration
nix build

# Check flake validity
nix flake check

# Enter development shell
nix develop
```

### Adding New Tools

1. Create a new file in `packages/` (e.g., `packages/newtool.nix`)
2. Follow the standard pattern:
   ```nix
   { pkgs }:
   {
     package = pkgs.newtool;
     homeManagerConfig = {
       # Home manager configuration
     };
     fileConfig = {
       # File configurations if needed
     };
   }
   ```
3. Add import to `packages/default.nix`
4. Test with `nix build`

### Project Commands

```bash
# Update flake inputs
nix flake update

# Show flake information
nix flake show

# Build without installing
home-manager build --flake .
```

## Customization

### Modifying the Oh-my-posh Theme

Edit `packages/oh-my-posh.nix` to customize the prompt theme. The theme includes:
- OS and session information
- Current path with git status
- Language runtime detection (Python, Java, .NET, Rust, etc.)
- Battery status and time
- TTY-compatible fallback for basic terminals

### Adding Shell Aliases

Modify `shells/aliases.nix` to add custom aliases:

```nix
{
  myalias = "my-command";
  ll = "eza -la --git";
}
```

### Git Configuration

Git settings are in `packages/git.nix` and automatically use your user configuration from `user/default.nix`.

## Platform Support

- **Linux**: Full support with all tools including xclip for clipboard integration
- **macOS**: Full support with platform-appropriate alternatives
- **Architecture**: Both x86_64 and aarch64 supported on Linux and macOS

## Troubleshooting

### Common Issues

1. **Flake not found**: Ensure you're in the correct directory and have committed changes to git
2. **Home Manager conflicts**: Remove existing conflicting configurations
3. **Font issues**: The font-manager package is excluded due to webkit dependencies

### Getting Help

- Check flake configuration: `nix flake check`
- Verbose build output: `nix build --show-trace`
- Home Manager logs: `home-manager switch --flake . --show-trace`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes following the existing patterns
4. Test thoroughly with `nix build`
5. Submit a pull request

## License

This configuration is provided as-is for personal and educational use. Individual tools have their own licenses.