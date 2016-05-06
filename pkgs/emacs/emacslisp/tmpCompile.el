(let ((default-directory  (expand-file-name "share/emacs/site-lisp/prelude/elpa" (getenv "out"))))
    (normal-top-level-add-subdirs-to-load-path))
(byte-recompile-directory (expand-file-name "share/emacs/site-lisp/prelude/core" (getenv "out")) 0)
