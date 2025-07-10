{
  # Git abbreviations
  g = "git";
  gs = "git status";
  ga = "git add";
  gaa = "git add --all";
  gc = "git commit";
  gcm = "git commit -m";
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
  
  # Directory navigation (merged from aliases.nix)
  ls = "eza --icons";
  l = "eza --icons --group-directories-first";
  la = "eza -a --icons";
  ll = "eza -la --icons --git";
  lla = "eza --icons --group-directories-first -la";
  lt = "eza --tree --icons";
  llt = "eza -la --tree --icons --git";
  
  # System commands
  c = "clear";
  h = "history";
  j = "jobs";
  x = "exit";
  
  # File operations (merged from aliases.nix with enhanced flags)
  cp = "cp -iv";
  mv = "mv -iv";
  rm = "rm -iv";
  mkdir = "mkdir -p";
  
  # Editors (from aliases.nix)
  v = "nvim";
  vi = "nvim";
  vim = "nvim";
  
  # File viewing and search
  cat = "bat";
  grep = "rg";
  find = "fd";
  
  # Process management
  ps = "procs";
  top = "btop";
  
  # Network
  http = "httpie";
  
  # Nix commands
  nb = "nix build";
  nd = "nix develop";
  nf = "nix flake";
  nfc = "nix flake check";
  nfu = "nix flake update";
  nfs = "nix flake show";
  
  # Darwin rebuild (macOS)
  drb = "darwin-rebuild build --flake .#mini";
  drs = "darwin-rebuild switch --flake .#mini";
  
  # Home Manager
  hm = "home-manager";
  hmb = "home-manager build --flake .";
  hms = "home-manager switch --flake .";
}