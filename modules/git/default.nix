{ userConfig }:

{
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
}