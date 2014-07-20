;;; fsc-garbage.el ---                                 -*- lexical-binding: t; -*-



(require 'cl)
(setq fsc-garbage-chars "`~!@#$%^&*()_+[]{}'\"|/?<>")
(setq fsc-garbage-chars-html "`~!@#$%^&*()_+[]{}'\|/?<>")

(defun fsc-garbage (text)
  (substring-no-properties
   (mapconcat
    (lambda (x)
      (concat (string x)
              (string (aref fsc-garbage-chars (random (length fsc-garbage-chars))))))
    (string-to-list text) "") 0 -1))

(defun fsc-garbage-aph (text)
  (mapconcat
   (lambda (x) (string x)) (string-to-list text) "/"))

(defun fsc-garbage-html (text)
  (replace-regexp-in-string
   "\\(\\(?:.\\|\n\\)*\\)<span style='color:#fff;'>.+?</span>$" "\\1" ;remove the last char in the output
    (mapconcat
     (lambda (line)
       (mapconcat
        (lambda (x)
          (concat (string x)
                  (concat
                   "<span style='color:#fff;'>"
                   (let ((c (string (aref fsc-garbage-chars-html (random (length fsc-garbage-chars-html))))))
                     (cond ((equal c "<") "&lt;")
                           ((equal c ">") "&gt;")
                           (t c)))
                   "</span>")))
        (string-to-list line) "")
       )
    (split-string-and-unquote text "\n") "<br>")))

(defun fsc-garbage-remove (text)
  (if (string-match "<span style='color:#fff;'>.*?</span>" text)
      (replace-regexp-in-string "<span style='color:#fff;'>.*?</span>" ""
                                (replace-regexp-in-string "<br>" "\n" text))
    (let ((fin ""))
      (do ((n 0 (+ n 2)))
          ((> n (1- (length text))) fin)
        (setq fin (concat fin (string (aref text n))))))))

(defmacro fsc-garbage-def (funcname)
  `(progn
     (defun ,(intern (concat "fsc/" funcname "-region")) (begin end)
       (interactive "r")
       (insert (,(intern (concat "fsc-" funcname)) (delete-and-extract-region begin end))))
     (defun ,(intern (concat "fsc/" funcname "-region-and-copy")) (begin end)
       (interactive "r")
       (kill-new (,(intern (concat "fsc-" funcname)) (buffer-substring-no-properties begin end)))
       (message "Copied."))
     (defun ,(intern (concat "fsc/" funcname "-minibuffer")) (text)
       (interactive "sInput text: ")
       (insert (,(intern (concat "fsc-" funcname)) text)))))

(fsc-garbage-def "garbage")
(fsc-garbage-def "garbage-aph")
(fsc-garbage-def "garbage-html")
(fsc-garbage-def "garbage-remove")

(provide 'fsc-garbage)


