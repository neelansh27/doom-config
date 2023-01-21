(setq user-full-name "Neelansh Sharma"
      user-mail-address "neelanshsharma30@gmail.com")
;;"<=" ">="
(setq doom-theme 'doom-tokyo-night
doom-font (font-spec :family "CaskaydiaCove Nerd Font" :size 23 :weight 'semi-bold))
(setq display-line-numbers-type t)
(setq doom-unicode-font (font-spec :family "FontAwesome" :size 26))
(set-language-environment "UTF-8")
(defconst caskaydiacove-ligature-mode--ligatures
   '("-->" "//" "/**" "/*" "*/" "<!--" ":=" "->>" "<<-" "->" "<-"
     "<=>" "==" "!="  "=:=" "!==" "&&" "||" "..." ".."
     "|||" "///" "&&&" "==="  "++" "--" "=>" "|>" "<|" "||>" "<||"
     "|||>" "<|||" ">>" "<<" "::=" "|]" "[|" "{|" "|}"
     "[<" ">]" ":?>" ":?" "/=" "[||]" "!!" "?:" "?." "::"
     "+++" "??" "###" "##" ":::" "####" ".?" "?=" "=!=" "<|>"
     "<:" ":<" ":>" ">:" "<>" ";;" "/==" ".=" ".-" "__"
     "=/=" "<-<" "<<<" ">>>" "<=<" "<<=" "<==" "<==>" "==>" "=>>"
     ">=>" ">>=" ">>-" ">-" "<~>" "-<" "-<<" "=<<" "---" "<-|"
     "<=|" "/\\" "\\/" "|=>" "|~>" "<~~" "<~" "~~" "~~>" "~>"
     "<$>" "<$" "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</>" "</" "/>"
     "<->" "..<" "~=" "~-" "-~" "~@" "^=" "-|" "_|_" "|-" "||-"
     "|=" "||=" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#=" "----"
     "&="))
(defun caskaydiacove-ligature-mode--make-alist (list)
   "Generate prettify-symbols alist from LIST."
   (let ((idx -1))
     (mapcar
      (lambda (s)
        (setq idx (1+ idx))
        (if s
            (let* ((code (+ #X10001 idx))
                   (width (string-width s))
                   (prefix ())
                   (suffix '(?\s (Br . Br)))
                   (n 1))
              (while (< n width)
                (setq prefix (append prefix '(?\s (Br . Bl))))
                (setq n (1+ n)))
              (cons s (append prefix suffix (list (decode-char 'ucs code)))))))
      list)))
(defvar caskaydiacove-ligature-mode--old-prettify-alist)
(sort caskaydiacove-ligature-mode--ligatures (lambda (x y) (> (length x) (length y))))
(dolist (pat caskaydiacove-ligature-mode--ligatures)
  (set-char-table-range composition-function-table
                      (aref pat 0)
                      (nconc (char-table-range composition-function-table (aref pat 0))
                             (list (vector (regexp-quote pat)
                                           0
                                    'compose-gstring-for-graphic)))))
(defun caskaydiacove-ligature-mode--enable ()
    "Enable JetBrains Mono ligatures in current buffer."
    (setq-local caskaydiacove-ligature-mode--old-prettify-alist prettify-symbols-alist)
       (setq-local prettify-symbols-alist (append (caskaydiacove-ligature-mode--make-alist caskaydiacove-ligature-mode--ligatures) caskaydiacove-ligature-mode--old-prettify-alist))
       (prettify-symbols-mode t))

(defun caskaydiacove-ligature-mode--disable ()
    "Disable JetBrains Mono ligatures in current buffer."
    (setq-local prettify-symbols-alist caskaydiacove-ligature-mode--old-prettify-alist)
    (prettify-symbols-mode -1))

(define-minor-mode caskaydiacove-ligature-mode
    "JetBrains Mono ligatures minor mode"
    :lighter "CaskaydiaCove Nerd Font"
    (setq-local prettify-symbols-unprettify-at-point 'right-edge)
    (if caskaydiacove-ligature-mode
        (caskaydiacove-ligature-mode--enable)
      (caskaydiacove-ligature-mode--disable)))
(provide caskaydiacove-ligature-mode)

(set-frame-parameter (selected-frame) 'alpha-background 93)
(add-to-list 'default-frame-alist '(alpha 93 93))
;; (set-frame-parameter nil 'alpha-background 100) ; For current frame
;; (add-to-list 'default-frame-alist '(alpha-background . 100)) ; For all new frames henceforth

(setq fancy-splash-image (concat doom-private-dir "dp.png"))

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-<mouse-1>") #'mc/add-cursor-on-click)

(use-package! tree-sitter
  :config
  (global-tree-sitter-mode)
  (require 'tree-sitter-langs)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
(add-hook 'mhtml-mode-hook (lambda() (tree-sitter-mode -1)))

(use-package emms
  :config
    (require 'emms-setup)
    (require 'emms-player-mpd)
    (emms-all)
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

(yas-global-mode 1)
(setq company-dabbrev-downcase 0)
(setq company-idle-delay 0)
(setq! +lsp-company-backends '(:separate company-yasnippet company-capf))
(add-hook 'yas-minor-mode-hook (lambda() (yas-activate-extra-mode 'fundamental-mode)))
(setq company-frontends '(company-pseudo-tooltip-frontend
                          company-echo-metadata-frontend))
(remove-hook 'eshell-mode-hook 'company-mode)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-up-directory
      "l" 'dired-find-alternate-file)

(add-hook 'css-mode-hook #'lsp)
(add-hook 'rjsx-mode-hook #'lsp)
(add-hook 'web-mode-hook #'lsp)
(add-hook 'web-mode-hook 'rainbow-mode)
(add-hook 'web-mode-hook #'prettier-mode)
(add-hook 'mhtml-mode-hook #'prettier-mode)
(add-hook 'mhtml-mode-hook #'lsp)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . mhtml-mode))

(add-hook 'emmet-mode-hook (lambda() (local-set-key (kbd "<C-return>") 'emmet-expand-line)))
(add-hook 'rjsx-mode-hook #'emmet-mode)
(add-hook 'web-mode-hook #'emmet-mode)

(add-hook 'python-mode-hook #'lsp)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(setq large-file-warning-threshold 100000000)

(use-package lsp-mode
  :custom
  (lsp-headerline-breadcrumb-enable t))

(setq dap-auto-configure-features '(sessions locals controls tooltip))
(require 'dap-firefox)
(require 'dap-node)
(setq dap-python-executable "python3")
(setq dap-python-debugger 'debugpy)
(require 'dap-python)

(use-package! org
  :config
  (setq org-hide-emphasis-markers t))
(setq org-directory "~/Programs/Org/")
(dolist (face '((org-level-1 . 1.3)
                (org-level-2 . 1.2)
                (org-level-3 . 1.1)
                (org-level-4 . 1.1)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
(set-face-attribute (car face) nil :font "OpenSans"  :weight 'semi-bold :height (cdr face)))

(use-package! org-superstar
    :after org
    :hook (org-mode . org-superstar-mode)
    :config
      (set-face-attribute 'org-superstar-header-bullet nil  :height 180))
(with-eval-after-load 'org-superstar
  (setq org-superstar-item-bullet-alist
        '((?* . ?▷)
          (?+ . ?▷)
          (?- . ?➤))))
(setq org-return-follows-link t)
(setq org-ellipsis " ▼ ")
(setq org-image-actual-width nil)

(map! :leader :desc "nil" "SPC" nil)
(map! :leader :prefix ("r"."run")
               (:desc "run python" "p" #'run-python)
               (:desc "run eshell" "e" #'eshell)
               (:desc "run ansi-term" "a" #'ansi-term)
               (:desc "run vterm" "v" #'+vterm/here))

(map! :prefix ("M-s")
      (:desc "yas snippet expand" "M-s" #'yas-expand)
      (:desc "yas snippet expand" "M-e" #'company-yasnippet))

(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
(global-set-key (kbd "M-'") 'insert-pair)
(global-set-key (kbd "M-)") 'delete-pair)
(global-set-key (kbd "M-}") 'delete-pair)
(global-set-key (kbd "M-]") 'delete-pair)

(setq confirm-kill-emacs nil)
