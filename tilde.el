
;;; Code:

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(menu-bar-mode   -1) ; I like the menu bar?
(tooltip-mode    -1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Set beautiful font
(set-face-font 'default "Roboto Mono Light 13")
(setq default-frame-alist
      (append (list '(vertical-scroll-bars . nil)
                    '(font . "Roboto Mono Light 14"))))
(defface fallback '((t :family "Fira Code Light"
                       :inherit 'face-faded)) "Fallback")
(set-display-table-slot standard-display-table 'truncation
                        (make-glyph-code ?… 'fallback))
(set-display-table-slot standard-display-table 'wrap
                        (make-glyph-code ?↩ 'fallback))

;; Basic stuff to make writing code better
(electric-indent-mode        +1) ; Indent new lines like the previous
(electric-pair-mode           1) ; Matching delimiters
(auto-fill-mode               1) ; Wrap lines
(global-prettify-symbols-mode 1) ; Pretty symbols
(column-number-mode           1) ; Show column numbers

; Show Matching Parens
(setq show-paren-delay 0)
(show-paren-mode       1)

;; Disable backup files
(setq make-backup-files nil ; stop creating backup~ files
	  auto-save-default nil ; stop creating #autosave# files
	  create-lockfiles nil)

;; Blank Scratch
(setq inhibit-startup-message t
      initial-scratch-message nil)

;; Vim Mode
(use-package evil
    :ensure t
    :config (evil-mode 1))
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-nord-light t))
;; doom-modeline
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-init)
  :config
  (setq doom-modeline-buffer-file-name-style 'file-name
        doom-modeline-github nil))
;; (use-package modus-operandi-theme
;;   :ensure t
;;   :config
;;   ;; (setq modus-operandi-theme-variable-pitch-headings t
;;   ;;       modus-operandi-theme-slanted-constructs t
;;   ;;       modus-operandi-theme-bold-constructs t
;;   ;;       modus-operandi-theme-fringes 'subtle ; {nil,'subtle,'intense}
;;   ;;       modus-operandi-theme-3d-modeline t
;;   ;;       modus-operandi-theme-faint-syntax nil
;;   ;;       modus-operandi-theme-intense-hl-line t
;;   ;;       modus-operandi-theme-intense-paren-match t
;;   ;;       modus-operandi-theme-prompts 'subtle ; {nil,'subtle,'intense}
;;   ;;       modus-operandi-theme-completions 'moderate ; {nil,'moderate,'opinionated}
;;   ;;       modus-operandi-theme-subtle-diffs t
;;   ;;       modus-operandi-theme-org-blocks 'greyscale ; {nil,'greyscale,'rainbow}
;;   ;;       modus-operandi-theme-rainbow-headings t
;;   ;;       modus-operandi-theme-section-headings nil
;;   ;;       modus-operandi-theme-scale-headings nil)
;;   (load-theme 'modus-operandi t))

;; Counsel, ivy, and swiper
(use-package counsel
  :ensure t
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t
        ivy-initial-inputs-alist nil
        ivy-height 20
        ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t . ivy--regex-fuzzy))))

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
           ";"   '(eval-expression :which-key "evaluate expression")
           "."   '(counsel-find-file :which-key "find files")
           ","   '(persp-switch-to-buffer :which-key "switch buffers")
           "g"   '(magit-status :which-key "open magit")
           "bb"  '(ivy-switch-buffer :which-key "switch buffers")
           "bk"  '((lambda () (interactive) (kill-buffer (current-buffer))) :which-key "kill buffer")
           "bK"  '(kill-buffer-and-window :which-key "kill buffer and window")
           "wl"  '(windmove-right :which-key "move right")
           "wh"  '(windmove-left :which-key "move left")
           "wk"  '(windmove-up :which-key "move up")
           "wj"  '(windmove-down :which-key "move bottom")
           "w/"  '(split-window-right :which-key "split right")
           "w-"  '(split-window-below :which-key "split bottom")
           "wv"  '(split-window-horizontally :which-key "split horizontally")
           "wd"  '(delete-window :which-key "delete window")
           "wm"  '(delete-other-windows :which-key "maximize window")
	       "at"  '(ansi-term :which-key "open terminal"))
  (global-set-key (kbd "M-x") 'counsel-M-x))

;; Helpful
(use-package helpful
  :ensure t
  :defer t)

;; Magit
(use-package magit
  :ensure t
  :commands magit-status)
(use-package evil-magit
  :ensure t
  :after magit
  :config
  (evil-magit-init))

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
	 ("\\.md\\'" . gfm-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Flycheck
(use-package flycheck
  :ensure t
  :defer 2
  :hook (after-init . global-flycheck-mode)
  :config
  (setq flycheck-clang-include-path '("../include" "../inc" "../../include" "../../inc")
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
  :bind (:map company-mode-map
			  ("C-j" . company-select-next)
			  ("C-k" . company-select-previous))
  :config (company-mode +1)
  (global-company-mode +1)
  (setq company-minimum-prefix-length 2
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil))

;; Golden Ratio
(use-package golden-ratio
  :defer 2
  :ensure t
  :config
  (golden-ratio-mode 1)
  (add-to-list 'window-size-change-functions 'golden-ratio))

;;; tilde.el ends here
