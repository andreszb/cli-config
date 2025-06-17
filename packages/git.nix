{
  pkgs,
  userConfig,
}: {
  package = pkgs.git;

  homeManagerConfig = {
    enable = true;
    userName = userConfig.name;
    userEmail = userConfig.email;

    extraConfig = {
      # Basic configuration
      init.defaultBranch = "main";
      core.editor = "nvim";

      # Branch and remote operations
      pull.rebase = true;
      push.autoSetupRemote = true;
      branch.autosetupmerge = true;
      branch.autosetuprebase = "always";
      fetch.prune = true;

      # Merge and conflict resolution
      merge.tool = "nvim";
      merge.conflictstyle = "diff3";
      rerere.enabled = true;

      # Rebase settings
      rebase.autosquash = true;
      rebase.autostash = true;

      # Diff configuration
      diff.colorMoved = "default";
      diff.algorithm = "histogram";
      diff.compactionHeuristic = true;

      # Performance optimizations
      core.preloadindex = true;
      core.fscache = true;
      core.fsmonitor = true;
      core.untrackedcache = true;
      gc.auto = 256;

      # Security and integrity
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;

      # SSH commit signing
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      commit.gpgsign = true;
      tag.gpgsign = true;

      # Submodule handling
      submodule.recurse = true;
      status.submodulesummary = true;

      # URL shortcuts
      url."git@github.com:".insteadOf = "gh:";
      url."https://github.com/".insteadOf = "github:";

      # Credential management
      credential.helper = "store";
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
}
