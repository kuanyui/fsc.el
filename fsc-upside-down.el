;;; fsc-upside-down.el ---                           -*- lexical-binding: t; -*-

;; Copyright (C) 2014  kuanyui

;; Author: kuanyui <azazabc123@gmail.com>
;; Keywords:

(defmacro fsc/flip-define-region (name &rest body)
  "`str' is substring of the region."
  (list 'defun (intern (format "fsc/%s-region" name)) '(begin end)
        `(interactive "r")
        `(let ((str (buffer-substring-no-properties begin end)))
           (if str (progn (delete-region begin end)
                          (insert ,@body)
                          (message "Done."))
              (message "Error, it seems that no active region.")))))

(fsc/flip-define-region flip (fsc-flip str))
(fsc/flip-define-region flip-back (fsc-flip str t))
(fsc/flip-define-region flip-and-reverse (fsc-flip-and-reverse str))
(fsc/flip-define-region flip-and-reverse-back (fsc-flip-and-reverse str t))

(defmacro fsc/flip-define-interactively (name &rest body)
  "`str' is substring of the region."
  (list 'defun (intern (format "fsc/%s-interactively" name)) '()
        `(interactive)
        `(let ((str (read-from-minibuffer "Input text: ")))
           (if (> (length str) 0)
               (progn (insert ,@body)
                      (message "Done."))
              (message "Please input some text.")))))

(fsc/flip-define-interactively flip (fsc-flip str))
(fsc/flip-define-interactively flip-back (fsc-flip str t))
(fsc/flip-define-interactively flip-and-reverse (fsc-flip-and-reverse str))
(fsc/flip-define-interactively flip-and-reverse-back (fsc-flip-and-reverse str t))

(defun fsc-flip-and-reverse (string &optional recover-p)
  (fsc-reverse-internal
   (fsc-flip string (if recover-p
                        recover-p
                      nil))))

(defun fsc-flip (input &optional recover-p)
  "Input is string, and output is flipped one.
If recover-p is nil, a => ɐ
If recover-p is t,  ɐ => a "
  (apply #'concat
         (mapcar (lambda (char)
                   (let* ((translate-table (if recover-p
                                               (mapcar (lambda (x) (cons (cdr x) (car x)))
                                                       fsc-flip-translate-table)
                                             fsc-flip-translate-table))
                          (obj (cdr (assoc char translate-table)))) ;get the object of char.
                     (if obj               ;if obj exists in translate table
                         obj
                       char)))
                 (mapcar 'string (string-to-list input))) ; ("A" " " "q" ...)
         ))

(setq fsc-flip-translate-table
'(("a" . "ɐ")
 ("b" . "q")
 ("c" . "ɔ")
 ("d" . "p")
 ("e" . "ǝ")
 ("f" . "ɟ")
 ("g" . "ƃ")
 ("h" . "ɥ")
 ("i" . "ᴉ")
 ("j" . "ɾ")
 ("k" . "ʞ")
 ("l" . "l")
 ("m" . "ɯ")
 ("n" . "u")
 ("o" . "o")
 ("p" . "d")
 ("q" . "b")
 ("r" . "ɹ")
 ("s" . "s")
 ("t" . "ʇ")
 ("u" . "n")
 ("v" . "ʌ")
 ("w" . "ʍ")
 ("x" . "x")
 ("y" . "ʎ")
 ("z" . "z")
 ("A" . "∀")
 ("B" . "q")
 ("C" . "Ɔ")
 ("D" . "p")
 ("E" . "Ǝ")
 ("F" . "Ⅎ")
 ("G" . "פ")
 ("H" . "H")
 ("I" . "I")
 ("J" . "ſ")
 ("K" . "ʞ")
 ("L" . "˥")
 ("M" . "W")
 ("N" . "N")
 ("O" . "O")
 ("P" . "Ԁ")
 ("Q" . "Q")
 ("R" . "ɹ")
 ("S" . "S")
 ("T" . "┴")
 ("U" . "∩")
 ("V" . "Λ")
 ("W" . "M")
 ("X" . "X")
 ("Y" . "⅄")
 ("Z" . "Z")
 ("1" . "Ɩ")
 ("2" . "ᄅ")
 ("3" . "Ɛ")
 ("4" . "ㄣ")
 ("5" . "ϛ")
 ("6" . "9")
 ("7" . "ㄥ")
 ("8" . "8")
 ("9" . "6")
 ("0" . "0")
 ("!" . "¡")
 ("@" . "@")
 ("#" . "#")
 ("$" . "$")
 ("%" . "%")
 ("^" . "^")
 ("&" . "⅋")
 ("*" . "*")
 ("(" . ")")
 (")" . "(")
 ("_" . "‾")
 ("+" . "+")
 ("{" . "}")
 ("}" . "{")
 ("[" . "]")
 ("]" . "[")
 ("'" . ",")
 ("\"" . ",,")
 ("." . "˙")
 ("," . "'")))


