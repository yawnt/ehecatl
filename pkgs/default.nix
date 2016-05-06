pkgs :
rec {
  oraclejdk8 = pkgs.oraclejdk8.overrideDerivation (drv : {
    installPhase = builtins.replaceStrings ["for file in $out/*"] ["shopt -s extglob\nfor file in $out/!(*src.zip)"] pkgs.oraclejdk8.installPhase;
  });
  sbt = pkgs.sbt.override { jre = pkgs.oraclejre8; };
  leiningen = pkgs.leiningen.override { jdk = pkgs.oraclejdk8; };
  apacheKafka = pkgs.apacheKafka.override { jre = pkgs.oraclejre8; };
  emacs = (import ./emacs) pkgs.emacs pkgs.fetchgit;
}
