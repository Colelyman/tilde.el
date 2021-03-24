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
      ispell-program-name "/usr/local/bin/aspell"
      tab-stop-list (number-sequence 4 200 4)
	  c-default-style "k&r"
	  c-basic-offset 4
      ediff-window-setup-function #'ediff-setup-windows-plain
      bidi-inhibit-bpa t
      inhibit-compacting-font-caches t)
(setq-default tab-width 4
	          indent-tabs-mode nil
              fill-column 80
              sentence-end-double-space nil
              bidi-paragraph-direction 'left-to-right)
;; (set-fill-column 80)

(use-package swiper
  :config
  (setq swiper-use-visual-line nil
        swiper-use-visual-line-p (lambda (a) nil)))

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

;; (general-def ivy-mode-map
;;  "C-j"     'ivy-next-line
;;  "C-k"     'ivy-previous-line)

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
  (tramp-set-completion-function "ssh"
                                 '((tramp-parse-sconfig "~/.ssh/config")))
  (add-to-list 'password-word-equivalents "verification code")
  (add-to-list 'password-word-equivalents "tacc token code")
  (customize-set-variable 'tramp-password-prompt-regexp
                          (format "^.*\\(%s\\).*:\^@? *"
                                  (regexp-opt (or (bound-and-true-p password-word-equivalents)
						                          '("password" "passphrase" "verification code" "tacc token code")))))
  (customize-set-variable 'tramp-ssh-controlmaster-options
                          (concat
                           "-o ControlPath=~/.ssh/cm-%%r@%%h:%%p "
                           "-o ControlMaster=auto "
                           "-o ControlPersist=yes")))

;; org-mode
(use-package org
  :defer t
  :config
  (setq org-todo-keywords '((sequence "TODO" "WAIT" "DONE"))
        org-log-done 'time
        org-startup-indented t
        org-directory (expand-file-name "~/org")
        org-latex-packages-alist '()
        org-refile-use-outline-path t
        ;; org-outline-path-complete-in-steps nil
        org-refile-targets '((nil :maxlevel . 2))
        org-refile-allow-creating-parent-nodes 'confirm
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
          ("w" "Worklog" entry (file+olp+datetree "~/org/ccsb/ccsb.org" "Worklog")
           "* %<%H:%M:%S> %^{Title}\n%?\n")
          ("t" "Todo" entry (file+olp+datetree "~/org/master.org")
           "* TODO %?\nDEADLINE: %^t")
          ("s" "School todo" entry (file "~/org/2018/spring.org")
           "* TODO %? %^g\nDEADLINE: %^t")
          ("j" "Journal entry" plain (file+olp+datetree "~/org/journal.org")
           "%?")
          ("z" "Zettel" entry (file+olp ozk-zettelkasten-file "Zettels")
           "* %(ozk-get-header) %^{Title} %^g\n:properties:\n  :id: %(ozk-get-header)\n:end:\n%?")
          ("h" "Hugo post" entry (file+olp "~/code/colelyman-hugo/site/content-org/posts.org" "Blog Ideas")
           (function org-hugo-new-subtree-post-capture-template)))
        org-confirm-babel-evaluate nil)
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (advice-add 'org-deadline :after 'org-save-all-org-buffers)
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (R . t)
     (plantuml . t)
     (dot . t))))

(general-define-key
 "C-c c" '(org-capture :which-key "capture something."))

(defun cole/get-title-from-bibtex (key)
  (message "%s" key)
  (replace-regexp-in-string
   "[{\"]?\\([^}]\\)[}\"]?"
   "\\1"
   (assoc-default "title" (bibtex-completion-get-entry key))))

(use-package org-roam
  :ensure t
  :config
  (defun cole/title-to-slug (title)
    (replace-regexp-in-string "[[:space:]]" "-" title))
  (defun cole/paper-title-or-slug (doi object)
    (let* ((key (cole/insert-bibtex-from-doi doi))
           (title (cole/get-title-from-bibtex key))
           (slug (funcall org-roam-title-to-slug-function title)))
      (cond
       ((eq object 'title) title)
       ((eq object 'slug) slug))))
  (setq org-roam-directory "~/notes"
        org-roam-capture-templates
        '(("d" "default" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "%<%Y%m%d%H%M%S>${slug}"
           :head "#+TITLE: %<%Y%m%d%H%M%S> ${title}\n#+ROAM_KEY: %<%Y%m%d%H%M%S>\n#+ROAM_TAGS: %^{Tags|papers|quotes}\n"
           :unnarrowed t)
          ("p" "paper" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "%<%Y%m%d%H%M%S>%(cole/paper-title-or-slug \"${doi}\" 'slug)"
           :head "#+TITLE: %<%Y%m%d%H%M%S> %(cole/paper-title-or-slug \"${doi}\" 'title)\n#+ROAM_KEY: %<%Y%m%d%H%M%S>\n#+ROAM_TAGS: papers\n"
           :unnarrowed t))
        org-roam-title-to-slug-function (lambda (title)
                                          (if (not (string= "" title))
                                              (concat "_" (cole/title-to-slug title))
                                            "")))
  (add-hook 'after-init-hook 'org-roam-mode))

;; (use-package hyperbole
;;   :ensure t)

(use-package org-superstar
  :ensure t
  :after org
  :hook (org-mode . org-superstar-mode))

;; org-ref settings
(use-package org-ref
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

(use-package request
  :ensure t
  :commands request)

(defun cole/get-bibtex-key (entry)
  (replace-regexp-in-string "@\\(\\w+\\){\\(.+\\)," "\\2"
   (first
    (split-string entry))))

(defun cole/insert-bibtex-from-doi (doi &optional bibfile)
  (interactive "sDOI: ")
  (message "capture info: %s, doi: %s" org-roam-capture--info doi)
  (unless bibfile
    (setq bibfile "/Users/cole/org/papers/index.bib"))
  (save-window-excursion
    (with-current-buffer (find-file-noselect bibfile)
      (goto-char (point-min))
      (let ((bibtex "")
            (key ""))
        (request
          (format "https://dx.doi.org/%s" doi)
          :sync t
          :headers '(("Accept" . "application/x-bibtex"))
          :complete (lambda (&rest _) (message "Retreived bibtex for %s, with key %s!" doi key))
          :success (cl-function
                    (lambda (&key data &allow-other-keys)
                      (when data
                        (setq bibtex data
                              key (cole/get-bibtex-key data))))))
        (goto-char (point-max))
        (when (not (looking-back "\n\n" (min 3 (point))))
          (insert "\n\n"))
        (if (word-search-forward (concat doi) nil t)
             (message "%s is already in this file" doi)
          (when bibtex
            (insert bibtex)
            (save-buffer (current-buffer)))
          key)))))

;; interleave
(use-package interleave
  :ensure t
  :defer t
  :commands interleave-mode)

;; pdf-tools
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :defer t
  :config
  (pdf-tools-install)
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (setq revert-without-query '("\\.pdf")))

;; exec-path-from-shell
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package vterm
  :ensure t
  :defer t
  :commands vterm vterm-other-window
  :config
  (setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=no")
  (define-key vterm-mode-map (kbd "<C-backspace>")
    (lambda () (interactive) (vterm-send-key (kbd "C-w"))))
  (add-to-list 'evil-emacs-state-modes 'vterm-mode)
  (advice-add 'vterm
              :after #'(lambda ()
                         (rename-buffer
                          (format "vterm-%s" (persp-current-name))
                          't)))
  )

(use-package piper
  :load-path "~/.emacs.d/emacs-piper"
  :bind ("C-c C-|" . piper))

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
                (message "No Compilation Errors!")))))
      compilation-scroll-output 'first-error)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; irony
(use-package irony
  :ensure t
  :defer t
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  :config
  (setq irony-cdb-search-directory-list
		'("." "build" "../build" "../../build")
        irony-supported-major-modes
        '(c++-mode c-mode)))
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

;; auctex
(use-package tex-site
  :ensure auctex
  :defer t
  :mode ("\\.tex\\'" . latex-mode)
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-view-program-selection '((output-pdf "pdf-tools"))
        TeX-source-correlate-start-server t
        TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view")))
  (add-hook 'TeX-after-TeX-LaTeX-command-finished-hook
            #'TeX-revert-document-buffer))

;; yasnippet
(use-package yasnippet
  :ensure t
  :defer t
  :config
  (yas-global-mode 1))
(use-package yasnippet-snippets
  :ensure t
  :defer t)
(use-package auto-yasnippet
  :ensure t
  :defer t)

;; dumb-jump
(use-package dumb-jump
  :ensure t
  :defer t
  :config
  (dumb-jump-mode)
  (general-define-key
   :states '(normal)
   :prefix "SPC"
   "jg" '(dumb-jump-go :which-key "go to definition")
   "jG" '(dumb-jump-go-other-window :which-key "go to definition (other window)")
   "jp" '(dumb-jump-back :which-key "return from jump")
   "jj" '(dumb-jump-quick-look :which-key "quick look")))

;; avy
(use-package avy
  :ensure t
  :config
  (general-define-key
   :prefix "M-g"
   "g" '(avy-goto-line :which-key "avy goto line")
   "w" '(avy-goto-word-1 :which-key "avy goto word")
   "c" '(avy-goto-char :which-key "avy goto char")))

(use-package vdiff
  :ensure t)

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments a line if the region is not active, otherwise works like `comment-or-uncomment-region'."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning)
              end (region-end))
        (setq beg (line-beginning-position)
              end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(general-define-key
 "C-c ;" '(comment-or-uncomment-region-or-line :which-key "comment or uncomment region/line"))

(use-package flycheck
  :defer t
  :config
  (setq flycheck-python-flake8-executable "python"))

;; (use-package flycheck-clangcheck
;;   :ensure t
;;   :defer t
;;   :after flycheck
;;   :init
;;   (defun select-clangcheck-for-checker ()
;; 	"Select clang-check for flycheck's checker."
;; 	(flycheck-set-checker-executable 'c/c++-clangcheck
;; 									 "/usr/local/opt/llvm/bin/clang-check")
;; 	(flycheck-select-checker 'c/c++-clangcheck))
;;   :hook
;;   (c-mode . #'select-clangcheck-for-checker)
;;   (c++-mode . #'select-clangcheck-for-checker)
;;   :config
;;   (setq flycheck-clangcheck-build-path "../build"))



;; (use-package dockerfile-mode
;;   :ensure t
;;   :init
;;   (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

;; octave/MATLAB
(use-package octave
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))
  :config
  (setq octave-block-offset 4
        octave-comment-char ?%
        comment-start "%"))

(use-package snakemake-mode
  :ensure t
  :defer t)

(use-package rust-mode
  :ensure t
  :defer t)

(use-package hy-mode
  :ensure t
  :defer t)

;; slime
(use-package slime
  :ensure t
  :defer t
  :config
  (setq inferior-lisp-program "/usr/local/bin/sbcl"))

;; geiser
(use-package geiser
  :ensure t
  :defer t
  :config
  (setq geiser-active-implementations '(chicken
                                        racket
                                        guile)
        geiser-default-implementation 'chicken
        geiser-repl-query-on-kill-p nil
        geiser-repl-query-on-exit-p nil))

;; paredit
(use-package paredit
  :load-path "~/.emacs.d/third-party"
  :defer t
  :hook
  ((racket-mode . enable-paredit-mode)
   (emacs-lisp-mode . enable-paredit-mode)))

(use-package fill-function-arguments
  :ensure t
  :config
  (setq fill-function-arguments-indent-after-fill t
        fill-function-arguments-trailing-separator t))

;; (use-package scheme-complete
;;   :load-path "~/.emacs.d/third-party"
;;   :defer t
;;   :hook (racket-mode . (lambda ()
;;                               (make-local-variable 'eldoc-documentation-function)
;;                               (setq eldoc-documentation-function 'scheme-get-current-symbol-info)
;;                               (eldoc-mode)))
;;   :config
;;   (general-define-key
;;    :keymaps 'racket-mode-map
;;    "\t" (scheme-complete-or-indent)))

;; minizinc
(use-package minizinc-mode
  :ensure t
  :defer t
  :hook (minizinc-mode . (lambda ()
                           (mapc (lambda (pair) (push pair prettify-symbols-alist))
                                 '(("/\\" . ?⋀)
                                   ("\\/" . ?⋁)))))
  :init
  (add-to-list 'auto-mode-alist '("\\.mzn\\'" . minizinc-mode))
  :config
  (setq minizinc-font-lock-symbols t))

;; CMake mode
(use-package cmake-mode
  :ensure t
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("CMakeLists.txt'" . cmake-mode)))

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

(use-package wgrep
  :ensure t
  :defer t)

;; python
(use-package dap-mode
  :ensure t)
(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))
(use-package company-jedi
  :ensure t
  :defer t
  :after company
  :init
  (add-to-list 'company-backends 'company-jedi)
  :config
  (setq jedi:server-args
        '("--sys-path" "/Users/cole/miniconda3/lib/python3.8/site-packages"
          "--sys-path" "/Users/cole/miniconda3/envs/biomc/lib/python3.8/site-packages")
        jedi:environment-root '("/Users/cole/miniconda3/envs/biomc")))
(use-package anaconda-mode
  :ensure t
  :defer t
  :hook ((python-mode . anaconda-mode)
		 (python-mode . anaconda-eldoc-mode))
  :config
  (setq anaconda-mode-localhost-address "localhost"))
(use-package py-isort
  :ensure t
  :defer t
  :hook ((before-save-hook . py-isort-before-save)))
(use-package cython-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.pyx\\'" . cython-mode))
  (add-to-list 'auto-mode-alist '("\\.pyd\\'" . cython-mode))
  (add-to-list 'auto-mode-alist '("\\.pxi\\'" . cython-mode)))

;; persp-mode
(use-package perspective
  :ensure t
  :init
  (setq persp-mode-prefix-key (kbd "C-c p"))
  :config
  (persp-mode)
  (persp-new "ccsb")
  (persp-new "edylitics"))

;;; tree-fort.el ends here
