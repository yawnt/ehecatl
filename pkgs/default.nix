pkgs :
rec {
  emacs = (import ./emacs) pkgs.emacs pkgs.fetchgit;
}
