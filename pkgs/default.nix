pkgs :
rec {
  #sbt = pkgs.sbt.override { jre = pkgs.oraclejre8; };
  #leiningen = pkgs.leiningen.override { jdk = pkgs.oraclejdk8; };
  #apacheKafka = pkgs.apacheKafka.override { jre = pkgs.oraclejre8; };
  #spark = pkgs.spark.override { jre = pkgs.oraclejre8; };
  emacs = (import ./emacs) pkgs.emacs pkgs.fetchgit;
}
