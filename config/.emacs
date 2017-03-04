;;add line numbers to each line
(global-linum-mode)

;;format line numbers to have 3 spaces for numbers, then this: ' | '
(setq linum-format "%3d \u2502 ")

;; add tab length to emacs default instead of spaces, code form Betty Wiki
 (setq c-default-style "bsd"
	   c-basic-offset 8
	   js-indent-level 2
	   tab-width 8
	   indent-tabs-mode t)

;; sets python indent to 4 tabs to pass pep8
(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode nil)
        (setq tab-width 4)
        (setq python-indent 4)))

;; add tab length from GNU Library
(setq-default tab-width 8) ; set tab width to 4 for all buffers

;; highlight lines over 80 characters
(require 'whitespace)
(setq whitespace-style '(face empty lines-tail trailing))
(global-whitespace-mode t)

;; add current column along with line in emacs
(setq column-number-mode t)

;; puppet style
(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (puppet-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
