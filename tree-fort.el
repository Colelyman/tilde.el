;;; package --- Cole Lyman's configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;; This is my custom configuration.

;;; Code:

;; General variable definitions
(setq default-directory "~/"
      mac-command-modifier 'meta
      mac-option-modifier  'super
      user-full-name "Cole Lyman"
      user-mail-address "cole@colelyman.com"
      tab-stop-list (number-sequence 4 200 4)
	  c-default-style "k&r"
	  c-basic-offset 4)
(setq-default tab-width 4)
(set-fill-column 80)

;; Some keybindings
(general-define-key
 :states '(normal visual insert emacs)
 "M-s"     'save-buffer
 "M-f"     'swiper
 "C-x C-f" 'counsel-find-file
 "C-c C-r" 'ivy-resume
 "C-h f"   'helpful-callable
 "C-h v"   'helpful-variable
 "C-h k"   'helpful-key
 "C-h F"   'helpful-function
 "C-h C"   'helpful-command)

(general-def ivy-mode-map
 "C-j"     'ivy-next-line
 "C-k"     'ivy-previous-line)

;; tramp
(use-package tramp
  :defer t
  :config
  (setq vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
				     vc-ignore-dir-regexp
				     tramp-file-name-regexp)
	tramp-completion-reread-directory-timeout nil
	tramp-verbose 1
	remote-file-name-inhibit-cache nil)
  (add-to-list 'password-word-equivalents "verification code")
  (customize-set-variable 'tramp-password-prompt-regexp
			  (format "^.*\\(%s\\).*:\^@? *"
				  (regexp-opt (or (bound-and-true-p password-word-equivalents)
						  '("password" "passphrase" "verification code"))))))

;; org-mode
(use-package org
  :defer t
  :config
  (setq org-todo-keywords '((sequence "TODO" "WAIT" "DONE"))
	org-log-done 'time
	org-directory (expand-file-name "~/org")
	org-latex-packages-alist '(("" "minted"))
	org-latex-pdf-process
	'("%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
	  "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
	  "%latex -shell-escape -interaction nonstopmode -output-directory %o %f")
	org-file-apps '(("pdf" . emacs)
			("\\.x?html?\\'" . emacs)
			("/docs/" . emacs)
			(auto-mode . emacs)
			(directory . emacs)
			(t . "open -R \"%s\""))
	org-agenda-files '("~/org/master.org" "~/org/2019/winter.org" "~/org/ccsb/ccsb.org")
;;	(nthcdr 4 org-emphasis-regexp-components) 10
	org-capture-templates
	'(("e" "Email task" entry (file+olp+datetree "~/org/master.org")
	   "* TODO %? :EMAIL:\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
	  ("t" "Todo" entry (file+olp+datetree "~/org/master.org")
	   "* TODO %?\nDEADLINE: %^t")
	  ("s" "School todo" entry (file "~/org/2018/spring.org")
	   "* TODO %? %^g\nDEADLINE: %^t")
	  ("j" "Journal entry" plain (file+olp+datetree "~/org/journal.org")
	   "%?")
	  ("z" "Zettel" entry (file+olp ozk-zettelkasten-file "Zettels")
	   "* %(ozk-get-header) %^{Title} %^g\n:properties:\n  :id: %(ozk-get-header)\n:end:\n%?")
	  ("h" "Hugo post" entry (file+olp "~/code/colelyman-hugo/site/content-org/posts.org" "Blog Ideas")
	   (function org-hugo-new-subtree-post-capture-template))))
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
  (add-hook 'org-mode-hook 'org-indent-mode)
  (advice-add 'org-deadline :after 'org-save-all-org-buffers)
  (advice-add 'org-refile :after 'org-save-all-org-buffers))

(use-package org-bullets
  :load-path "org-bullets"
  :after org
  :hook (org-mode . org-bullets-mode))

;; org-ref settings
(use-package org-ref
  :defer t
  :init
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  :config
  (defvar org-ref-directory
    (concat (file-name-as-directory org-directory) "papers/")
    "A variable used to more easily defin other `org-ref' variables.")
  (setq org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :INTERLEAVE_PDF: ./lib/%k.pdf\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
        org-ref-directory (concat (file-name-as-directory org-directory) "papers/")
        org-ref-notes-directory org-ref-directory
        org-ref-bibliography-notes (concat org-ref-directory "index.org")
        org-ref-default-bibliography (list (concat org-ref-directory "index.bib"))
        org-ref-pdf-directory (concat org-ref-directory
                                      (file-name-as-directory "lib"))
        bibtex-completion-bibliography (concat org-ref-directory "index.bib")
        bibtex-completion-library-path org-ref-pdf-directory
        bibtex-completion-notes-path org-ref-bibliography-notes))

;; interleave
(use-package interleave
  :commands interleave-mode)

;; pdf-tools
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install))

;; exec-path-from-shell
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; code customizations
;; if compilation is successful, then close the buffer after 1 second
;; from: https://emacs.stackexchange.com/questions/62/hide-compilation-window
(setq compilation-finish-functions
      '((lambda (buf str)
          (if (null (string-match ".*exited abnormally.*" str))
              ;;no errors, make the compilation window go away in a few seconds
              (progn
                (run-at-time
                 "1 sec" nil 'delete-windows-on
                 (get-buffer-create "*compilation*"))
                (message "No Compilation Errors!"))))))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; irony
(use-package irony
  :ensure t
  :defer t
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode))
(use-package company-irony
  :ensure t
  :defer t
  :after company
  :init
  (add-to-list 'company-backends 'company-irony))
(use-package company-c-headers
  :ensure t
  :defer t
  :after company
  :init
  (add-to-list 'company-backends 'company-c-headers)
  :config
  (setq company-c-headers-path-user
		'("." "./inc" "../inc" "./include" "../include")))

;; gendoxy
(use-package gendoxy
  :load-path "~/code/gendoxy/"
  :config
  (setq gendoxy-backslash nil
      gendoxy-default-text ""
      gendoxy-skip-details nil
      gendoxy-details-empty-line t))

;; projectile
(use-package projectile
  :ensure t
  :defer t
  :init
  (general-define-key
   :states '(normal visual insert emacs)
;;   :keymaps 'projectile-mode-map
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "p" '(projectile-command-map :which-key "projectile"))
  :config
  (projectile-mode +1))
(use-package ripgrep
  :ensure t
  :defer t)

;; python
(use-package company-jedi
  :ensure t
  :defer t
  :after company
  :init
  (add-to-list 'company-backends 'company-jedi))
(use-package anaconda-mode
  :ensure t
  :defer t
  :hook ((python-mode . anaconda-mode)
		 (python-mode . anaconda-eldoc-mode))
  :config
  (setq anaconda-mode-localhost-address "localhost"))

;; workgroups
(use-package workgroups
  :ensure t)

;; persp-mode
(use-package persp-mode
  :ensure t
  :after workgroups
  :hook (after-init . persp-mode)
  :config
  (setq wg-morph-on nil
		persp-autokill-buffer-on-remove 'kill-weak
		persp-nil-name 'main
		persp-set-read-buffer-function t
		persp-set-ido-hooks t))


;;; tree-fort.el ends here
