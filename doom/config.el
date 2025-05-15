;;; $DOOMDIR/config.el --- config.el -*- lexical-binding: t; -*-

;;; Commentary:

;; My config.el.

;;; Code:

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
(setq doom-font (font-spec :family "PlemolJP Console NF" :size 16))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)
;; フレームの色の指定
(setq frame-background-mode 'dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Org/")

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

;; ^Hは削除であって欲しい
(keyboard-translate ?\C-h ?\C-?)

;; C-jは+bindingsで+default/newlineに上書きされているのでnilにしておく
(map! :i "C-j" nil)
;; insert modeのC-gはevil-escapeに上書きされるとSKKと相性が悪い
(map! :i "C-g" nil)

(map! :after evil-org
      :map evil-org-mode-map
      ;; C-jはlang/org/configでorg-down-elementに上書きされているのでnilにしておく
      :i "C-j" (cmds! (org-at-table-p) #'org-table-next-row nil))

;; macOS GUIで起動した場合の設定
(when (memq window-system '(mac ns))
  ;; M-RETでフルスクリーン
  ;; (bind-key "M-C-m" 'toggle-frame-fullscreen)
  ;; ドラッグアンドドロップでファイルを開く
  ;; (define-key global-map [ns-drag-file] 'ns-find-file)
  ;; MacのIMをOFFにする
  ;;(mac-input-method-mode 0)
  ;; C-jをOSに渡さない
  ;;(setq mac-pass-control-to-system nil)
  ;; CommandをMetaとして使う
  (setq ns-command-modifier 'meta)
  (setq ns-alternate-modifier 'super)
  (add-to-list 'initial-frame-alist '(width . 200))
  (add-to-list 'initial-frame-alist '(height . 50)))

(use-package! treesit
  :custom
  treesit-font-lock-level 4)

(use-package! skk
  :bind ("C-x C-j" . #'skk-mode)
  :config
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

(use-package auth-source)
(setq chatgpt-shell-anthropic-key
      (auth-source-pick-first-password :host "api.anthropic.com"))

(add-load-path! (expand-file-name "lisp/" doom-user-dir))

(use-package! p2s
  :config
  (setq p2s-max-length 300)
  (map! :leader
        :desc "Post region to all services"
        "r s" #'p2s-post-region-to-all-services))

(setq org-roam-graph-viewer (executable-find "open"))
(provide 'config)

;;; config.el ends here
;;;
;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp emacs-lisp-checkdoc)
;; End:
