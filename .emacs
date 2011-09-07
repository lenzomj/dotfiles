;;**********************************************************************
;;.emacs
;;The following configuration file is loaded upon starting emacs.
;;**********************************************************************

;; Configure global load paths
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "/usr/local/share/emacs/24.0.50/site-lisp")
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-1.3.1")

;; Put autosave files (ie #foo#) in one place
(defvar backup-dir (concat "/tmp/emacs_" (user-login-name) "/"))
(make-directory backup-dir t)
 
(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))
 
(defun make-auto-save-file-name ()
  (concat backup-dir
    (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
        (expand-file-name (concat "#%" (buffer-name) "#")))))
 
;; Put backup files (ie foo~) in one place
(setq backup-directory-alist (list (cons "." backup-dir)))
(setq bkup-backup-directory-info (list (cons "." backup-dir)))
(setq make-backup-files nil)

;; Global editor settings
(require 'linum)
(global-linum-mode t)
(setq linum-format "%d: ")
(setq inhibit-splash-screen t)
(setq default-major-mode 'text-mode)
(setq-default indent-tabs-mode nil)
(setq default_tab_width 2)
(setq-default transient-mark-mode t)
(setq ring-bell-function 'ignore)
;;(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)

;; Configure autocompletion
(require 'auto-complete-config)
(ac-config-default)
(setq ac-comphist-file (concat backup-dir "ac-comphist.dat"))
(add-to-list 'ac-dictionary-directories "~/.emacs.d/vendor/auto-complete-1.3.1/dict")

;; Configure auto-fill mode
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default fill-column 66) 

;; Configure yasnippet
(require 'yasnippet-bundle)
(make-directory "~/.emacs.d/snippets/" t)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)

;; Enable and configure org mode
(require 'org-config)