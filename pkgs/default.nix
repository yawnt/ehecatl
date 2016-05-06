pkgs :

let
  inherit (pkgs) callPackage;
in rec {
  sbt = pkgs.sbt.override { jre = pkgs.oraclejre8; };
  leiningen = pkgs.leiningen.override { jdk = pkgs.oraclejdk8; };
  apacheKafka = pkgs.apacheKafka.override { jre = pkgs.oraclejre8; };
  emacs = callPackage ./emacs {};
}
