;; Package manager setup.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)
;(package-refresh-contents)
; Packages to install automatically.
; TODO: Add CLI wrappers for package management?
(setq package-list '(centered-cursor-mode
                     csharp-mode
                     dash-functional
                     direx
                     dockerfile-mode
                     fish-mode
                     git-modes
                     gruvbox-theme
                     multiple-cursors
                     nord-theme
                     vimrc-mode
                     yaml-mode))
; TODO: More modes: vfli, Dockerfile, gitignore, markdown, diff ++MORE
; TODO: Code completion, navigation: imenu,helm,jedi-direx,cscope(w/ Python)
; TODO: better-defaults, use_package, focus, HideShow
; TODO: AUCTEX folding for Emacs? RefTeX ToC navigation?
; TODO: outline major/minor mode
; TODO: Common Lisp, CI-mapcar packages?
; TODO: sublimity.el?
; TODO:
; Massive coding improvements: jump-to-def, suggestions, code base search, git?
; What is LSP?
;    * elpy, elpy-enable, flycheck, autopep8/black/flake8/py-yapf, unittesting
;    * pdb debug, pynight, python-pytest, blacker, python-black, py-autopep8
;    * jedi language server
;    * magit support?
;    * pip-requirements mode, pyimport/py-isort, pydoc.
;    * Dev env EVERYTHING: linters, checkers, formatters, pytest, etc.
;    * These should be installed and configured properly by default!
;        * (install_programming) -> modular installs?
; TODO: https://emacs-lsp.github.io/lsp-mode/

;; Load custom file.
(setq custom-file "~/.config/custom.el")
(load custom-file)
; Be warned about unchanged customization when exiting.
(add-hook 'kill-emacs-query-functions
          'custom-prompt-customize-unsaved-options)

; Fetch the list of packages available.
; TODO: What is package-archive-contents?
(unless package-archive-contents
  (package-refresh-contents))
; Install missing packages.
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; Nicer modeline and minibuffer.
(load "~/.config/emacs/mini-modeline.el")
(mini-modeline-mode t)
(setq mini-modeline-r-format '(:eval (concat
  "%b >> %0l : %0c : "
  (format "%d" (/ (- (line-number-at-pos) 1) 0.01
                  (max (count-lines (point-min) (point-max)) 1)))
  "%%")))
(defun mini-modeline--set-buffer-face () ())
(setq mini-modeline-right-padding 2)

;; Custom hi-lock related configuration (interactive highlighting).
(load "~/.config/emacs/highlight.el")

;; Load repetition error finder.
(load "~/.config/emacs/highlight-repeats.el")

;; No startup/title screen.
(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq initial-major-mode 'fundamental-mode)

;; No Messages buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Kill *scratch* buffer when not needed.
(defun kill-scratch ()
  (kill-buffer "*scratch*"))
(advice-add 'direx:find-directory :after 'kill-scratch)
(advice-add 'direx:jump-to-directory :after 'kill-scratch)

(add-to-list 'custom-theme-load-path
             (expand-file-name "~/.config/emacs.d/themes/"))

;; Load Nord theme.
;(setq nord-region-highlight "snowstorm")
;(load-theme 'nord t)

;; Load Gruvbox theme.
(load-theme 'gruvbox t)
;(load-theme 'gruvbox-light-medium t)
; Make transparent where gruvbox-bg is used.
(set-face-background 'default "undefined")
(set-face-background 'fringe "undefined")
(set-face-background 'minibuffer-prompt "undefined")
;(set-face-background 'term-default-bg-color "undefined")
; https://stackoverflow.com/questions/19054228/emacs-disable-theme-background-color-in-terminal
;(defun on-after-init ()
;  (unless (display-graphic-p (selected-frame))
;    (set-face-background 'default "unspecified-bg" (selected-frame))))
;(add-hook 'window-setup-hook 'on-after-init)
;(defun on-frame-open (frame)
;  (if (not (display-graphic-p frame))
;    (set-face-background 'default "unspecified-bg" frame)))
;(on-frame-open (selected-frame))
;(add-hook 'after-make-frame-functions 'on-frame-open)

;; All the nice colors (256 Xterm):
; https://jonasjacek.github.io/colors/

;; Transform temporary buffers to temporary windows.
;(require 'popwin)
;(popwin-mode 1)
;(window-divider-mode)
;; TODO: Popwin should be configured properly.
;; TODO: Window dividers should be configured properly.

;; Load directory tree viewer.
(require 'direx)
(global-set-key (kbd "C-x j") 'direx:jump-to-directory)
(global-set-key (kbd "C-x p") 'direx-project:jump-to-project-root)
(global-set-key (kbd "C-x f") 'direx:find-directory)

;; TODO: Rename direx function for directories too?

;; Additional file creation utility for direx.
; TODO: Option to use direx in side panel?
(defun direx:create-file ()
  (interactive)
  (let* ((item (direx:item-at-point!))
         (file (direx:item-tree item))
         (parent-dir
          (if (cl-typep file 'direx:directory)
              (direx:file-full-name file)
            (direx:directory-dirname
             (direx:file-full-name file))))
         (newfile (read-directory-name "Create file: " parent-dir)))
    (when (file-exists-p newfile)
      (error "Can't create %s: file exists" newfile))
    (if (not (file-exists-p (file-name-directory newfile)))
        (make-directory (file-name-directory newfile) t))
    (write-region "" nil newfile)
    (direx:refresh-whole-tree)))
(define-key direx:direx-mode-map (kbd "F") 'direx:create-file)

;; Print the result of the `file` command.
(defun direx:file-command ()
  (interactive)
  (message (replace-regexp-in-string
            "\n$" ""
            (shell-command-to-string
             (format "file %s"
                     (direx:file-full-name
                      (direx:item-tree
                       (direx:item-at-point))))))))
(define-key direx:direx-mode-map (kbd "f") 'direx:file-command)

;; Keep cursor centered.
; TODO: Highlighting/clicking with mouse breaks centering.
(require 'centered-cursor-mode)
(global-centered-cursor-mode 1)

;; Simplify the user interface.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Custom functionality for narrowing and centering the editor.
; Options to modify the required width.
(setq editor-width 80)
(defun increase-editor-width ()
  (interactive)
  (setq editor-width (+ editor-width 20))
  (my-resize-margins)
  (message (concat "Editor width: " (number-to-string editor-width))))
(defun decrease-editor-width ()
  (interactive)
  (setq editor-width (- editor-width 20))
  (my-resize-margins)
  (message (concat "Editor width: " (number-to-string editor-width))))
; TODO: Also set key binding for toggling line wrapping.
(global-set-key (kbd "C-c <right>") 'increase-editor-width)
(global-set-key (kbd "C-C <left>") 'decrease-editor-width)

; The hooks and default settings.
(defun ideal-margin-size ()
  ; TODO: Fix the calculation to ensure 80 chars even with odd frame-width.
  (max (ceiling (/ (- (frame-width) editor-width) 2)) 0))
(defun my-resize-margins ()
  (interactive)
  (set-window-margins (frame-root-window)
                      (ideal-margin-size) (ideal-margin-size)))
(add-hook 'window-configuration-change-hook 'my-resize-margins)
(add-hook 'window-size-change-functions 'my-resize-margins)
(add-hook 'window-buffer-change-functions 'my-resize-margins)
(add-hook 'window-setup-hook 'my-resize-margins)
; Also bind to the window size change signal.
; TODO: This does not work at first window change?
(global-set-key [signal winch] 'my-resize-margins)
(my-resize-margins)

;; Move all backups to separate folder.
; TODO: Script to regularly delete backups.
(setq backup-dir "~/.local/share/emacs-backups/")
(when (not (file-directory-p backup-dir))
  (make-directory backup-dir t))
(setq backup-directory-alist `(("." . ,backup-dir))
      auto-save-file-name-transforms `((".*" ,backup-dir t))
      auto-save-list-file-prefix (concat backup-dir ".saves-"))
(setq backup-by-copying t
      delete-old-versions t
      version-control t
      kept-new-versions 5
      kept-old-versions 2)

;; Kill buffers with simple key combination.
(global-set-key (kbd "C-x k") 'kill-current-buffer)
;; Always ask when exiting emacs. Prefer to kill individual buffers.
(setq confirm-kill-emacs 'y-or-n-p)
;; Enable using 'y' or 'n' for prompts in general.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Highlight current line.
;; Disabled because of personal preference.
;; The current line is always in the center anyways.
;; There is also an option to have "crosshair" highlights.
;(global-hl-line-mode t)

;; Disable the Insert button (overwrite mode).
(global-set-key (kbd "<insertchar>") nil)

;; Use system clipboard.
; Source: https://gist.github.com/yorickvP/6132f237fbc289a45c808d8d75e0e1fb
; Similar to: https://www.emacswiki.org/emacs/xclip.el
; TODO: Fix when pasting over selection.
; TODO: Fix this, processes sometimes don't exit!
; TODO: Move this part to a .d directory, to be replaceable w/ X-based copy!
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil
    (shell-command-to-string "wl-paste -n")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

;; Enable basic in-terminal mouse support.
(xterm-mouse-mode 1)

;; Multiple cursors.
(require 'multiple-cursors)
; Set multiple fake cursors then enter multicursor mode.
(defun mc/toggle-cursor-at-point ()
  (interactive)
  (if multiple-cursors-mode
      (message (concat "Cannot toggle cursor at point "
                       "while `multiple-cursors-mode' is active."))
    (let ((existing (mc/fake-cursor-at-point)))
      (if existing
          (mc/remove-fake-cursor existing)
        (mc/create-fake-cursor-at-point)))))
(add-to-list 'mc/cmds-to-run-once 'mc/toggle-cursor-at-point)
(add-to-list 'mc/cmds-to-run-once 'multiple-cursors-mode)
(global-unset-key (kbd "C-x m"))
(global-set-key (kbd "C-x m c") 'mc/toggle-cursor-at-point)
(global-set-key (kbd "C-x m RET") 'multiple-cursors-mode)
(global-set-key (kbd "C-x m r") 'mc/edit-lines)
; So that hitting enter doesn't quit multicursor mode,
; just inserts a newline character.
(define-key mc/keymap (kbd "RET") nil)

;; Ignore case when searching by default.
(setq case-fold-search t)
(setq case-replace t)

;; Highlight mismatching parentheses.
;; Disabled due to performance reasons.
; TODO: Button to highlight matching parentheses.
;(require 'paren)
;(setq show-paren-style 'parenthesis)
;(show-paren-mode +1)

;; Quick utility to get current line length.
;; Used in other places, like the modeline.
(defun curr-line-len ()
  (- (line-end-position)
     (line-beginning-position)))

;; Disable auto here mode completion.
(add-hook 'sh-mode-hook
  (lambda ()
    (sh-electric-here-document-mode -1)))

;; Disable smart quotes.
(defun never-smart-quote ()
  (local-unset-key "\""))
(add-hook 'latex-mode-hook 'never-smart-quote)

;; Scroll half a page (screen).
(defun window-half-height ()
  (max 1 (/ (1- (window-height (selected-window))) 2)))
(defun scroll-up-half () (interactive)
  (forward-line (* (window-half-height) -1)))
(global-set-key (kbd "C-U") 'scroll-up-half)
(defun scroll-down-half () (interactive)
  (forward-line (window-half-height)))
(global-set-key (kbd "C-D") 'scroll-down-half)

;; Disable TAB indentation.
(setq-default indent-tabs-mode nil)

;; Use a better word skip function.
;; This skips words but stops around symbols.
(defun improved-forward (&optional arg)
  (interactive "^p")
  (if (> arg 0)
      (dotimes (_ arg)
        (when (looking-at-p "[ \t]")
          (skip-chars-forward " \t"))
        (unless (= (point) (point-max))
          (forward-same-syntax)))
    (dotimes (_ (- arg))
      (when (looking-back "[ \t]")
        (skip-chars-backward " \t"))
      (unless (= (point) (point-min))
        (forward-same-syntax -1)))))
(defun improved-backward (&optional arg)
  (interactive "^p")
  (improved-forward (- arg)))
(global-set-key (kbd "M-f") 'improved-forward)
(global-set-key (kbd "M-b") 'improved-backward)
;; TODO: Bind original skip function to other keys.
;; TODO: Swap Ctrl+F/B (char) and Alt+F/B (word)?

;; Auto-compile using xelatex.
(defun call-xelatex ()
  (interactive)
  (save-window-excursion
    (async-shell-command (concat "xelatex " (buffer-file-name)))))
(add-hook 'latex-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'call-xelatex)))

;; Use 4 space indentation for C-like languages (C, C++, Java).
(setq-default c-basic-offset 4)

;; Version control options.
(setq vc-follow-symlinks t)

;; Use gitignore for other filenames too.
(add-to-list 'auto-mode-alist
             (cons "/gitignore\\'" 'gitignore-mode)
             (cons "/.dockerignore\\'" 'gitignore-mode))

;; vimrc mode
(require 'vimrc-mode)
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; TODO: When : is pressed interpret common vim commands
;;       Such as wq, q!, w, q, etc.

; TODO: Ctrl+K shouldn't copy only whitespace lines.
; TODO: Ctrl+K shouldn't delete newline when only whitespace line.
; TODO: Improved undo/redo functionality + easier to do multiple times!
; TODO: Disable typrographical punctuation marks!
; TODO: Revise what should be (interactive).
; TODO: Auto-format like untabify (trailing whitspace, CLRF, tabs, final \n)
; TODO: Disable annoying "smart" autoindent...
; TODO: Handle *.bak, *.inc files like their root file formats!
; TODO: Check user inputs with custom scripts / functions.
; TODO: local-set-key <-> global, let <-> setq <-> defvar
; TODO: Remove not-required and redundant keyboard shortcuts.
; TODO: Byte compile more things?
; TODO: Rename functions with "mine" and "my" in name...
; TODO: Should I use the emacs daemon?
; TODO: Don't jump to indent end when indenting a line with content after it.
