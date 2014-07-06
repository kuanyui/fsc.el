;;; reverse-sentences.el --- 呵呵，寫著倒部全子句個整是就  -*- lexical-binding: t; -*-

;; Copyright (C) 2014  kuanyui

;; Author: kuanyui <azazabc123@gmail.com>
;; Keywords: games, tools

;; License: WTFPL 1.0
;; DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;; Version 2, December 2004
;;
;; Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
;;
;; Everyone is permitted to copy and distribute verbatim or modified
;; copies of this license document, and changing it is allowed as long
;; as the name is changed.
;;
;;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;;
;;  0. You just DO WHAT THE FUCK YOU WANT TO.
;;; Commentary:

;;; Code:
(defun fsc-reverse (begin end)
  (interactive "r")
  (let* ((input (split-string (if (and begin end)
                                  (buffer-substring-no-properties begin end)
                                (read-from-minibuffer "String: "))
                              "\n"))
         fin)
    (mapcar (lambda (x)
              (setq fin (concat fin
                                (if fin "\n")
                                (apply #'string (reverse (string-to-list x))))))
            input)
    (if (and begin end)
        (delete-region begin end))
    (insert fin)
    ))



(provide 'reverse-sentences)
;;; reverse-sentences.el ends here
