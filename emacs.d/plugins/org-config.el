;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-config - emacs configuration file for org-mode major mode
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

;; Enable org-mode major mode
(require 'org-install)

;;---------------------------------------------------------------------
;; Org-mode load paths and directories
;;---------------------------------------------------------------------
;;    Specify load paths for org-mode lisp files.
;;---------------------------------------------------------------------
(add-to-list 'load-path "/usr/local/src/org-mode/lisp")
(add-to-list 'load-path "/usr/local/src/org-mode/contrib/lisp")
(setq org-directory "~/Dropbox/org")
(add-to-list 'load-path org-directory)

;;---------------------------------------------------------------------
;; Agenda files
;;---------------------------------------------------------------------
;;    Specify directories to parse for agenda items.
;;---------------------------------------------------------------------
(setq org-agenda-files 
  (list "~/org/home" 
        "~/org/projects"
        "~/org/system"
        "~/org/fam"))

;;---------------------------------------------------------------------
;; Agenda view and export
;;---------------------------------------------------------------------
;;    Configure the behavior of the agenda view and exporter.
;;---------------------------------------------------------------------
(setq org-agenda-include-all-todo nil)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-todo-ignore-scheduled t)

(setq org-agenda-ndays 21)             ;; Display 21 days in overview
(setq org-agenda-start-on-weekday nil) ;; Start on current day
(setq calendar-week-start-day 1)       ;; First day of week is monday

(setq org-agenda-custom-commands
      '(("X" agenda ""
         ((ps-number-of-columns 2)
          (ps-landscape-mode t)
          (org-agenda-prefix-format " [ ] ")
          (org-agenda-with-colors nil)
          (org-agenda-ndays 7)
          (org-agenda-start-on-weekday 0)
          (org-agenda-remove-tags t))
         ("~/org/agenda.ps"))))

;; Configure org-mode extension hooks
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))


;; Configure additional key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Configure TODO States
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "STAGED(s)" "|" "DONE(d)")
        (sequence "|" "CANCELED(c)")))

;; Configure time logging
(setq org-log-done t)
(setq org-log-into-drawer t)

;; Configure project list
(require 'org-projects)

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (python . t)
   (ruby . t)
   (emacs-lisp . t)
   ))
;; Fontify code blocks
(setq org-src-fontify-natively t)

(setq org-confirm-babel-evaluate nil)

(provide 'org-config)
;;; org-config.el ends here
