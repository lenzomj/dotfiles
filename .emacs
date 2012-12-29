;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .emacs - configuration file loaded upon starting emacs
;;
;; Copyright (C) 2012 Matthew J. Lenzo
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see http://www.gnu.org/licenses/.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;---------------------------------------------------------------------
;; Global load paths
;;---------------------------------------------------------------------
;;    Specify load paths for emacs configuration files.
;;---------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/themes")

;;---------------------------------------------------------------------
;; Package management
;;---------------------------------------------------------------------
;;    Initialize package management tool (new in Emacs 24).
;;    (package-initialize) will configure the appropriate
;;    load paths, so it needs to come first in the .emacs file.
;;---------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;---------------------------------------------------------------------
;; Initialization and shutdown
;;---------------------------------------------------------------------
;;    Configure initialization and shutdown behavior as well
;;    as backup file management. 
;;
;;    Autosave files (i.e., #foo#) will be placed in 
;;    /tmp/emacs_<login>. In the event of crash, use 
;;    M-x (recover-this-file).
;;
;;    Backup files (i.e., foo~) will be placed in 
;;    /tmp/emacs_<login>. Emacs will keep the last 6 
;;    new versions and the last two old versions of 
;;    each file. Middle versions are deleted.
;;---------------------------------------------------------------------

;; Initialization behavior
(setq inhibit-splash-screen t)
(setq initial-scratch-message "")
(setq default-major-mode 'text-mode)

;; Shutdown behavior
(add-hook 'server-done-hook (lambda nil (kill-buffer nil)))

;; Put autosave files (i.e., #foo#) in one place
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
(setq backup-directory-alist (list (cons "." backup-dir)))
(setq bkup-backup-directory-info (list (cons "." backup-dir)))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
;; (setq make-backup-files nil) ;; you're gonna have a bad day.

;;---------------------------------------------------------------------
;; Navigation and mouse support
;;---------------------------------------------------------------------
;;    Enable linum for line number support and xterm mouse
;;    mode support. The Apple mouse requires some special
;;    configuration options.
;;---------------------------------------------------------------------

;; Line and column numbers
(require 'linum)
(global-linum-mode t)
(setq linum-format "%3d: ")
(setq-default fill-column 72)
(setq-default column-number-mode t)
(setq-default line-number-mode t)

;; Mouse support
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

;;---------------------------------------------------------------------
;; Editor preferences
;;---------------------------------------------------------------------

(tool-bar-mode -1)
(menu-bar-mode -1)
(setq-default indent-tabs-mode nil)
(setq default_tab_width 2)
(setq-default transient-mark-mode t)
(setq ring-bell-function 'ignore)
(fset 'yes-or-no-p 'y-or-n-p)

(defvar face-ml-default
  '(:foreground "black" :background "yellow"))

; Customize mode-line
(setq-default mode-line-format
      (list
       ;; buffer name
       (propertize "%b "  'face face-ml-default)

       ;; (line,column)
       (propertize "("    'face face-ml-default)
       (propertize "%02l" 'face face-ml-default) 
       (propertize ","    'face face-ml-default)
       (propertize "%02c" 'face face-ml-default) 
       (propertize ") "   'face face-ml-default)

       ;; [%position/file_size]
       (propertize "["    'face face-ml-default)
       (propertize "%02p" 'face face-ml-default)
       ;;(propertize "|"  'face face-ml-default)
       ;;(propertize "%I" 'face face-ml-default) 
       (propertize "] "   'face face-ml-default)

       ;; [major_mode]
       (propertize "["    'face face-ml-default)
       (propertize "%m"   'face face-ml-default)
       (propertize "] "   'face face-ml-default)

       ;; [OVR|INS|MOD|RDO]
       (propertize "["    'face face-ml-default)
       (propertize (if overwrite-mode "OVR" "INS")
                   'face face-ml-default)
       '(:eval (when (buffer-modified-p) 
                 (propertize " MOD" 'face face-ml-default)))
       '(:eval (when (buffer-read-only)
                 (propertize " RO" 'face face-ml-default)))
       (propertize "] " 'face face-ml-default)

       ;; minor-mode-alist  ;; list of minor modes
       ;; fill with '-'
       (propertize "%-" 'face face-ml-default)))


;;---------------------------------------------------------------------
;; Typing preferences and auto-assistance
;;---------------------------------------------------------------------

;; Activate and configure autocompletion
(when (require 'auto-complete-config nil 'noerror) 
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (setq ac-comphist-file (concat backup-dir "ac-comphist.dat"))
  (ac-config-default))

;; Configure auto-fill mode
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;---------------------------------------------------------------------
;; Fontification and color themes
;;---------------------------------------------------------------------

;; Configure themes
(add-to-list 'custom-theme-load-path 
     "~/.emacs.d/themes/emacs-color-theme-solarized")
(load-theme 'solarized-dark t)

;; Enable visual markers to identify bad style
(defun highlight-exceed-col-width ()
  "Highlights any line that exceeds the column width"
  (highlight-lines-matching-regexp ".\\{72\\}" 'hi-yellow))

(add-hook 'emacs-lisp-mode-hook 'highlight-exceed-col-width)
(add-hook 'sh-mode-hook 'highlight-exceed-col-width)
(add-hook 'python-mode-hook 'highlight-exceed-col-width)

;;---------------------------------------------------------------------
;; Snippets and shortcuts
;;---------------------------------------------------------------------

(defun insert-lorem-ipsum ()
  "Insert a lorem ipsum paragraph for typesetting."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, "
          "sed do eiusmod tempor incididunt ut labore et dolore magna "
          "aliqua. Ut enim ad minim veniam, quis nostrud exercitation "
          "ullamco laboris nisi ut aliquip ex ea commodo consequat. "
          "Duis aute irure dolor in reprehenderit in voluptate velit "
          "esse cillum dolore eu fugiat nulla pariatur. Excepteur "
          "sint occaecat cupidatat non proident, sunt in culpa qui "
          "officia deserunt mollit anim id est laborum."))

;; Configure yasnippet
(require 'yasnippet-bundle)
(make-directory "~/.emacs.d/snippets/" t)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)

;;---------------------------------------------------------------------
;; Other customizations
;;---------------------------------------------------------------------

;; Configure org-mode major mode
(require 'org-config)

;; Configure PostScript printer
(setq ps-print-header nil)
(setq ps-font-size 10)
(defun export-ps ()
  "Exports the current buffer as a PostScript file."
  (interactive)
  (ps-spool-buffer)
  (switch-to-buffer "*PostScript*")
  (write-file (concat "out" ".ps"))
  (kill-buffer (current-buffer))
  (message (concat "Exported " "out" ".ps")))

;; Enable and configure flyspell
;;(setq flyspell-issue-welcome-flag nil)
;;(setq-default ispell-program-name "/usr/local/bin/aspell")
;;(dolist (hook '(org-mode-hook))
;;  (add-hook hook (lambda () (flyspell-mode 1))))
