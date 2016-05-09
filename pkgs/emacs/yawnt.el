;;; yawnt.el --- yawnt's emacs' customizations
;;
;; Copyright © 2015 yawnt
;;
;;; Commentary:

;; Customize Emacs' experience

;;; Code:


(setq inhibit-startup-message t)

(require 'prelude-helm)
(require 'prelude-helm-everywhere)
(require 'prelude-company)

(require 'prelude-clojure)

(require 'prelude-emacs-lisp)

(require 'prelude-js)

(require 'prelude-lisp)

(require 'prelude-scala)

(require 'prelude-shell)

(require 'prelude-ocaml)

(prelude-require-packages '(nix-mode
                            protobuf-mode
                            ensime
                            ocp-indent
                            ))
(require 'nix-mode)
(require 'protobuf-mode)

(require 'ensime)

(add-hook 'scala-mode-hook 'ensime-mode)

(require 'ocp-indent)

;;; yawnt.el ends here
