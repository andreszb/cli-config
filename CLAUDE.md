# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains a modular Nix flake that provides a comprehensive CLI development environment with two deployment modes:

1. **Temporary Shell**: Quick access via `nix develop` for temporary environments
2. **Permanent Installation**: Home-manager integration for persistent system configuration

The flake integrates a custom Neovim configuration from `github:andreszb/nvim-config` and provides a consistent development experience across multiple platforms (Linux x86_64/aarch64, macOS x86_64/aarch64).

### Git Submodules and GitHub Integration

This repository includes a git submodule for nvim-config for reference and quick local development:
- `nvim-config/`: Neovim configuration submodule

**Important**: While a git submodule is present for local development and reference, the flake configuration uses the GitHub repository (`github:andreszb/nvim-config`) as input rather than the local path. This ensures reproducibility and proper dependency management in the Nix ecosystem. The submodule serves as:
- Quick reference for configuration structure
- Local development environment for testing changes
- Easy access to update and modify configurations before pushing to GitHub

When making changes to the nvim-config:
1. Make changes in the submodule directory
2. Commit and push changes to the nvim-config GitHub repository
3. Run `nix flake update` to update the lock file with the latest commits

### Modular Structure

The configuration uses a flattened modular structure with logical separation:
- `user/` - User configuration (name, email, username)
- `packages/` - Individual tool configurations and package aggregation
- `shells/` - Shell configurations, aliases, and temporary shell setup
- `home-manager/` - Home-manager module configuration

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

- **User Module** (`user/default.nix`): Centralized user settings imported as `userConfig.userConfig`
- **Package Module** (`packages/default.nix`): Aggregates all individual tool configurations with intelligent extraction
- **Shell Modules** (`shells/`): 
  - `aliases.nix`: Shell aliases shared between temporary and permanent configurations
  - `temp-shell.nix`: Temporary shell environment with isolated configurations
- **Home-Manager Module** (`home-manager/default.nix`): Permanent home-manager configuration

### Key Functions

- `mkCliShell`: Creates temporary shell environments by importing `shells/temp-shell.nix`
- `getPackages`: Extracts packages from tool configurations (handles both single packages and lists)
- `getHomeManagerConfigs`: Aggregates home-manager program configurations from all tools
- `getFileConfigs`: Collects file configurations from tools (e.g., theme files, config files)

### Configuration Structure

The flake outputs provide:
- `devShells.default`: Temporary development environment using modular shell configuration
- `homeConfigurations.${username}`: Permanent home-manager setup using modular home-manager configuration
- `packages.default`: Package derivation for nix shell usage

### File Organization

```
├── user/default.nix              # User configuration
├── packages/
│   ├── default.nix               # Package aggregation and extraction logic
│   ├── bat.nix                   # Bat syntax highlighter
│   ├── btop.nix                  # System monitor
│   ├── coreutils.nix             # Core utilities
│   ├── delta.nix                 # Git diff viewer
│   ├── direnv.nix                # Directory-based environments
│   ├── eza.nix                   # Modern ls replacement
│   ├── fd.nix                    # Find alternative
│   ├── fonts.nix                 # Font packages (excluding font-manager)
│   ├── fzf.nix                   # Fuzzy finder
│   ├── git.nix                   # Git with Delta integration
│   ├── httpie.nix                # HTTP client
│   ├── jq.nix                    # JSON processor
│   ├── neofetch.nix              # System information
│   ├── oh-my-posh.nix            # Prompt theme engine with custom theme
│   ├── openssh.nix               # SSH configuration
│   ├── procs.nix                 # Process viewer
│   ├── ripgrep.nix               # Grep alternative
│   ├── tldr.nix                  # Simplified man pages
│   ├── xclip.nix                 # Linux clipboard utility
│   ├── yazi.nix                  # Terminal file manager
│   ├── zip.nix                   # Archive utilities (zip/unzip)
│   ├── zoxide.nix                # Smart cd replacement
│   └── zsh.nix                   # Zsh with plugins and custom functions
├── shells/
│   ├── aliases.nix               # Shell aliases
│   └── temp-shell.nix            # Temporary shell setup
└── home-manager/default.nix      # Home-manager integration
```

### Tool Configuration System

Each tool in `packages/` follows a consistent structure:
- `package`: The Nix package(s) to install (can be single package or list)
- `homeManagerConfig`: Home-manager program configuration (optional)
- `fileConfig`: File configurations (e.g., theme files, config files) (optional)
- `plugins`: Additional packages like zsh plugins (optional)

The `packages/default.nix` aggregates all tool configurations and provides:
- `packageList`: Flattened list of all packages for installation
- `homeManagerConfigs`: Attribute set of home-manager program configurations
- `fileConfigs`: Merged file configurations from all tools

## Tool Integration

The environment includes integrated configurations for:

### Core Development Tools
- **Zsh**: Enhanced with syntax highlighting, autosuggestions, custom history settings, and `copyssh()` function for GitHub SSH setup
- **Git**: Pre-configured with user info, aliases, and Delta diff viewer integration
- **Oh-my-posh**: Custom comprehensive theme with session info, path display, git status, language runtimes (Python, Java, .NET, Rust), battery status, and TTY fallback

### File and System Management
- **bat**: Syntax-highlighted file viewer with git integration
- **eza**: Modern ls replacement with git status and tree view
- **fzf**: Fuzzy finder with fd integration and custom color schemes
- **yazi**: Terminal file manager
- **zoxide**: Smart cd replacement with frecency algorithm

### Utility Tools
- **fd**: Fast find alternative
- **ripgrep**: Fast grep alternative
- **jq**: JSON processor
- **btop**: System monitor
- **httpie**: User-friendly HTTP client
- **procs**: Modern process viewer
- **tldr**: Simplified man pages
- **Archive utilities**: zip/unzip support

### System Integration
- **direnv**: Directory-based environment variables
- **openssh**: SSH configuration
- **fonts**: Comprehensive font setup (Fira Code, Nerd Fonts, Font Awesome, Noto Fonts)
- **xclip**: Linux clipboard utility

### Design Principles

1. **Self-contained modules**: Each tool configuration is completely self-contained in its own file
2. **Intelligent aggregation**: The package system automatically extracts and aggregates packages, home-manager configs, and file configurations
3. **Platform awareness**: Linux-specific tools (like xclip) are included appropriately
4. **Consistent structure**: All tools follow the same configuration pattern for maintainability
5. **Migration from hm_config**: Complete migration of CLI-specific configurations with enhancements

## Known Limitations

### Package Compatibility
- **font-manager**: Excluded from fonts configuration due to webkit dependency conflicts (webkitgtk-2.48.3 marked as broken)

### Platform-specific Notes
- **xclip**: Linux-only clipboard utility, automatically handled by platform detection
- **coreutils**: Included for Linux compatibility, may be redundant on macOS

## Workflow Guidance

### Development Process
- Always add new files to Git before performing Nix commands to ensure flake evaluation includes all changes
- Test configuration changes with `nix build` before committing
- Use `nix develop` for temporary shell testing

### Adding New Tools
1. Create individual tool configuration file in `packages/`
2. Follow the standard pattern: `package`, `homeManagerConfig`, `fileConfig` (as needed)
3. Add import to `packages/default.nix`
4. Test with `nix build`
5. Commit changes

### Migration Notes
- This configuration represents a complete migration from hm_config with CLI-specific tools
- All utility packages have been successfully migrated and enhanced
- Font configuration migrated with compatibility adjustments