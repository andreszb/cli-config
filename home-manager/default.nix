{
  config,
  pkgs,
  userConfig,
  nvim-config,
  ...
}: let
  packagesConfig = import ../packages {inherit pkgs userConfig;};
in
  {
    home = {
      packages =
        packagesConfig.packageList
        ++ [
          (nvim-config.packages.${pkgs.system}.default or pkgs.neovim)
        ];

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "bat";
      };

      file.".config/cli-config-version.txt".text = let
        gitDir = ../.git;
        headFile = "${gitDir}/HEAD";
        refContent = if builtins.pathExists headFile 
          then builtins.readFile headFile 
          else "ref: refs/heads/main\n";
        isRef = builtins.match "ref: (.*)\n" refContent;
        commitHash = if isRef != null 
          then (
            let refPath = "${gitDir}/${builtins.head isRef}";
            in if builtins.pathExists refPath 
               then builtins.readFile refPath 
               else "unknown\n"
          )
          else refContent;
        shortHash = builtins.substring 0 7 (builtins.replaceStrings ["\n"] [""] commitHash);
      in ''
        CLI Config Version: ${shortHash}
        Last updated: ${builtins.currentTime}
        
        🔖 You are running the latest permanent configuration!
        🏠 Home Manager successfully applied this version.
      '';
    };

    programs =
      {
        home-manager.enable = true;
      }
      // packagesConfig.homeManagerConfigs;
  }
  // packagesConfig.topLevelConfigs
