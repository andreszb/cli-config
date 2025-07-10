{
  # Git abbreviations
  g = "git";
  gs = "git status";
  ga = "git add";
  gaa = "git add --all";
  gc = "git commit";
  gcm = "git commit -m";
  gcam = "git commit -am";
  gca = "git commit --amend";
  gp = "git push";
  gpl = "git pull";
  gco = "git checkout";
  gcb = "git checkout -b";
  gd = "git diff";
  gdc = "git diff --cached";
  gl = "git log --oneline";
  glg = "git log --graph --oneline --decorate";
  gst = "git stash";
  gstp = "git stash pop";
  
  # Directory navigation with eza (merged from aliases.nix + eza config)
  ls = "eza -1 --icons --group-directories-first";
  l = "eza --icons --group-directories-first";
  la = "eza -1 -a --icons";
  lt = "eza --tree --icons";
  
  # System commands
  c = "clear";
  h = "history";
  j = "jobs";
  x = "exit";
  
  # Directory navigation with zoxide
  cd = "z";
  y = "yazi";
  
  # File operations 
  cp = "cp -iv";
  mv = "mv -iv";
  rm = "rm -iv";
  mkdir = "mkdir -p";
  mk = "(){ mkdir -p $1 && cd $1 }";
  
  # File viewing and search
  cat = "bat";
  grep = "rg";
  find = "fd";
  
  # Process management
  ps = "procs";
  top = "btop";
  
  # Nix commands
  nb = "nix build";
  nd = "nix develop";
  nf = "nix flake";
  nfc = "nix flake check";
  nfu = "nix flake update";
  nfs = "nix flake show";
  
  # Darwin rebuild (macOS)
  drb = "sudo darwin-rebuild build --flake .#mini";
  drs = "sudo darwin-rebuild switch --flake .#mini";
}
