;;update the dired file timling
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.


;; Use the emacschina https://emacs-china.org/

(require 'package)

;; init


(setq package-archives '(
                         ;;("myelpa" . "~/myelpa/")
                         ;; add the github for own myelpa
                         ;;("mygelpa" . "https://raw.githubusercontent.com/toranger/myelpa/master")
                         ("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")
                         ("melpa-stable" . "http://elpa.emacs-china.org/melpa-stable/")
                         ("org" . "http://elpa.emacs-china.org/org/")

                         ))
(package-initialize)

(defun require-package (package &optional min-version no-refresh)
    "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
    (if (package-installed-p package min-version)
	t
      (if (or (assoc package package-archive-contents) no-refresh)
	  (if (boundp 'package-selected-packages)
	      ;; Record this as a package the user installed explicitly
	      (package-install package nil)
	    (package-install package))
	(progn
	  (package-refresh-contents)
	  (require-package package min-version t)))))

;; use the require-package first time to init the env of
;; the package-archive-contents
(require-package 'ivy)
;; when first time to configure the local package need to use require-package
;;(mapc #'require-package
;;      (mapcar (lambda (x) (car x)) package-archive-contents))

;; also can use the https://github.com/quelpa/quelpa 
;; elpa-mirror

(add-to-list 'load-path "~/.emacs.d/elpa-mirror/")

(require 'elpa-mirror)
(setq elpamr-default-output-directory "~/myelpa")


(global-auto-revert-mode 1)
(set-language-environment "utf-8")

;;(add-to-list 'load-path "~/.emacs.d/swiper/")
(require 'ivy)
(require 'counsel)
(require 'swiper)
(ivy-mode 1)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c k") 'counsel-ag)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
;; the gocode
;; the auto-complete way in gocode
(add-to-list 'load-path "~/.emacs.d/pk")
(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)
(require 'go-mode)(add-hook 'before-save-hook 'gofmt-before-save)
(require 'gotests)

(set-face-attribute 'default nil :height 110)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)


(add-to-list 'load-path (concat (getenv "GOPATH")  "/src/github.com/golang/lint/misc/emacs"))
(require 'golint)

(setq ivy-use-virtual-buffers t
      ivy-height              12
      ivy-count-format "(%d/%d) "
      ivy-use-virtual-buffers t
      ivy-format-function 'ivy-format-function-arrow
      ;; .. .
      ivy-extra-directories nil)
(setq ffip-project-root "/data1/gostation/src/cos-config")


(setq enable-recursive-minibuffers t)
(global-set-key (kbd "M-x") 'counsel-M-x)
(setq x-select-enable-clipboard t)

;;(add-to-list 'load-path "~/.emacs.d/evil")
(global-evil-leader-mode)
(require 'evil)
(require 'evil-snipe)
(evil-mode 1)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "f" 'find-file
  "b" 'switch-to-buffer
  "k" 'kill-buffer
  "t" 'multi-term
  "s" 'save-buffer
  "d" 'dired
  "o" 'other-window
  ;;"n" 'rtags-find-symbol-at-point
  ;;"m" 'rtags-location-stack-back

  "n" 'xref-find-definitions
  "m" 'xref-pop-marker-stack
  "g" 'godef-jump
)


(global-undo-tree-mode)

;; theme ------------------
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
;;(load-theme 'solarized t)
;;(set-frame-parameter nil 'background-mode 'dark)
(load-theme 'gruvbox-dark-medium t)
(enable-theme 'gruvbox-dark-medium)
 
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(fset 'yes-or-no-p 'y-or-n-p)

;;(add-to-list 'load-path "~/.emacs.d/emacs-counsel-gtags")
;;(setq counsel-gtags-auto-update t)
(defvar hong/counsel-gtags-file-size-too-big 50)

(defun hong/counsel-gtags-find-definition-nowait (tagname)
  "werwer"
  (interactive
   (list (if (>
              (nth 7 (file-attributes
                      (concat (file-name-as-directory
                               (counsel-gtags--default-directory))
                              "GTAGS")))
              (* hong/counsel-gtags-file-size-too-big 1024 1024))
             (read-string "Pattern: " (thing-at-point 'symbol t))
           (counsel-gtags--read-tag 'definition))))
  (counsel-gtags--select-file 'definition tagname))

(defadvice counsel-gtags--collect-candidates (after hong/cgcc activate)
  (when (not ad-return-value)
    (error "No Result")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("7366916327c60fdf17b53b4ac7f565866c38e1b4a27345fe7facbf16b7a4e9e8" "b050365105e429cb517d98f9a267d30c89336e36b109a1723d95bc0f7ce8c11d" "42b9d85321f5a152a6aef0cc8173e701f572175d6711361955ecfb4943fe93af" "ed0b4fc082715fc1d6a547650752cd8ec76c400ef72eb159543db1770a27caa7" "021720af46e6e78e2be7875b2b5b05344f4e21fad70d17af7acfd6922386b61e" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(line-number-mode nil)
 '(package-selected-packages
   (quote
    (gxref company-lsp ivy-xref yasnippet gruvbox-theme ivy-hydra quelpa evil-snipe gotest golint evil-leader emamux company-go auto-complete go-eldoc go-mode treemacs git-timemachine multi-term bing-dict rainbow-delimiters smex ggtags flycheck tramp-term find-file-in-project wgrep iedit avy counsel-gtags))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'c-mode-hook 'counsel-gtags-mode)
(add-hook 'c++-mode-hook 'counsel-gtags-mode)

(with-eval-after-load 'counsel-gtags
;;  (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
  (define-key counsel-gtags-mode-map (kbd "M-t") 'hong/counsel-gtags-find-definition-nowait)
  (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
  (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
  (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward))


;;(add-to-list 'load-path "~/.emacs.d/evil-surround")
(require 'evil-surround)
;;enable flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'smex)
(smex-initialize)

(require 'window-numbering)
(window-numbering-mode 1)
(setq window-numbering-assign-func
            (lambda () (when (equal (buffer-name) "*Calculator*") 9)))

;;multi-term

(autoload 'multi-term-prev "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)
(autoload 'multi-term "multi-term" nil t)
(setq multi-term-program "/bin/bash")

(add-hook 'term-mode-hook                                                                                                                         
           (lambda ()
             ;; compatiable
             (setq-local evil-move-cursor-back nil)
             (setq-local evil-escape-inhibit t)
             ;; term
             (setq multi-term-switch-after-close nil)
             (setq multi-term-dedicated-select-after-open-p t)
             (setq multi-term-scroll-to-bottom-on-output 'others)
             (setq term-buffer-maximum-size 0)
             ;; multi-term keybinding
             (term-set-escape-char ?\C-c)
             (setq term-unbind-key-list '("C-x"))
             (setq term-bind-key-alist
                   '(("M-:" . eval-expression)
                     ("M-w" . kill-ring-save)
                     ("C-y" . term-paste)
                     ("<C-backspace>" . term-send-raw-meta)
                     ("M-d" . term-send-forward-kill-word)
                     ("M-x" . execute-extended-command)
                     ("M-]" . multi-term-next)
                     ("TAB" . (lambda () (interactive)
                                 (term-send-raw-string "\t")))
                     ("<escape>" . (lambda () (interactive)
                                      (term-send-raw-string "^[")))))
             ))


(require 'ggtags)
(setq backup-directory-alist (quote (("." . "~/.backups"))))
(defun sudo-edit (&optional arg)
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root):")))
    (let ((current-point (point)))
      (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))
      (goto-char current-point))))



;;rtags
(load-file "~/.emacs.d/rtags/src/rtags.el")
;;(set-variable rtags-path "../bin")

;; LSP 
;; the client part
(require 'ivy-xref)
(setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
(use-package ivy-xref
  :ensure t
    :init (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(add-to-list 'load-path "~/.emacs.d/emacs-lsp/lsp-mode")
(require 'lsp-mode)
(require 'company-lsp)
(push 'company-lsp company-backends)



;; the server part
;; cquery
(add-to-list 'load-path "~/.emacs.d/emacs-cquery")
(require 'cquery)

(setq cquery-executable "~/.emacs.d/cquery/build/release/bin/cquery")
(defun cquery//enable ()
  (condition-case nil
      (lsp-cquery-enable)
    (user-error nil)))

(use-package cquery
             :commands lsp-cquery-enable
                 :init (add-hook 'c-mode-common-hook #'cquery//enable))


;; YASnippet
(require 'yasnippet)
(yas-global-mode 1)
