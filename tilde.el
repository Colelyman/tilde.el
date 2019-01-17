
;;; Code:

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(menu-bar-mode   -1) ; I like the menu bar?
(tooltip-mode    -1)
(add-hook 'prog-mode-hook 'linum-mode)

;; Basic stuff to make writing code better
(electric-indent-mode        +1) ; Indent new lines like the previous
(electric-pair-mode           1) ; Matching delimiters
(auto-fill-mode               1) ; Wrap lines
(global-prettify-symbols-mode 1) ; Pretty symbols

; Show Matching Parens
(setq show-paren-delay 0)
(show-paren-mode       1)

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; Blank Scratch
(setq inhibit-startup-message t
      initial-scratch-message nil)

;; Vim Mode
(use-package evil
    :ensure t
    :config (evil-mode 1))
(use-package evil-escape
    :ensure t
    :init
    (setq-default evil-escape-key-sequence "jk")
    :config (evil-escape-mode 1))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))
;; doom-modeline
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-init))

;; Counsel, ivy, and swiper
(use-package counsel
  :ensure t
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t
	ivy-initial-inputs-alist nil
	ivy-height 20))

;; Smex
(use-package smex
  :ensure t
  :defer t)

;; Which Key
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " "
	which-key-prefix-prefix "+")
  :config (which-key-mode 1))

;; Custom Key Bindings
(use-package general
  :ensure t
  :config (general-define-key
	   :states '(normal visual insert emacs)
	   :prefix "SPC"
	   :non-normal-prefix "M-SPC"
	   "SPC" '(counsel-M-x :which-key "M-x")
	   ":"   '(counsel-M-x :which-key "M-x")
	   "."   '(counsel-find-file :which-key "find files")
	   ","   '(ivy-switch-buffer :which-key "switch buffers")
	   "bb"  '(ivy-switch-buffer :which-key "switch buffers")
	   "bk"  '(kill-this-buffer :which-key "kill buffer")
	   "wl"  '(windmove-right :which-key "move right")
	   "wh"  '(windmove-left :which-key "move left")
	   "wk"  '(windmove-up :which-key "move up")
	   "wj"  '(windmove-down :which-key "move bottom")
	   "w/"  '(split-window-right :which-key "split right")
	   "w-"  '(split-window-below :which-key "split bottom")
	   "wv"  '(split-window-horizontally :which-key "split horizontally")
	   "wd"  '(delete-window :which-key "delete window")
	   "wm"  '(delete-other-windows :which-key "maximize window")
	   "at"  '(ansi-term :which-key "open terminal")))

;; Helpful
(use-package helpful
  :ensure t
  :defer t)

;; Magit
(use-package magit
  :ensure t
  :commands magit-status
  :config
  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"
   "g"  '(magit-status :which-key "open magit")))
(use-package evil-magit
  :ensure t
  :defer t
  :after magit)

;; Rainbows
(use-package rainbow-delimiters
    :ensure t
    :defer 2
    :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)) ; on by default
(use-package rainbow-identifiers
    :ensure t
    :defer 2)

;; Highlight TODO and FIXME
(use-package hl-todo
  :ensure t
  :defer 2
  :config (add-hook 'prog-mode-hook #'hl-todo-mode))

;; Indent Guide
(use-package indent-guide
  :ensure t
  :defer 2
  :config (indent-guide-global-mode)) ; on by default

;; Markdown Mode
(use-package markdown-mode
  :ensure t
  :defer 2
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.txt\\'" . markdown-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Flycheck
(use-package flycheck
  :ensure t
  :defer 2
  :hook (after-init . global-flycheck-mode)
  :config (global-flycheck-mode)
  (setq flycheck-clang-include-path '("../includes" "../inc")
	flycheck-gcc-include-path flycheck-clang-include-path))

;; Web Mode
(use-package web-mode
  :defer 2
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))

;; Company
(use-package company
  :defer 2
  :ensure t
  :config (company-mode +1)
  (global-company-mode +1))

;; Golden Ratio
(use-package golden-ratio
  :defer 2
  :ensure t
  :config (golden-ratio-mode 1))

;;; tilde.el ends here
