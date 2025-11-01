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
(setq doom-font (font-spec :family "PlemolJP Console NF" :size 17))
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
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Org/")
(after! org
  (setq org-hide-leading-stars nil)
  (setq org-startup-indented nil))

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

;;; 日付表記を日本語に
(setq system-time-locale "ja_JP.UTF-8")

;;; カレンダーの週の始まりを月曜日にする
(setq calendar-week-start-day 1)

;;; キーバインド
(map! :ei "C-h" #'delete-backward-char
      ;; config/default/config.elで+default/newlineと定義されているのでnilにしておく
      :i "C-j" nil

      (:after evil
       :map (evil-ex-completion-map evil-ex-search-keymap)
       "C-h" #'evil-ex-delete-backward-char)

      (:after isearch
       :map isearch-mode-map
       "C-h" #'isearch-delete-char)

      (:map minibuffer-local-map
            "C-h" #'delete-backward-char)

      (:after vertico
       :map vertico-map
       ;; completion/vertico/config.elでvertico-directory-upと定義されているので上書きする
       "C-h" #'vertico-directory-delete-char)

      (:after corfu-popupinfo
       :map corfu-popupinfo-map
       ;; config/default/+evil-bindings.elでcorfu-popupinfo-toggleと定義されているのでnilにしておく
       "C-h" nil)

      (:after vterm
       :map vterm-mode-map
       :i "C-h" #'vterm--self-insert)

      (:after skk
       :map skk-j-mode-map
       "C-h" #'skk-delete-backward-char))

;;; macOSの設定
(when (featurep :system 'macos)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs))

;;; WSLの設定
(when (featurep :system 'wsl)
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
        (cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
            browse-url-generic-args     cmd-args
            browse-url-browser-function 'browse-url-generic
            search-web-default-browser 'browse-url-generic))))

;;; Windowsの設定
(when (featurep :system 'windows)
  ;; Git for Windowsのfind.exeのPathを先頭に
  (setenv "PATH"
          (concat "c:\\Program Files\\Git\\usr\\bin;" (getenv "PATH")))
  (setq exec-path (parse-colon-path (getenv "PATH")))
  (setq migemo-dictionary (concat migemo-directory "migemo-dict")))

;;; 初期フレーム
(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(left . 500))
(add-to-list 'default-frame-alist '(top . 200))

;;; evilの挙動変更
(setq evil-split-window-below t         ; set splitbelow
      evil-vsplit-window-right t        ; set splitright
      evil-cjk-emacs-word-boundary t    ; 単語境界をEmacs互換に
      evil-disable-insert-state-bindings t)
(after! evil-escape
  (setq evil-escape-key-sequence "jk"))

;;; SKKまわりの設定
(defun +skk-activate ()
  (interactive)
  (if (bound-and-true-p skk-mode)
      (skk-kakutei)
    (skk-mode)
    ))
(map! :ei "C-j" #'+skk-activate)

;; insertモードから出るときにSKKをlatin-modeにする
(add-hook 'evil-insert-state-exit-hook
          (lambda ()
            (when (bound-and-true-p skk-mode)
              (skk-latin-mode-on))))

;; input/japanese/config.elでtext-mode-hookに挿入されているので削除する
(remove-hook 'text-mode-hook #'pangu-spacing-mode)

(after! gptel
  (setq gptel-default-mode 'org-mode)
  (setq gptel-model 'gpt-4.1)
  (setq gptel-backend (gptel-make-gh-copilot "Copilot")))

(after! org-roam
  (setq org-roam-graph-viewer (executable-find "open")))

(add-load-path! (expand-file-name "lisp/" doom-user-dir))

(use-package p2s
  :commands (p2s-post-region-to-all-services)
  :custom
  p2s-max-length 300
  :init
  (map! :leader
        :desc "Post region to all services"
        "r s" #'p2s-post-region-to-all-services))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
