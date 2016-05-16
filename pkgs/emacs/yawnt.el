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
                            helm-company
                            ))
(require 'nix-mode)
(require 'protobuf-mode)

(require 'ensime)

(add-hook 'scala-mode-hook 'ensime-mode)

(require 'ocp-indent)

(global-set-key "\t" 'company-complete-common)
(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-active-map (kbd "C-:") 'helm-company)))

;;; yawnt.el ends here
