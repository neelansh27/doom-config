;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Neelansh Sharma"
      user-mail-address "neelanshsharma30@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-gruvbox
doom-font (font-spec :family "JetBrains Mono" :size 14 :weight 'medium))
(setq display-line-numbers-type t)
(setq doom-unicode-font (font-spec :family "Iosevka Nerd Font" :size 14))
(setq org-directory "~/org/")

(remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)

;;TREE-SITTER
(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;;KEYBINDINGS

(map! :leader :desc "nil" "SPC" nil)
(map! :leader :prefix ("r"."run")
               (:desc "run python" "p" #'run-python)
               (:desc "run eshell" "e" #'eshell)
               (:desc "run ansi-term" "a" #'ansi-term)
               (:desc "run vterm" "v" #'+vterm/here))

;; EMMS CONFIGURATION
(use-package emms
  :config
    (require 'emms-setup)
    (require 'emms-player-mpd)
    (emms-all) ; don't change this to values you see on stackoverflow questions if you expect emms to work
    (setq emms-player-list '(emms-player-mpd))
    (add-to-list 'emms-info-functions 'emms-info-mpd)
    (add-to-list 'emms-player-list 'emms-player-mpd)

    (setq emms-player-mpd-server-name "localhost")
    (setq emms-player-mpd-server-port "6600")
    (setq emms-player-mpd-music-directory "~/Music"))
(map! :prefix ("C-c"."applications")
      (:prefix ("m"."emms")
       (:desc "start emms" "s" #'emms-player-mpd-connect)
       (:desc "stop emms" "S" #'emms-stop)
       (:desc "play-pause track" "p" #'emms-pause)
       (:desc "see playlist" "P" #'emms-playlist-mode-go-popup)
       (:desc "seek 10s forward" "l" #'emms-seek-forward)
       (:desc "seek 10s backward" "h" #'emms-seek-backward)
       (:desc "shuffle playlist" "z" #'emms-shuffle)
       (:desc "emms next track" "k" #'emms-next)
       (:desc "emms previous track" "j" #'emms-previous)))

(map! :prefix ("M-s")
      (:desc "yas snippet expand" "M-s" #'yas-expand)
      (:desc "yas snippet expand" "M-e" #'company-yasnippet))
(evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-up-directory
      "l" 'dired-find-alternate-file)
;; COMPANY MODE SETTINGS
(setq company-dabbrev-downcase 0)
(setq company-idle-delay 0)
;; (setq company-backends '((company-capf company-yasnippet company-dabbrev-code company-files)))
(yas-global-mode 1)
(setq! +lsp-company-backends '(:separate company-yasnippet company-capf))
(add-hook 'yas-minor-mode-hook (lambda() (yas-activate-extra-mode 'fundamental-mode)))
(remove-hook 'eshell-mode-hook 'company-mode)
;;MODE SETTINGS
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(add-hook 'html-mode-hook (lambda() (emmet-mode 1)))
(add-hook 'after-init-hook #'global-prettier-mode)

;; (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.s?css?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . js2-jsx-mode))
(add-hook 'js2-jsx-mode-hook #'lsp)
(add-hook 'web-mode-hook 'rainbow-mode)
(add-hook 'web-mode-hook #'lsp)
(add-hook 'web-mode-hook #'emmet-mode)
(add-hook 'web-mode-hook #'prettier-mode)
;;lsp
;; (add-hook 'lsp-mode-hook (lambda () (lsp-headerline-breadcrumb-mode 1)))
(add-hook 'mhtml-mode-hook #'lsp)
(add-hook 'css-mode-hook #'lsp)
(add-hook 'rjsx-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp)
;;prerequisites
;;pip3 install jedi autopep8 flake8 ipython yapf importmagic
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")
;; (define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
;;   (lambda () (rainbow-mode 1)))
;; (my-global-rainbow-mode 1)

(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
(use-package! org-superstar
    :after org
    :hook (org-mode . org-superstar-mode)
    :config
      (set-face-attribute 'org-superstar-header-bullet nil :inherit 'fixed-pitched :height 120)
    :custom
    ;; set the leading bullet to be a space. For alignment purposes I use an em-quad space (U+2001)
    (org-superstar-headline-bullets-list '(""))
    (org-superstar-todo-bullet-alist '(("DONE" . ?✔)
                                       ("TODO" . ?⌖)
                                       ("ISSUE" . ?)
                                       ("BRANCH" . ?)
                                       ("FORK" . ?)
                                       ("MR" . ?)
                                       ("MERGED" . ?)
                                       ("GITHUB" . ?A)
                                       ("WRITING" . ?✍)
                                       ("WRITE" . ?✍)
                                       ))
    (org-superstar-special-todo-items t)
    (org-superstar-leading-bullet "")
    )
;;BRACKET PAIRING
(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
(global-set-key (kbd "M-'") 'insert-pair)
(global-set-key (kbd "M-)") 'delete-pair)
(global-set-key (kbd "M-}") 'delete-pair)
(global-set-key (kbd "M-]") 'delete-pair)
