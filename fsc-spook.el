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
  (list 'defun (intern (format "fsc/spook-%s" name)) '()
        `(interactive)
        `(if (null current-prefix-arg)
             (insert (fsc-spook ,(format "%s" name) fsc-spook-default-count))
           (insert (fsc-spook ,(format "%s" name) (string-to-int (read-from-minibuffer "How many words: ")))))))

(fsc-spook-define wheelparty)
(fsc-spook-define greatwall)

(defun fsc-spook (file num)
  "FILE (string) is the filename in spook-dict directory.
NUM (integer) means how many words you want to get."
  (let (dict-list dict-len)
    (with-temp-buffer
      (insert-file-contents (concat fsc-spook-directory "spook-dict/" file))
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

;; (load-file "~/.emacs.d/under-construction/speech-freedom/fsc-spook.el")

(provide 'fsc-spook)
;;; fsc-spook.el ends here
