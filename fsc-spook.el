;;; fsc-spook.el ---                                 -*- lexical-binding: t; -*-

;; Copyright (C) 2014  kuanyui
;; License: WTFPL 1.0


;;; Commentary:
;;; Code:
(require 'cl)

(when load-file-name
  (setq fsc-spook-directory (file-name-directory load-file-name)))

(defvar fsc-spook-default-count 16)

(defmacro fsc-spook-define (name)
  "Create function to insert words from spook dictionaries.
NAME is the file name, and will become the function name.
You can create a new dictionary file in plain text and place it
at spook-dict/ (under this package directory), then:
(fsc-spook-define FILENAME)"
  (list 'defun (intern (format "fsc/spook-insert-%s" name)) '()
        `(interactive)
        `(if (null current-prefix-arg)
             (insert (fsc-spook ,(format "%s" name) fsc-spook-default-count))
           (insert (fsc-spook ,(format "%s" name) (string-to-int (read-from-minibuffer "How many words: ")))))))

(fsc-spook-define wheelparty)
(fsc-spook-define greatwall)

(defun fsc-spook-encode-buffer ()
  "Use this before saving file."
  (insert
   (mapconcat (lambda (x) (format "%s" (* 689 x)))
              (string-to-list (delete-and-extract-region (point-min) (point-max)))
              " ")))

(defun fsc-spook-decode-buffer ()
  (insert
   (mapconcat (lambda (x) (string (/ (string-to-number x) 689)))
              (split-string-and-unquote (delete-and-extract-region (point-min) (point-max)) " ")
              "")))


(defun fsc-spook (file num)
  "FILE (string) is the filename in spook-dict directory.
NUM (integer) means how many words you want to get."
  (let (dict-list dict-len)
    (with-temp-buffer
      (insert-file-contents (concat fsc-spook-directory "spook-dict/" file))
      (fsc-spook-decode-buffer)
      (setq dict-len
            (length (setq dict-list (split-string-and-unquote (buffer-string) "\n")))))
    (if (> num dict-len)
        (setq num dict-len))
    (let (FIN rnd-list)
      (while (> num (length rnd-list))
        (cl-pushnew (random (1+ dict-len)) rnd-list))
      (mapcar (lambda (n)
                (setq FIN (cons (elt dict-list n) FIN)))
              rnd-list)
      (mapconcat (lambda (x) x) FIN " ")
      )))


;; Major mode for editing spook dictionary file
(defun fsc/spook-edit-open-spook-directory ()
  (interactive)
  (dired (concat fsc-spook-directory "spook-dict/")))

(defun fsc/spook-edit-start ()
  (interactive)
  (if (yes-or-no-p "Are you sure to start editing \"a spook file\"? ")
      (progn (set-buffer-file-coding-system 'utf-8-unix)
             (fsc-spook-decode-buffer)
             (if (not (eq major-mode 'fsc-spook-edit-mode))
                 (fsc-spook-edit-mode)))
    (message "Canceled.")))

(defun fsc/spook-edit-save-buffer (&optional save-for-kill-buffer)
  (interactive)
  (if (eq major-mode 'fsc-spook-edit-mode)
      (progn
        (delete-duplicate-lines (point-min) (point-max))
        (sort-lines nil (point-min) (point-max))
        (let ((whitespace-style '(empty trailing)))
          (whitespace-cleanup))
        (fsc-spook-encode-buffer)
        (save-buffer)
        (if (null save-for-kill-buffer)
            (fsc-spook-decode-buffer))
        (message (format "Wrote %s" (buffer-file-name))))
    (message "This is not a spook dictionary file. and you must to use M-x fsc/spook-edit-start first.")))

(defun fsc/spook-edit-kill-buffer ()
  (interactive)
  (if (yes-or-no-p "[fsc.el] If you want to save this spook file then close it? ")
      (fsc/spook-edit-save-buffer 'save-for-kill-buffger))
  (let (kill-buffer-query-functions) (kill-buffer (current-buffer))))
;; [FIXME][BUG]? Emacs (24.3.90.1 2014-04-13) still ask user if kill without saving.

(defcustom fsc-spook-edit-mode-hook nil
  "Normal hook run when entering fsc-spook-edit-mode."
  :type 'hook
  :group nil)

(defvar fsc-spook-edit-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-x C-s") 'fsc/spook-edit-save-buffer)
    (define-key map (kbd "C-x k") 'fsc/spook-edit-kill-buffer)
    map)
  "Keymap for editing fsc's spook file.")   ;document

(define-derived-mode fsc-spook-edit-mode nil "Spook-File"
  "Major mode for editing fsc's spook file.")


;; (load-file "~/.emacs.d/under-construction/speech-freedom/fsc-spook.el")

(provide 'fsc-spook)
;;; fsc-spook.el ends here
