pkgs :
rec {
  haskellEnv = pkgs.haskellPackages.ghcWithPackages (pkgs: [ pkgs.hindent pkgs.stack ]);
  emacs = (import ./emacs) pkgs.emacs pkgs.fetchgit;
  postscript-lexmark = pkgs.callPackage ./postscript-lexmark { };
}
