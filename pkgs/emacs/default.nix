emacs: fetchgit:

let
  default = ./emacslisp/default.el;
  tmpInit = ./emacslisp/tmpInit.el;
  tmpCompile = ./emacslisp/tmpCompile.el;
  yawntEmacs = ./yawnt.el;
  prelude = fetchgit {
    url = https://github.com/bbatsov/prelude.git;
    rev = "74b2b766180793409df77d65b8bf0115f3df45f4";
    sha256 = "0b0hlj53kpzzln5l1bswl97225y1wih8mh4q19q79wv4jysj4cnq";
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
