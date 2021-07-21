;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Dan Barbarito"
      user-mail-address "dan@barbarito.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Mac Setup
(setq mac-command-modifier 'meta)

;; Git Auto Commit
(setq gac-automatically-push-p t)

;; Org
(after! org
  (setq org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))

  ;; Org Capture
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* TODO %?\n%i\n" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n" :prepend t)))

  ;; Org Journal
  (setq
   org-journal-date-prefix "#+TITLE: "
   org-journal-time-prefix "* "
   org-journal-date-format "%a, %Y-%m-%d"
   org-journal-file-format "%Y-%m-%d.org"
   org-journal-time-format "%I:%M %p")

  (map! (:leader (:prefix "n" :desc "Org Rifle" "r" #'helm-org-rifle-agenda-files)))


  ;; Agenda Columns
  (setq org-columns-default-format
      "%25ITEM %TODO %3PRIORITY %TIMESTAMP %SCHEDULED %DEADLINE")

  ;; Agenda AM/PM
  (setq org-agenda-timegrid-use-ampm t))


;; General
(global-visual-line-mode)

;; Javascript
(add-hook 'js2-mode-hook 'prettier-js-mode)

;; Deft
(setq deft-recursive t)

;; Web Mode
(add-to-list 'auto-mode-alist '("\\.ep\\'" . web-mode))
(setq web-mode-markup-indent-offset 2)
(setq web-mode-engines-alist
          '(("liquid" .
             "templates/.*\\.html\\'")))

;; Perl
(defalias 'perl-mode 'cperl-mode)
(defun my-perl-mode-save-hook ()
  (perltidy-buffer))

(defun my-perl-mode-hook ()

  (let ((root (ignore-errors (projectile-project-root))))
    (when root
      (add-to-list
       (make-variable-buffer-local 'flycheck-perl-include-path)
       (concat root "lib"))))

  (add-hook 'before-save-hook 'my-perl-mode-save-hook nil 'local))

(after! cperl-mode
  (load! "vendor/perltidy.el")
  (add-hook 'cperl-mode-hook 'my-perl-mode-hook))
