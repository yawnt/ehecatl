{ config, lib, pkgs, ...}: with lib;
{
  environment.variables = {
    JAVA_HOME = ["${pkgs.jdk}"];
  };

  environment.systemPackages = with pkgs; [
    # Tooling
    emacs
    git
    gitAndTools.gitflow
    gcc
    autoconf
    automake
    gnumake
    cmake
    protobuf3_0
    meld

    # Java
    jdk
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

    # Erlang
    erlang
    elixir

    # Haskell
    ghc

    # Big Data
    apacheKafka
    rdkafka
    spark

    # Nix
    nix-prefetch-scripts

    # Nim
    nim
    nimble

    # Docker
    python27Packages.docker_compose

    # Node
    nodejs
  ];
}
