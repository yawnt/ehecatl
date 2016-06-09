emacs: fetchgit:

let
  default = ./emacslisp/default.el;
  tmpInit = ./emacslisp/tmpInit.el;
  tmpCompile = ./emacslisp/tmpCompile.el;
  yawntEmacs = ./yawnt.el;
  prelude = fetchgit {
    url = https://github.com/bbatsov/prelude.git;
    rev = "f27de9705ca92a790693ff7354ff5e19af94feb9";
    sha256 = "0dvsvv2h43xrp4sa79a8qvj5wa0rz5iqp55lgl9j6xwg6slzwwl5";
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
