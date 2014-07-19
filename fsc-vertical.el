;;; fsc-verti.el --- Convert string into CJK vertical writing style   -*- lexical-binding: t; -*-
;; http://en.wikipedia.org/wiki/Horizontal_and_vertical_writing_in_East_Asian_scripts
;; 就是把字串轉成直書。 縦書に文字列を変換する。
;; Copyright (C) 2014  kuanyui
;; 
;; Author: kuanyui <azazabc123@gmail.com>
;; Keywords:

(require 'cl)

(defun fsc/vertical-minibuffer (text number)
  "Rotate the text vertically from minibuffer."
  (interactive "sInput text: \nnHow many characters a line: ")
  (insert (fsc-vertical number text)))

(defun fsc/vertical-region (begin end number)
  "Rotate the text of region to vertical. Notice that the
original text will be replaced."
  (interactive "r\nnHow many characters a line: ")
  (insert (fsc-vertical number (delete-and-extract-region begin end))))

(defun fsc/vertical-region-and-copy (begin end number)
  "Rotate the text of region to vertical, and copy into kill-ring."
  (interactive "r\nnHow many characters a line: ")
  (kill-new (fsc-vertical number (buffer-substring-no-properties begin end)))
  (message "Copied."))

;; 1. Convert halfwidth to fullwidth
;; 2. Split-string by newline ("第一行" "第二行")
;; 3. Fill every string with fullwidth space to minimum mutiple of NUM. e.g. NUM=5 ("第一行　　" "第二行　　")
;; 4. Concat string, and list all characters ("第" "一" "行" "　" "　" "第" "二" "行" "　" "　")
;; 5. Send this list to `fsc-vertical--rotate-internal' to process.
;; 6. mapconcat the result, and insert spaces between each vertical lines.

(defun fsc-vertical (num text)
  (let* ((fin (mapcar (lambda (x)
                        (if (> (% (length x) num) 0)
                            (concat x (make-string (- num (% (length x) num)) (string-to-char "　")))
                          x))
                      (split-string (fsc-vertical-halfwidth-to-fullwidth text) "\n")))
         (fin (fsc-vertical--rotate-internal num
                                             (mapcar #'string
                                                     (string-to-list (apply #'concat fin))))))
    (mapconcat (lambda (x)
                 (mapconcat (lambda (y) y)
                            x " "))
               fin "\n")))

(defun fsc-vertical--rotate-internal (num string-list)
  "This function should be called by `fsc-vertical'
NUM is characters amount a line.
STRING-LIST should be a list like this (NUM = 5):
(\"第\" \"一\" \"行\" \"　\" \"　\" \"第\" \"二\" \"行\" \"　\" \"　\")"
  (mapcar (lambda (x) (reverse x))
          (loop for l from 1 to num collect ; (/ (length string-list) num) is amount of lines in final output (length of each list).
                (loop for i from 0 to (1- (/ (length string-list) num)) collect
                      (elt string-list (+ (1- l) (* i num)))))))

;; l1: 0 5 10 15 ...
;; l2: 1 6 12 16 ...
;; l3: 2 7 13 17 ...
;; l4: 3 8 14 18 ...
;; l5: 4 9 15 19 ...

;; After reversal, final output:
;; '(("第" "第")
;;   ("二" "一")
;;   ("行" "行")
;;   ("　" "　")
;;   ("　" "　"))


(defun fsc-vertical-halfwidth-to-fullwidth (text)
  ""
  (let (char)
    (mapconcat
     (lambda (x)
       (if (setq char (cdr (assoc (string x) fsc-vertical-halfwidth-to-fullwidth-table)))
           char
         (string x)))
     (string-to-list text) "")))

(setq fsc-vertical-halfwidth-to-fullwidth-table
      '((" " . "　")
        ("#" . "＃")
        ("$" . "＄")
        ("%" . "％")
        ("^" . "︿")
        ("&" . "＆")
        ("*" . "＊")
        ("/" . "／")
        ("\\" . "＼")
        ("." . "。")
        ("0" . "０")
        ("1" . "１")
        ("2" . "２")
        ("3" . "３")
        ("4" . "４")
        ("5" . "５")
        ("6" . "６")
        ("7" . "７")
        ("8" . "８")
        ("9" . "９")
        (":" . "：")
        (";" . "；")
        ("<" . "＾")
        ("=" . "＝")
        (">" . "Ｖ")
        ("?" . "？")
        ("@" . "＠")
        ("A" . "Ａ")
        ("B" . "Ｂ")
        ("C" . "Ｃ")
        ("D" . "Ｄ")
        ("E" . "Ｅ")
        ("F" . "Ｆ")
        ("G" . "Ｇ")
        ("H" . "Ｈ")
        ("I" . "Ｉ")
        ("J" . "Ｊ")
        ("K" . "Ｋ")
        ("L" . "Ｌ")
        ("M" . "Ｍ")
        ("N" . "Ｎ")
        ("O" . "Ｏ")
        ("P" . "Ｐ")
        ("Q" . "Ｑ")
        ("R" . "Ｒ")
        ("S" . "Ｓ")
        ("T" . "Ｔ")
        ("U" . "Ｕ")
        ("V" . "Ｖ")
        ("W" . "Ｗ")
        ("X" . "Ｘ")
        ("Y" . "Ｙ")
        ("Z" . "Ｚ")
        ("_" . "｜")
        ("-" . "｜")
        ("`" . "｀")
        ("a" . "ａ")
        ("b" . "ｂ")
        ("c" . "ｃ")
        ("d" . "ｄ")
        ("e" . "ｅ")
        ("f" . "ｆ")
        ("g" . "ｇ")
        ("h" . "ｈ")
        ("i" . "ｉ")
        ("j" . "ｊ")
        ("k" . "ｋ")
        ("l" . "ｌ")
        ("m" . "ｍ")
        ("n" . "ｎ")
        ("o" . "ｏ")
        ("p" . "ｐ")
        ("q" . "ｑ")
        ("r" . "ｒ")
        ("s" . "ｓ")
        ("t" . "ｔ")
        ("u" . "ｕ")
        ("v" . "ｖ")
        ("w" . "ｗ")
        ("x" . "ｘ")
        ("y" . "ｙ")
        ("z" . "ｚ")
        ("{" . "︷")
        ("|" . "－")
        ("}" . "︸")
        ("(" . "︵")
        (")" . "︶")
        ("（" . "︵")
        ("）" . "︶")
        ("「" . "﹁")
        ("」" . "﹂")
        ("【" . "︻")
        ("】" . "︼")
        ("〔" . "︹")
        ("〕" . "︺")
        ("《" . "︽")
        ("》" . "︾")
        ("〈" . "︿")
        ("〉" . "﹀")
        ("『" . "﹃")
        ("』" . "﹄")
        ("［" . "﹇")
        ("］" . "﹈")
        ))

(provide 'fsc-vertical)
