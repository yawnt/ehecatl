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

(require 'prelude-latex)

(prelude-require-packages '(nix-mode
                            protobuf-mode
                            ocp-indent
                            helm-company
                            yaml-mode
                            markdown-mode
                            haskell-mode
                            ))
(require 'nix-mode)
(require 'protobuf-mode)

(require 'ocp-indent)

(require 'yaml-mode)
(require 'markdown-mode)

(define-key company-mode-map [remap indent-for-tab-command]
  'company-indent-for-tab-command)

(setq tab-always-indent 'complete)

(defvar completion-at-point-functions-saved nil)

(defun company-indent-for-tab-command (&optional arg)
  (interactive "P")
  (let ((completion-at-point-functions-saved completion-at-point-functions)
        (completion-at-point-functions '(company-complete-common-wrapper)))
    (indent-for-tab-command arg)))

(defun company-complete-common-wrapper ()
  (let ((completion-at-point-functions completion-at-point-functions-saved))
        (company-complete-common)))

(require 'haskell-mode)

;;; yawnt.el ends here
