;;; org-config.el --- 

;; Copyright (C) 2011 Matthew Lenzo

;; Author: Matthew Lenzo
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Enable org-mode major mode
(require 'org-install)

;; Configure org-mode load paths
(add-to-list 'load-path "/usr/local/src/org-mode/lisp")
(add-to-list 'load-path "/usr/local/src/org-mode/contrib/lisp")
(add-to-list 'load-path "/usr/local/src/org-mode/EXPERIMENTAL")

;; Configure org-mode directories
(setq org-directory "~/Dropbox/org")
(add-to-list 'load-path org-directory)

;; Configure default notes files
(setq org-default-notes-file (concat org-directory "/scratch.notes"))

(defun open-gtd () ;; GTD notes file
  (interactive)
  (find-file (concat org-directory "/todo.gtd"))
)
(global-set-key (kbd "C-c g") 'open-gtd)

(defun open-journal () ;; Journal notes file
  (interactive)
  (find-file (concat org-directory "/journal.notes"))
)
(global-set-key (kbd "C-c j") 'open-journal)

(defun open-scratchpad () ;; Scratchpad notes file
  (interactive)
  (find-file (concat org-directory "/scratch.notes"))
)
(global-set-key (kbd "C-c p") 'open-scratchpad)

;; Configure agenda files
(setq org-agenda-files 
  (list "~/org/home" 
        "~/org/msd"
        "~/org/mod"
        "~/org/mtd"
        "~/org/system"
        "~/org/smart"
        "~/org/com"
        "~/org/studio"))

;; Configure geektool batch agenda 
;(setq org-agenda-custom-commands
;  '(
;    ("G" "Geektool agenda"
;      ((agenda "")(alltodo))
;      ((org-agenda-ndays 1)(org-deadline-warning-days 7))
;      ("~/.agenda_view")
;    )))

;; Configure agenda view
(setq org-agenda-include-all-todo nil)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-todo-ignore-scheduled t)

;; display 7 days in overview
(setq org-agenda-ndays 7)
;; start calendar on the current day
(setq org-agenda-start-on-weekday nil)
;; first day of week is monday
(setq calendar-week-start-day 1)

;; Configure org-mode extension hooks
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.psp\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.notes\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.gtd\\'" . org-mode))

;; Fontify code blocks
(setq org-src-fontify-natively t)

;; Configure additional key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Configure TODO States
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)")
        ;(sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
        (sequence "|" "CANCELED(c)")))

;; Configure time logging
(setq org-log-done t)
(setq org-log-into-drawer t)

;; Configure project list
(require 'org-projects)

(setq org-capture-templates
  '(("t" "TODO" entry (file+headline (concat org-directory "/refile.org"))
         "* TODO %?\n%U\n%a\n  %i" :clock-in t :clock-resume t)
    ("n" "note" entry (file (concat org-directory "/refile.org"))
         "* %? :NOTE:\n%U\n%a\n  %i" :clock-in t :clock-resume t)
    ("j" "Journal" entry (file+datetree (concat org-directory "/journal.org"))
         "* %?\n%U\n  %i" :clock-in t :clock-resume t)
    ("w" "org-protocol" entry (file (concat org-directory "/refile.org"))
         "* TODO Review %c\n%U\n  %i" :immediate-finish t)
    ("i" "Interruption" entry (file+headline (concat buffer-file-name "") "Interruption Log")
         "* %?\n:PROPERTIES:\n:Time: %U\n:Phase: %k\n:END:\n" :clock-in t :clock-resume t)
    ("d" "Defect (local)" entry (file+headline (concat buffer-file-name "") "Defect Log") 
         "* Defect\n:PROPERTIES:\n:Date: %T\n:Type: %?\n:Phase: %k\n:END:\n%i" :prepend t)
   )
)

;; Enable kindlegen support
(defun kindlegen ()
  "Exports an org-mode text file to MOBI format"
  (interactive)
  (org-export-as-html-to-buffer nil)
  (write-file "/tmp/kgen.html")
  (kill-buffer-and-window)
  (let ((buffer (get-buffer-create "*temp*")))
    (with-current-buffer buffer
      (unwind-protect
        (shell-command "kindlegen /tmp/kgen.html -o kgen.mobi > /dev/null")
        (shell-command "mv /tmp/kgen.mobi $HOME/Desktop/kgen.mobi")
        (print "Created kgen.mobi on ~/Desktop")
      )
    )
  )
)


(provide 'org-config)
;;; org-config.el ends here
