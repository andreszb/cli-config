{
  description = "CLI tools with both temporary shell and permanent home-manager options";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:andreszb/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvim-config,
    ...
  }: let
    # Supported systems
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Helper function for all systems
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # User configuration
    userConfig = {
      name = "Andres Zambrano";
      email = "andreszb@me.com";
      username = "andreszambrano"; # Your actual username
    };

    # Shared list of packages
    getPackages = pkgs:
      with pkgs;
        [
          bat
          eza
          fzf
          git
          delta
          neofetch
          oh-my-posh
          openssh
          yazi
          zoxide
          zsh

          # Zsh plugins (for temporary shell)
          zsh-syntax-highlighting
          zsh-autosuggestions
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
          xclip
        ];

    # Shared Git configuration
    gitConfig = {
      userName = userConfig.name;
      userEmail = userConfig.email;

      aliases = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
        lg = "log --oneline --graph --decorate";
        undo = "reset --soft HEAD^";
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        core.editor = "nvim";
        merge.tool = "nvim";
        diff.colorMoved = "default";
      };

      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
          line-numbers = true;
        };
      };
    };

    # Shared shell aliases
    shellAliases = {
      # Directory listing
      ll = "eza -la --icons --git";
      la = "eza -a --icons";
      lt = "eza --tree --icons";
      llt = "eza -la --tree --icons --git";

      # Git shortcuts
      g = "git";
      gs = "git status";
      gp = "git push";
      gl = "git pull";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";

      # Safety nets
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -iv";

      # Quick edits
      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      # Other
      cat = "bat";
      grep = "grep --color=auto";
    };

    # Oh-my-posh theme configuration
    ompTheme = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      version = 2;
      final_space = true;
      console_title_template = "{{ .Shell }} in {{ .Folder }}";
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              type = "session";
              style = "diamond";
              foreground = "#ffffff";
              background = "#61AFEF";
              leading_diamond = "";
              trailing_diamond = "";
              template = " {{ if .SSHSession }} {{ end }}{{ .UserName }}@{{ .HostName }} ";
            }
            {
              type = "path";
              style = "powerline";
              powerline_symbol = "";
              foreground = "#ffffff";
              background = "#C678DD";
              template = "  {{ .Path }} ";
              properties = {
                style = "full";
                home_icon = "~";
              };
            }
            {
              type = "git";
              style = "powerline";
              powerline_symbol = "";
              foreground = "#193549";
              background = "#95E072";
              template = " {{ .HEAD }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }} ";
              properties = {
                fetch_status = true;
                fetch_upstream_icon = true;
              };
            }
          ];
        }
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              type = "text";
              style = "plain";
              foreground = "#21C7C7";
              template = "❯ ";
            }
          ];
        }
      ];
    };

    # Function to create temporary shell environment
    mkCliShell = system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # Create config files for temporary shell
      gitConfigFile = pkgs.writeText "gitconfig" ''
        [user]
            name = ${userConfig.name}
            email = ${userConfig.email}
        ${builtins.readFile (pkgs.writeText "git-extra" (builtins.toJSON gitConfig.extraConfig))}
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
      '';
    in
      pkgs.mkShell {
        name = "cli-environment";
        packages =
          (getPackages pkgs)
          ++ [
            (nvim-config.packages.${system}.default or pkgs.neovim)
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
      };

    # Home-manager module
    homeManagerModule = {
      config,
      pkgs,
      ...
    }: {
      home = {
        packages =
          (getPackages pkgs)
          ++ [
            (nvim-config.packages.${pkgs.system}.default or pkgs.neovim)
          ];

        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
          PAGER = "bat";
        };

        file.".config/oh-my-posh/theme.json".text = builtins.toJSON ompTheme;
      };

      programs = {
        home-manager.enable = true;

        git =
          {
            enable = true;
          }
          // gitConfig;

        zsh = {
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
          '';
        };

        bat = {
          enable = true;
          config = {
            theme = "TwoDark";
            pager = "less -FR";
          };
        };

        eza = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };

        fzf = {
          enable = true;
          enableZshIntegration = true;
          defaultCommand = "fd --type f --hidden --follow --exclude .git";
          defaultOptions = [
            "--height 40%"
            "--layout=reverse"
            "--border"
          ];
        };

        ssh = {
          enable = true;
          compression = true;
          controlMaster = "auto";
          controlPath = "~/.ssh/control/%C";
          controlPersist = "10m";
        };

        yazi = {
          enable = true;
          enableZshIntegration = true;
        };

        zoxide = {
          enable = true;
          enableZshIntegration = true;
          options = ["--cmd cd"];
        };

        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };
    };
  in {
    # For temporary shell: nix shell / nix develop
    devShells = forAllSystems (system: {
      default = mkCliShell system;
    });

    # For permanent installation: home-manager
    homeConfigurations = {
      # Default configuration
      ${userConfig.username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${builtins.currentSystem or "x86_64-linux"};

        modules = [
          homeManagerModule
          {
            home = {
              username = userConfig.username;
              homeDirectory =
                if pkgs.stdenv.isDarwin
                then "/Users/${userConfig.username}"
                else "/home/${userConfig.username}";
              stateVersion = "24.05";
            };
          }
        ];
      };
    };

    # Convenience output for nix shell
    packages = forAllSystems (system: {
      default = self.devShells.${system}.default.inputDerivation;
    });
  };
}
