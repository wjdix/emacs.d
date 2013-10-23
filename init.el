;;; init --- my emacs configs
;;; Commentary:

;;; Code:
(when (not
       (file-exists-p
        (concat user-emacs-directory "init.el.base")))
  (copy-file
   (concat user-emacs-directory "init.el")
   (concat user-emacs-directory "init.el.base")))

(require 'org-install)
(require 'ob-tangle)
(org-babel-load-file (expand-file-name "init.org" user-emacs-directory))

(setq user-full-name "William Dix")
(setq user-mail-address "william.j.dix@gmail.com")

(setenv "PATH" (concat "/opt/boxen/homebrew/bin:/usr/local/bin:/usr/local/Cellar/smlnj/110.75/libexec/bin:" (getenv "PATH")))
(setq exec-path (cons "/usr/local/Cellar/smlnj/110.75/libexec/bin" exec-path))
(setq exec-path (cons "/opt/boxen/homebrew/bin" exec-path))
(setq exec-path (cons "/Users/wdix/go/bin" exec-path))
(setenv "JAVA_HOME" "/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home")
(setenv "CLOJURESCRIPT_HOME" "/Users/wdix/src/opensource/clojure/clojurescript")

(setq erlang-root-dir "/opt/boxen/homebrew/Cellar/erlang/R15B03")
(setq exec-path (cons "/opt/boxen/homebrew/Cellar/erlang/R15B03-1/bin" exec-path))
(setq erlang-man-root-dir "/opt/boxen/homebrew/Cellar/erlang/R15B03-1/man")

(require 'cl)

(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit)))

(defvar wdix/packages '(ac-slime
                          auto-complete
                          autopair
                          clojure-mode
                          clojure-test-mode
                          coffee-mode
                          deft
                          erlang
                          flymake
                          flycheck
                          gist
                          go-mode
                          haml-mode
                          haskell-mode
                          htmlize
                          magit
                          markdown-mode
                          marmalade
                          nrepl
                          o-blog
                          org
                          paredit
                          restclient
                          rfringe
                          rspec-mode
                          rvm
                          smex
                          sml-mode
                          yaml-mode)
  "Default packages")

(defun wdix/packages-installed-p ()
  (loop for pkg in wdix/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (wdix/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg wdix/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(require 'erlang-start)
(require 'rfringe)


(defun my-erlang-mode-hook ()
  (require 'erlang-flymake)
  (require 'distel)
  (distel-setup)
  (custom-set-variables '(help-at-pt-delay 0.9) '(help-at-pt-display-when-idle '(flymake-overlay)))
  ;; when starting an Erlang shell in Emacs, default in the node name
  (setq inferior-erlang-machine-options '("-sname" "emacs"))
  ;; add Erlang functions to an imenu menu
  (imenu-add-to-menubar "imenu")
  ;; customize keys
  (local-set-key [return] 'newline-and-indent))

;; Some Erlang customizations
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

(setq inhibit-splash-screen t
      initial-scratch-message nil)

(when (locate-library "clojure-mode")
  (setq initial-major-mode 'clojure-mode))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(setq tab-width 2
      indent-tabs-mode nil)

(setq make-backup-files nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-log-done t)
(setq org-todo-keywords
      '((sequence "TODO" "INPROGRESS" "DONE")))
(setq org-todo-keyword-faces
      '(("INPROGRESS" . (:foreground "blue" :weight bold))))
(setq org-agenda-files (list "~/Dropbox/org/groupon.org"))

(require 'ob)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh . t)))

(add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))

(defvar org-babel-default-header-args:clojure
  '((:results . "silent") (:tangle . "yes")))

(defun org-babel-execute:clojure (body params)
  (lisp-eval-string body)
  "Done!")

(provide 'ob-clojure)

(setq org-src-fontify-natively t)
(setq org-confirm-babel-evaluate nil)

(setq deft-directory "~/Dropbox/deft")
(setq deft-use-filename-as-title t)
(setq deft-extension "org")
(setq deft-text-mode 'org-mode)

(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)

(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

(setq ack-prompt-for-directory t)
(setq ack-executable (executable-find "ack-grep"))

(setq column-number-mode t)

(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(require 'autopair)

(setq lisp-modes '(lisp-mode
                   emacs-lisp-mode
                   common-lisp-mode
                   scheme-mode
                   clojure-mode))

(defvar lisp-power-map (make-keymap))
(define-minor-mode lisp-power-mode "Fix keybindings; add power."
  :lighter " (power)"
  :keymap lisp-power-map
  (paredit-mode t))
(define-key lisp-power-map [delete] 'paredit-forward-delete)
(define-key lisp-power-map [backspace] 'paredit-backward-delete)

(defun wdix/engage-lisp-power ()
  (lisp-power-mode t))

(dolist (mode lisp-modes)
  (add-hook (intern (format "%s-hook" mode))
            #'wdix/engage-lisp-power))

(setq inferior-lisp-program "clisp")
(setq scheme-program-name "racket")

(add-hook 'ruby-mode-hook
          (lambda ()
            (autopair-mode)))

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)



(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

(defun coffee-custom ()
  "coffee-mode-hook"
  (make-local-variable 'tab-width)
  (set 'tab-width 2))

(add-hook 'coffee-mode-hook 'coffee-custom)

(defvar wdix/vendor-dir (expand-file-name "vendor" user-emacs-directory))
(add-to-list 'load-path wdix/vendor-dir)
(add-to-list 'load-path (expand-file-name "distel/elisp" user-emacs-directory))
(require 'distel)
(distel-setup)

(dolist (project (directory-files wdix/vendor-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-hook 'markdown-mode-hook (lambda () (visual-line-mode t)))
(setq markdown-command "pandoc --smart -f markdown -t html")
(setq markdown-css-path (expand-file-name "markdown.css" wdix/vendor-dir))
(set-keyboard-coding-system nil)

(rvm-use-default)

(setq flyspell-issue-welcome-flag nil)
(setq-default ispell-program-name "/usr/local/bin/aspell")
(setq-default ispell-list-command "list")

(require 'go-autocomplete)
(require 'auto-complete-config)
(add-to-list 'ac-modes 'go-mode)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
(add-hook 'after-init-hook #'global-flycheck-mode)

(defun run-go-tests ()
  (interactive)
  (compile "go test -v .")
  )

(defun compilation-autoclose-on-success (status code msg)
  (when (and (eq status 'exit) (zerop code))
    (bury-buffer)
    (delete-window (get-buffer-window (get-buffer "*compilation*"))))
  (cons msg code))

(add-hook 'go-mode-hook
          '(lambda ()
             (define-key go-mode-map [?\C-c ?\C-t] 'run-go-tests)
	     (setq compilation-exit-message-function
		   'compilation-autoclose-on-success)))

(provide 'init)
;;; init.el ends here

