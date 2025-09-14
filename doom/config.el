;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setopt doom-font (font-spec :family "PlemolJP Console NF" :size 17))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setopt doom-theme 'doom-dracula)
;; フレームの色の指定
(setopt frame-background-mode 'dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setopt display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setopt org-directory "~/Documents/Org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; キーバインド
;; ^Hは削除であって欲しい
(keymap-set key-translation-map "C-h" "<DEL>")

(map! :n "H" 'centaur-tabs-backward
      :n "L" 'centaur-tabs-forward
      ;; C-jは+bindingsで+default/newlineに上書きされているのでnilにしておく
      :i "C-j" nil
      ;; insert modeのC-gはevil-escapeに上書きされるとSKKと相性が悪い
      :i "C-g" nil)

(map! :after evil-org
      :map evil-org-mode-map
      ;; C-jはlang/org/configでorg-down-elementに上書きされているのでnilにしておく
      :i "C-j" nil)

(map! :after org-keys
      :map org-mode-map
      "C-j" nil)

;; macOSの設定
(when (featurep :system 'macos)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setopt ns-command-modifier 'meta)
  (setopt ns-alternate-modifier 'super))

;; WSLの設定
(when (featurep :system 'wsl)
  (use-package! migemo
    :init
    (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"))
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
        (cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
            browse-url-generic-args     cmd-args
            browse-url-browser-function 'browse-url-generic
            search-web-default-browser 'browse-url-generic))))

(add-to-list 'default-frame-alist '(width . 180))
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(left . 500))
(add-to-list 'default-frame-alist '(top . 200))

;; evilの挙動変更
(use-package! evil
  :custom
  ; # set splitbelow
  (evil-split-window-below t)
  ; # set splitright
  (evil-vsplit-window-right t)
  ; 単語境界をEmacs互換に
  (evil-cjk-emacs-word-boundary t))

(use-package! skk
  :config
  (defun skk-activate ()
    (interactive)
    (if (bound-and-true-p skk-mode)
        (skk-kakutei)
      (skk-mode)
      ))
  (keymap-global-set "C-j" #'skk-activate)
  ;; input/japanese/config.elでaddされているhookを削除する
  (remove-hook 'doom-escape-hook #'skk-mode-exit)
  :hook
  ;; normalモードに入るときにSKKをlatin-modeにする
  (evil-normal-state-entry-hook
   . (lambda ()
       (when (bound-and-true-p skk-mode)
         (skk-latin-mode-on)))))

(use-package! pangu-spacing
  :config
  ;; input/japanese/config.elでtext-mode-hookに挿入されているので削除する
  (remove-hook 'text-mode-hook #'pangu-spacing-mode))

(after! gptel
  (setq gptel-default-mode 'org-mode)
  (setq gptel-model 'claude-sonnet-4-20250514)
  (setq gptel-backend (gptel-make-anthropic "Claude"
                        :stream t
                        :key (auth-source-pick-first-password :host "api.anthropic.com")))
  (gptel-make-gemini "Gemini"
    :stream t
    :key (auth-source-pick-first-password :host "aistudio.google.com"))
  )

(add-load-path! (expand-file-name "lisp/" doom-user-dir))

(use-package! p2s
  :custom
  p2s-max-length 300
  :config
  (map! :leader
        :desc "Post region to all services"
        "r s" #'p2s-post-region-to-all-services))

(use-package! org-roam
  :custom
  org-roam-graph-viewer (executable-find "open"))
