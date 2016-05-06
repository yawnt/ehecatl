{ pkgs, fetchgit } :

let
  default = ./default.el;
  tmpInit = ./tmpInit.el;
  tmpCompile = ./tmpCompile.el;
  prelude = fetchgit {
    url = https://github.com/bbatsov/prelude.git;
    rev = "2b85871805526261b6c3600a4fd103538ebee96f";
    sha256 = "1vl7v3gks78r4k9dzhhzhlkwqjaxmv13pd9zv1hz0d3k84mryc3c";
  };
in
pkgs.emacs.overrideDerivation (drv : {
  postInstall = drv.postInstall + ''
    cp -r ${prelude} $out/share/emacs/site-lisp/prelude
    chmod -R a+w $out/share/emacs/site-lisp/
    $out/bin/emacs -batch -l ${tmpInit}
    $out/bin/emacs -batch -l ${tmpCompile}
    cp ${default} $out/share/emacs/site-lisp/
  '';
})
