{ config, lib, pkgs, ...}: with lib;
{
  environment.systemPackages = with pkgs; [
    # Tooling
    emacs
    git
    gcc
    autoconf
    automake
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

    # Nix
    nix-prefetch-scripts

    # Docker
    python27Packages.docker_compose
  ];
}
