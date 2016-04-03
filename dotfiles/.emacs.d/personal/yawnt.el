;; Set opam-share directory
(setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

;; (prelude-require-packages '(some-package some-other-package))

;; Merlin && Ocp-Indent && Tuareg
(require 'tuareg)
(require 'ocp-indent)
(require 'merlin)

;; Enable auto-complete mode for Merlin
(setq merlin-ac-setup t)

;; Auto start Merlin when Tuareg is triggered
(add-hook 'tuareg-mode-hook 'merlin-mode)

;; Enable Helm
(require 'prelude-helm-everywhere)
