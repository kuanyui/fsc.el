;;; fsc-spook.el ---                                 -*- lexical-binding: t; -*-

;; Copyright (C) 2014  kuanyui
;; License: WTFPL 1.0

;;; Commentary:

;; 

;;; Code:
(require 'cl)

(when load-file-name
  (setq fsc-spook-directory (file-name-directory load-file-name)))

(defvar fsc-spook-default-count 16)

(defun fsc-spook-wheelparty ()
  (interactive)
  (if (null current-prefix-arg)
      (insert (fsc-spook-internal "wheelparty" fsc-spook-default-count))
    (insert (fsc-spook-internal "wheelparty" (string-to-int (read-from-minibuffer "How many words: "))))))

(defun fsc-spook-greatwall ()
  (interactive)
    (if (null current-prefix-arg)
      (insert (fsc-spook-internal "greatwall" fsc-spook-default-count))
    (insert (fsc-spook-internal "greatwall" (string-to-int (read-from-minibuffer "How many words: "))))))

(defun fsc-spook-internal (file num)
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
