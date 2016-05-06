emacs: fetchgit:

let
  default = ./emacslisp/default.el;
  tmpInit = ./emacslisp/tmpInit.el;
  tmpCompile = ./emacslisp/tmpCompile.el;
  yawntEmacs = ./yawnt.el;
  prelude = fetchgit {
    url = https://github.com/bbatsov/prelude.git;
    rev = "2b85871805526261b6c3600a4fd103538ebee96f";
    sha256 = "1vl7v3gks78r4k9dzhhzhlkwqjaxmv13pd9zv1hz0d3k84mryc3c";
  };
in
emacs.overrideDerivation (drv : {
  postInstall = drv.postInstall + ''
    cp -r ${prelude} $out/share/emacs/site-lisp/prelude
    chmod -R a+w $out/share/emacs/site-lisp/
    cp ${yawntEmacs} $out/share/emacs/site-lisp/prelude/personal/yawnt.el
    $out/bin/emacs -batch -l ${tmpInit}
    $out/bin/emacs -batch -l ${tmpCompile}
    cp ${default} $out/share/emacs/site-lisp/default.el
    chmod a+w $out/share/emacs/site-lisp/default.el
    echo "(load (expand-file-name \"init.el\" \"$out/share/emacs/site-lisp/prelude\"))" >> $out/share/emacs/site-lisp/default.el
  '';
})
