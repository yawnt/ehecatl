{ config, lib, pkgs, ...}: with lib;
{
  environment.variables.JAVA_HOME = "${pkgs.oraclejdk8}";

  environment.systemPackages = with pkgs; [
    # Tooling
    emacs
    git
    gcc
    autoconf
    automake
    gnumake
    cmake
    protobuf3_0
    meld

    # Java
    oraclejdk8
    maven

    # Scala
    sbt

    # Clojure
    leiningen

    # OCaml
    ocaml
    opam
    ocamlPackages.merlin
    ocamlPackages.ocpIndent
    ocamlPackages.ocaml_oasis

    # Haskell
    ghc
    stack

    # Big Data
    apacheKafka
    rdkafka
    spark

    # Nix
    nix-prefetch-scripts

    # Docker
    python27Packages.docker_compose
  ];
}
