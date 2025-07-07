{pkgs}: {
  package = pkgs.lib.optionals pkgs.stdenv.isLinux [pkgs.xclip pkgs.wl-clipboard];
}
