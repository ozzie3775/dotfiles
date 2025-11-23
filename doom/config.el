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
(setq! doom-font (font-spec :family "PlemolJP Console NF" :size 17))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq! doom-theme 'doom-dracula)
;; フレームの色の指定
(setq! frame-background-mode 'dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq! display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq! org-directory "~/Documents/Org/")
(after! org
  (setq! org-hide-leading-stars nil)
  (setq! org-startup-indented nil))

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

(defconst AT-OFFICE
  (file-exists-p (expand-file-name ".at-office" doom-user-dir)))

;; 終了時確認しない
(setq confirm-kill-emacs nil)

;;; 日付表記を日本語に
(setq system-time-locale "ja_JP.UTF-8")

;;; カレンダーの週の始まりを月曜日にする
(setq! calendar-week-start-day 1)

;;; macOSの設定
(when (featurep :system 'macos)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs))

;;; WSLの設定
(when (featurep :system 'wsl)
  (setq! migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
        (cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq! browse-url-generic-program  cmd-exe
             browse-url-generic-args     cmd-args
             browse-url-browser-function 'browse-url-generic
             search-web-default-browser  'browse-url-generic))))

;;; Windowsの設定
(when (featurep :system 'windows)
  ;; Git for Windowsのfind.exeのPathを先頭に
  (setenv "PATH"
          (concat "c:\\Program Files\\Git\\usr\\bin;" (getenv "PATH")))
  (setq! exec-path (parse-colon-path (getenv "PATH")))
  (setq! migemo-dictionary (concat migemo-directory "migemo-dict")))

(when (window-system)
  (cond
   ((> (display-mm-height) 270)
  ;; iMac Retina 5K 27 inch 2019 27" (5120x2880) -> 397
    (add-to-list 'default-frame-alist `(width . 160))
    (add-to-list 'default-frame-alist `(height . 60))
    (add-to-list 'default-frame-alist '(left . 500))
    (add-to-list 'default-frame-alist '(top . 0)))
   (t
    ;; MacBook Air M1 2020 13.3" (2560x1600) -> 248
    ;; MacBook Air M4 2025 13.6" (2560x1664) -> 263
    (add-to-list 'default-frame-alist `(width . 120))
    (add-to-list 'default-frame-alist `(height . 38))
    (add-to-list 'default-frame-alist '(left . 150))
    (add-to-list 'default-frame-alist '(top . 0)))
   ))

;;; evilの挙動変更
(setq! evil-split-window-below t         ; set splitbelow
       evil-vsplit-window-right t        ; set splitright
       evil-cjk-emacs-word-boundary t)   ; 単語境界をEmacs互換に
(setq! evil-disable-insert-state-bindings t)
(after! evil-escape
  (setq! evil-escape-key-sequence "jk"))

;;; SKKまわりの設定
(defun +skk-activate ()
  (interactive)
  (if (bound-and-true-p skk-mode)
      (skk-kakutei)
    (skk-mode)
    ))

;; insertモードから出るときにSKKをlatin-modeにする
(add-hook 'evil-insert-state-exit-hook
          (lambda ()
            (when (bound-and-true-p skk-mode)
              (skk-latin-mode-on))))

;; input/japanese/config.elでtext-mode-hookに挿入されているので削除する
(remove-hook 'text-mode-hook #'pangu-spacing-mode)

;;; キーバインド
(map! :ei "C-h" #'delete-backward-char
      :ei "C-j" #'+skk-activate

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

(after! gptel
  (setq! gptel-default-mode 'org-mode)
  (cond
   (AT-OFFICE
    (setq! gptel-model 'gpt-5)
    (setq! gptel-backend (gptel-make-gh-copilot "Copilot")))
   (t
    (setq! gptel-model 'gemini-flash-lite-latest)
    (setq! gptel-backend (gptel-make-gemini "Gemini" :key gptel-api-key :stream t))
    (gptel-make-anthropic "Claude" :key gptel-api-key :stream t)))
  (mapcar (apply-partially #'apply #'gptel-make-tool)
          (llm-tool-collection-get-all)))

(use-package! llm-tool-collection
  :commands llm-tool-collection-get-all)

(after! magit
  (setq +magit-open-windows-in-direction 'down))

(after! gptel-magit
  (setq! gptel-magit-commit-prompt
        (concat gptel-magit-prompt-conventional-commits
                "\n\nコメントは日本語で体言止めで出力すること")))

(after! org-roam
  (setq! org-roam-graph-viewer (executable-find "open")))

(add-load-path! (expand-file-name "lisp/" doom-user-dir))

(use-package! p2s
  :unless AT-OFFICE
  :commands p2s-post-region-to-all-services
  :custom p2s-max-length 300
  :init
  (map! :leader
        :desc "Post the region to all SNS"
        "r r" #'p2s-post-region-to-all-services
        :desc "Post the line below to all SNS"
        "r s" #'p2s-post-below-point-to-all-services))

(use-package! copilot
  :commands copilot-mode
  :bind (:map copilot-completion-map
              ("<tab>"   . 'copilot-accept-completion)
              ("TAB"     . 'copilot-accept-completion)
              ("C-TAB"   . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

(use-package! gt
  :commands (gt-translate gt-translator)
  :init
  (map! :leader
        :desc "Translate the region"
        "r t" #'gt-translate)
  :config
  (set-popup-rule! "*gt-result*" :size 0.5 :select t :quit t)
  (add-hook 'gt-buffer-render-init-hook
            (lambda ()
              (visual-line-mode 1)
              ))
  (setq! gt-debug-p t)
  (setq! gt-deepl-extra-params '(("split_sentences"     . "nonewlines")
                                 ("preserve_formatting" . "1")))
  (setq! gt-default-translator
         (gt-translator
          :taker (gt-taker :langs '(en ja) :text 'paragraph :pick nil)
          :engines (gt-deepl-engine :pro AT-OFFICE)
          :render (gt-buffer-render))))

(defun +convert-md-to-org-region (start end)
  "Convert Markdown in region to Org format using pandoc."
  (interactive "r")
  (shell-command-on-region
   start end
   "pandoc -f markdown -t org"
   t   ; output to current buffer
   t)) ; replace region

(map! :leader
      :desc "Convert Markdown to org region"
      "r o" #'+convert-md-to-org-region)
