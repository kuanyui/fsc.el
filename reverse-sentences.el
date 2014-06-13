;;; reverse-sentences.el --- 呵呵，寫著倒部全子句個整是就  -*- lexical-binding: t; -*-

;; Copyright (C) 2014  kuanyui

;; Author: kuanyui <azazabc123@gmail.com>
;; Keywords: games, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

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
