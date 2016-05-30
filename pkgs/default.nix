pkgs :
rec {
  emacs = (import ./emacs) pkgs.emacs pkgs.fetchgit;
  postscript-lexmark = pkgs.callPackage ./postscript-lexmark { };
}
