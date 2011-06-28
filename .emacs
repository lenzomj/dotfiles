
;; Configure load paths
(add-to-list 'load-path "~/.emacs.d/plugins")

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs-backups/.
(make-directory "~/.emacs-backups/autosaves/" t)
(setq auto-save-list-file-name "~/.emacs-backups/auto-save-list")
(setq ac-comphist-file "~/.emacs-backups/ac-comphist.dat")
(custom-set-variables
  '(auto-save-file-name-transforms '((".*" "~/.emacs-backups/autosaves/\\1" t)))
  '(backup-directory-alist '((".*" . "~/.emacs-backups/backups/"))))


;; Configure tab settings
(setq-default indent-tabs-mode nil)
(setq default_tab_width 4)

;; Configure pymacs framework and extensions
;; (require 'pymacs)
;; (pymacs-load "ropemacs" "rope-")
;; (setq ropemacs-enable-autoimport t)
;; (setq python-check-command "pyflakes")

;; Configure autocompletion
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-1.3.1")
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/vendor/auto-complete-1.3.1/dict")

;; Enable transient mark mode
(setq-default transient-mark-mode t) 

;; Enable line numbers at cursor and in the margin
(require 'linum)
(global-linum-mode t)
(setq linum-format "%d ")

;; Configure yasnippet
(require 'yasnippet-bundle)
(make-directory "~/.emacs.d/snippets/" t)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)
