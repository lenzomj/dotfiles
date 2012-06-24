;;**********************************************************************
;;.emacs
;;The following configuration file is loaded upon starting emacs.
;;**********************************************************************

;; Configure global load paths
(add-to-list 'load-path "~/.emacs.d/plugins")

;; Package management
;;    Initialize package management tool (new in Emacs 24).
;;    (package-initialize) will configure the appropriate
;;    load paths, so it needs to come first in the .emacs file.
(require 'package)
(add-to-list 'package-archives
         '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; Clean-up after exiting
(add-hook 'server-done-hook (lambda nil (kill-buffer nil)))

;; Put autosave files (i.e., #foo#) in one place
;;     Autosave files will be located in /tmp/emacs_mjlenzo.
;;     If the directory does not already exist, it will be created.
;;     In the event of crash, use M-x (recover-this-file).
(defvar backup-dir (concat "/tmp/emacs_" (user-login-name) "/"))
(make-directory backup-dir t)

(setq auto-save-list-file-name (concat backup-dir "/auto-save-list/"))

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))
 
(defun make-auto-save-file-name ()
  (concat backup-dir
    (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
        (expand-file-name (concat "#%" (buffer-name) "#")))))

;; Put backup files (i.e., foo~) in one place
;;     Backup files will be located in /tmp/emacs_mjlenzo.
;;     Emacs will keep the last 6 new versions and last two old
;;     versions of each file. Middle versions are deleted.
(setq backup-directory-alist (list (cons "." backup-dir)))
(setq bkup-backup-directory-info (list (cons "." backup-dir)))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)
;; (setq make-backup-files nil) ;; You're gonna have a bad day.

;; Enable line numbers
(require 'linum)
(global-linum-mode t)
(setq linum-format "%d: ")

;; Enable mouse support
(defun my-terminal-config (&optional frame)
  "Establish settings for the current terminal."
  (if (not frame) ;; The initial call.
      (xterm-mouse-mode 1)
    ;; Otherwise called via after-make-frame-functions.
    (if xterm-mouse-mode
        ;; Re-initialise the mode in case of a new terminal.
        (xterm-mouse-mode 1))))

;; Evaluate both now (for non-daemon emacs) and upon frame creation
;; (for new terminals via emacsclient).
(my-terminal-config)
(add-hook 'after-make-frame-functions 'my-terminal-config)

(unless window-system
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1))))

;; Configure global editor settings
(setq inhibit-splash-screen t)
(setq default-major-mode 'text-mode)
(setq-default indent-tabs-mode nil)
(setq default_tab_width 2)
(setq-default transient-mark-mode t)
(setq ring-bell-function 'ignore)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)


;; Activate and configure autocompletion
(when (require 'auto-complete-config nil 'noerror) 
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (setq ac-comphist-file (concat backup-dir "ac-comphist.dat"))
  (ac-config-default))

;; Configure auto-fill mode
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default fill-column 80) 

;; Configure yasnippet
(require 'yasnippet-bundle)
(make-directory "~/.emacs.d/snippets/" t)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)

;; Enable and configure org mode
(require 'org-config)

;; Enable and configure jabber support
(require 'jabber-config)

;; Enable and configure git support
(require 'magit)
(require 'git-commit)
(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG$" . git-commit-mode))
(add-hook 'git-commit-mode-hook 'turn-on-flyspell)
(add-hook 'git-commit-mode-hook (lambda () (toggle-save-place 0)))

;; Enable and configure flyspell
(setq flyspell-issue-welcome-flag nil)
(dolist (hook '(org-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))
