;; Configure load paths
(add-to-list 'load-path "/usr/local/src/org-mode/contrib/lisp")
(add-to-list 'load-path "/usr/local/src/org-mode/EXPERIMENTAL")

;; Enable org-mode major mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.psp\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.notes\\'" . org-mode))

;; Fontify code blocks
(setq org-src-fontify-natively t)

;; Enable check-list modes
;; (require 'org-checklist)

;; Configure key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-log-done t)
(setq org-log-into-drawer t)

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
