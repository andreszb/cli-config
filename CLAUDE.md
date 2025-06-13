# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains a modular Nix flake that provides a comprehensive CLI development environment with two deployment modes:

1. **Temporary Shell**: Quick access via `nix develop` for temporary environments
2. **Permanent Installation**: Home-manager integration for persistent system configuration

The flake integrates a custom Neovim configuration from `github:andreszb/nvim-config` and provides a consistent development experience across multiple platforms (Linux x86_64/aarch64, macOS x86_64/aarch64).

### Modular Structure

The configuration is organized into logical modules under `modules/`:
- `modules/user/` - User configuration (name, email, username)
- `modules/packages/` - Aggregates all tool packages from individual tool configurations
- `modules/tools/` - Individual tool configurations (bat.nix, eza.nix, fzf.nix, etc.)
- `modules/shells/` - Shell configurations, aliases, and temporary shell setup
- `modules/git/` - Git configuration with aliases and Delta integration
- `modules/themes/` - Oh-my-posh theme definitions
- `modules/home-manager/` - Home-manager module configuration

## Common Commands

### Testing and Development
```bash
# Enter temporary development shell
nix develop

# Build the environment (test configuration)
nix build

# Check flake configuration
nix flake check

# Update flake inputs
nix flake update

# Show flake info
nix flake show
```

### Home Manager Installation
```bash
# Install home-manager configuration
home-manager switch --flake .

# Build configuration without switching
home-manager build --flake .
```

## Architecture

### Module System

The architecture follows a modular approach where each component is separated into its own module:

- **User Module** (`modules/user/default.nix`): Centralized user settings imported as `userConfig.userConfig`
- **Package Module** (`modules/packages/default.nix`): Platform-aware package selection with Linux-specific additions
- **Shell Modules** (`modules/shells/`): 
  - `aliases.nix`: Shell aliases shared between temporary and permanent configurations
  - `temp-shell.nix`: Temporary shell environment with isolated configurations
- **Git Module** (`modules/git/default.nix`): Git configuration function that accepts userConfig
- **Theme Module** (`modules/themes/oh-my-posh.nix`): Oh-my-posh theme definition
- **Home-Manager Module** (`modules/home-manager/default.nix`): Permanent home-manager configuration

### Key Functions

- `mkCliShell`: Creates temporary shell environments by importing `modules/shells/temp-shell.nix`
- `getGitConfig`: Function that creates git configuration with user context
- Module imports: Each module is imported and composed in the main flake

### Configuration Structure

The flake outputs provide:
- `devShells.default`: Temporary development environment using modular shell configuration
- `homeConfigurations.${username}`: Permanent home-manager setup using modular home-manager configuration
- `packages.default`: Package derivation for nix shell usage

### File Organization

```
modules/
├── user/default.nix          # User configuration
├── packages/default.nix      # Aggregates tool packages
├── tools/
│   ├── default.nix           # Tool configuration aggregator
│   ├── bat.nix              # Bat configuration
│   ├── eza.nix              # Eza configuration
│   ├── fzf.nix              # FZF configuration
│   ├── git.nix              # Git package
│   ├── delta.nix            # Delta package
│   ├── neofetch.nix         # Neofetch package
│   ├── oh-my-posh.nix       # Oh-my-posh package
│   ├── openssh.nix          # SSH configuration
│   ├── yazi.nix             # Yazi configuration
│   ├── zoxide.nix           # Zoxide configuration
│   ├── zsh.nix              # Zsh and plugins
│   ├── direnv.nix           # Direnv configuration
│   └── xclip.nix            # Linux clipboard utility
├── shells/
│   ├── aliases.nix           # Shell aliases
│   └── temp-shell.nix        # Temporary shell setup
├── git/default.nix           # Git configuration
├── themes/oh-my-posh.nix     # Oh-my-posh theme
└── home-manager/default.nix  # Home-manager module
```

### Tool Configuration System

Each tool in `modules/tools/` follows a consistent structure:
- `package`: The Nix package to install
- `homeManagerConfig`: Home-manager program configuration (optional)
- `plugins`: Additional packages like zsh plugins (optional)

The `modules/tools/default.nix` aggregates all tool configurations and provides:
- `packages`: List of all tool packages for installation
- `homeManagerConfigs`: Attribute set of home-manager program configurations

## Tool Integration

The environment includes integrated configurations for:
- **Zsh**: Enhanced with syntax highlighting, autosuggestions, and custom history settings
- **Git**: Pre-configured with user info, aliases, and Delta diff viewer
- **Oh-my-posh**: Custom theme with session, path, and git status segments
- **Development Tools**: bat, eza, fzf, yazi, zoxide with cross-tool integration