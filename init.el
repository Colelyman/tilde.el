;; Collect *ALL* the garbage
(setq gc-cons-threshold 100000000)

;; Collect slightly less garbage while running to improve performance
(add-hook 'after-init-hook
    (lambda ()
        (setq gc-cons-threshold 400000)))

(setenv "LIBRARY_PATH" "/usr/local/Cellar/gcc/10.2.0_4/lib/gcc/10:/usr/local/Cellar/gcc/10.2.0_4/lib/gcc/10/gcc/x86_64-apple-darwin19/10.2.0:${LIBRARY_PATH:-")
(setq comp-deferred-compilation t
      comp-speed 2)

;; Package configs
(require 'package)
(setq package-enable-at-startup nil
      package-quickstart t)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
;; (package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
(require 'use-package)

;; Load the config
(load "~/.emacs.d/tilde.el")

;; If tree-fort.el exists import it. Use tree-fort.el for personal config stuff
(when (file-exists-p "~/.emacs.d/tree-fort.el")
    (load "~/.emacs.d/tree-fort.el"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline success warning error])
 '(custom-safe-themes
   '("e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "5d09b4ad5649fea40249dd937eaaa8f8a229db1cec9a1a0ef0de3ccf63523014" "edcd202975c4af18d0bbc4a2654f6e6ea604fe43f02ce795af19ddbb0b085887" "55257ccc6763185dde2146bcc5aa2b83130cc55042c45daaf5efe3c3137b578f" "c8f959fb1ea32ddfc0f50db85fea2e7d86b72bb4d106803018be1c3566fd6c72" "4a9f595fbffd36fe51d5dd3475860ae8c17447272cf35eb31a00f9595c706050" "7d56fb712ad356e2dacb43af7ec255c761a590e1182fe0537e1ec824b7897357" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "70ed3a0f434c63206a23012d9cdfbe6c6d4bb4685ad64154f37f3c15c10f3b90" "fe666e5ac37c2dfcf80074e88b9252c71a22b6f5d2f566df9a7aa4f9bea55ef8" "10461a3c8ca61c52dfbbdedd974319b7f7fd720b091996481c8fb1dded6c6116" "49ec957b508c7d64708b40b0273697a84d3fee4f15dd9fc4a9588016adee3dad" "d2e9c7e31e574bf38f4b0fb927aaff20c1e5f92f72001102758005e53d77b8c9" "6d589ac0e52375d311afaa745205abb6ccb3b21f6ba037104d71111e7e76a3fc" "14de8f58ad656af5be374086ae7ab663811633fc1483a02add92f7a1ff1a8455" "ecba61c2239fbef776a72b65295b88e5534e458dfe3e6d7d9f9cb353448a569e" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default))
 '(ein:output-area-inlined-images t)
 '(elpy-modules
   '(elpy-module-company elpy-module-eldoc elpy-module-flymake elpy-module-pyvenv elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults))
 '(elpy-rpc-python-command "/Users/cole/miniconda3/bin/python")
 '(flycheck-flake8rc "/Users/cole/.config/flake8")
 '(flymake-error-bitmap '(flymake-double-exclamation-mark modus-theme-fringe-red))
 '(flymake-note-bitmap '(exclamation-mark modus-theme-fringe-cyan))
 '(flymake-warning-bitmap '(exclamation-mark modus-theme-fringe-yellow))
 '(highlight-tail-colors '(("#aecf90" . 0) ("#c0efff" . 20)))
 '(hl-todo-keyword-faces
   '(("HOLD" . "#70480f")
     ("TODO" . "#721045")
     ("NEXT" . "#5317ac")
     ("THEM" . "#8f0075")
     ("PROG" . "#00538b")
     ("OKAY" . "#30517f")
     ("DONT" . "#315b00")
     ("FAIL" . "#a60000")
     ("BUG" . "#a60000")
     ("DONE" . "#005e00")
     ("NOTE" . "#863927")
     ("KLUDGE" . "#813e00")
     ("HACK" . "#813e00")
     ("TEMP" . "#5f0000")
     ("FIXME" . "#a0132f")
     ("XXX+" . "#972500")
     ("REVIEW" . "#005a5f")
     ("DEPRECATED" . "#201f55")))
 '(ibuffer-deletion-face 'modus-theme-mark-del)
 '(ibuffer-filter-group-name-face 'modus-theme-mark-symbol)
 '(ibuffer-marked-face 'modus-theme-mark-sel)
 '(ibuffer-title-face 'modus-theme-header)
 '(package-selected-packages
   '(dap-mode python-mode transpose-frame w3m vdiff esup org-superstar wttrin wgrep cython-mode csv-mode dockerfile-mode org-roam elpy fill-function-arguments org hyperbole py-isort perspective git-gutter-fringe hy-mode nim-mode rust-mode ein snakemake-mode writeroom-mode evil-multiedit company-lsp lsp-ui slime evil-anzu nord-theme company-pollen pollen-mode elpher avy ripgrep auto-yasnippet auctex minizinc-mode racket-mode geiser notmuch interleave dumb-jump flx ess cmake-mode flycheck-clangcheck projectile evil-surround anaconda-mode company-jedi company-c-headers company-irony irony evil-magit doom-themes emacs-doom-themes doom-modeline solarized-theme exec-path-from-shell org-ref smex magit helpful counsel ivy golden-ratio company web-mode flycheck markdown-mode indent-guide hl-todo rainbow-identifiers rainbow-delimiters general which-key helm evil-escape evil use-package))
 '(tramp-password-prompt-regexp
   "^.*\\(\\(?:adgangskode\\|contrase\\(?:\\(?:ny\\|\303\261\\)a\\)\\|geslo\\|h\\(?:\\(?:as\305\202\\|esl\\)o\\)\\|iphasiwedi\\|jelsz\303\263\\|l\\(?:ozinka\\|\303\266senord\\)\\|m\\(?:ot de passe\\|\341\272\255t kh\341\272\251u\\)\\|pa\\(?:rola\\|s\\(?:ahitza\\|s\\(?: phrase\\|code\\|ord\\|phrase\\|wor[dt]\\)\\|vorto\\)\\)\\|s\\(?:alasana\\|enha\\|lapta\305\276odis\\)\\|verification code\\|wachtwoord\\|\320\273\320\276\320\267\320\270\320\275\320\272\320\260\\|\320\277\320\260\321\200\320\276\320\273\321\214\\|\327\241\327\241\327\236\327\224\\|\331\203\331\204\331\205\330\251 \330\247\331\204\330\263\330\261\\|\340\244\227\340\245\201\340\244\252\340\245\215\340\244\244\340\244\266\340\244\254\340\245\215\340\244\246\\|\340\244\266\340\244\254\340\245\215\340\244\246\340\244\225\340\245\202\340\244\237\\|\340\246\227\340\247\201\340\246\252\340\247\215\340\246\244\340\246\266\340\246\254\340\247\215\340\246\246\\|\340\246\252\340\246\276\340\246\270\340\246\223\340\247\237\340\246\276\340\246\260\340\247\215\340\246\241\\|\340\250\252\340\250\276\340\250\270\340\250\265\340\250\260\340\250\241\\|\340\252\252\340\252\276\340\252\270\340\252\265\340\252\260\340\253\215\340\252\241\\|\340\254\252\340\255\215\340\254\260\340\254\254\340\255\207\340\254\266 \340\254\270\340\254\231\340\255\215\340\254\225\340\255\207\340\254\244\\|\340\256\225\340\256\237\340\256\265\340\257\201\340\256\232\340\257\215\340\256\232\340\257\212\340\256\262\340\257\215\\|\340\260\270\340\260\202\340\260\225\340\261\207\340\260\244\340\260\252\340\260\246\340\260\256\340\261\201\\|\340\262\227\340\263\201\340\262\252\340\263\215\340\262\244\340\262\252\340\262\246\\|\340\264\205\340\264\237\340\264\257\340\264\276\340\264\263\340\264\265\340\264\276\340\264\225\340\265\215\340\264\225\340\265\215\\|\340\266\273\340\267\204\340\267\203\340\267\212\340\266\264\340\266\257\340\266\272\\|\341\236\226\341\236\266\341\236\200\341\237\222\341\236\231\341\236\237\341\236\230\341\237\222\341\236\204\341\236\266\341\236\217\341\237\213\\|\343\203\221\343\202\271\343\203\257\343\203\274\343\203\211\\|\345\257\206[\347\240\201\347\242\274]\\|\354\225\224\355\230\270\\)\\).*: ? *")
 '(tramp-ssh-controlmaster-options
   "-o ControlPath=~/.ssh/cm-%%r@%%h:%%p -o ControlMaster=auto -o ControlPersist=yes" t)
 '(vc-annotate-background-mode nil)
 '(warning-suppress-log-types '((comp) (:warning)))
 '(xterm-color-names
   ["#000000" "#a60000" "#005e00" "#813e00" "#0030a6" "#721045" "#00538b" "#f0f0f0"])
 '(xterm-color-names-bright
   ["#505050" "#972500" "#315b00" "#70480f" "#223fbf" "#8f0075" "#30517f" "#ffffff"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
