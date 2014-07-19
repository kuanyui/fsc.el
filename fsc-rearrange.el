;;FSC - Fuck the Speeching Censorship

(require 'cl)

(defun fsc/rearrange-region (begin end)
  (interactive "r")
  (insert (fsc-rearrange (delete-and-extract-region begin end))))

(defun fsc/rearrange-region-and-copy (begin end)
  "Won't change the original text."
  (interactive "r")
  (kill-new (fsc-rearrange (buffer-substring-no-properties begin end)))
  (message "Copied."))

(defun fsc/rearrange-minibuffer (text)
  (interactive "sInput text: ")
  (if (> (length text) 0)
        (insert (fsc-rearrange text))
      (message "Please input some text.")))

(defun fsc-rearrange-random-intergers-list (range-max)
  "input should be an interger, and output a list which elements are out of order.
Index from 1.
For example: input is 7, output is like (5 2 6 7 4 3 1)."
  (loop with fin = nil
        for x = (random range-max)
        for len = (length fin)
        when (and (> x 0)
                  (< len range-max)
                  (not (= x (1+ len))))
                  do (cl-pushnew x fin)
        finally return fin))

(loop repeat 50 collect (fsc-rearrange-random-intergers-list 2))


(defun fsc-rearrange-random-intergers-list-paranoid (range-max)
  "Same as `fsc-rearrange-random-intergers-list', but the output list never
sorted increasingly."
  (let* ((output (fsc-rearrange-random-intergers-list range-max))
         (order (sort output '<)))
    (if (equal output order)
        (fsc-rearrange-random-intergers-list-paranoid range-max)
      output)))

(defun fsc-sub-char (string integer)
  "Indexing from 1.
e.g. (fsc-sub-char \"test\" 2) => \"e\""
  (make-string 1 (aref string (1- integer))))

(defvar fsc-punc-pat "\\([~!@#\\$%\\^&\\*()_\\+\\.,<>/\\?]\\)")

(defun fsc-rearrange--split-sentence (input)
  "Input can be a multiple lines strings.
This function split the input (by space) into a nested list (by newline).
e.g. \"The first line \nThe second line\"
=> ((\"The\" \"first\" \"line\") (\"The\" \"second\" \"line\"))"
  (setq input (replace-regexp-in-string "\\(\\cc\\)\\(\\cl\\)" "\\1 \\2" input))
  (setq input (replace-regexp-in-string "\\(\\cl\\)\\(\\cc\\)" "\\1 \\2" input))
  (setq input (replace-regexp-in-string (concat "\\(\\cc\\)" fsc-punc-pat) " \\1 \\2  " input))
  (setq input (replace-regexp-in-string (concat "\\(\\cl\\)" fsc-punc-pat) " \\1 \\2  " input))
  (setq input (replace-regexp-in-string (concat fsc-punc-pat "\\(\\cc\\)") " \\1 \\2  " input))
  (setq input (replace-regexp-in-string (concat fsc-punc-pat "\\(\\cl\\)") " \\1 \\2  " input))
  (setq input (replace-regexp-in-string "\\([。，！？；：「」『』（）、【】《》〈〉]\\)" " \\1 " input))
  (let (output)
    (mapcar (lambda (x)
              (push (split-string-and-unquote x " +") output))
            (reverse (split-string-and-unquote input "\n")))
    output
    ))

;; [FIXME] ...orz如果latin-word是"(parenthesis)"這樣的字串勒...需要用到 (("符號" . 位置) ...)這麼機車的方法處理嗎...
(defun fsc-rearrange--latin (latin-word)
  "input should be a single word and output whose characters are randomly ordered one (not include punctuation).
e.g. \"foobar\" => \"fboaor\"."
    (cond ((eq 1 (length latin-word))
           latin-word)
          ((eq 2 (length latin-word))
           (apply #'string (list (aref latin-word 1) (aref latin-word 0))))
          ((eq 3 (length latin-word))
           (apply #'string (list (aref latin-word 0) (aref latin-word 2) (aref latin-word 1))))
          (t
           (let (fin)
             (setq fin
                   (apply #'string
                          (append
                           (list (aref latin-word 0))
                           (mapcar (lambda (x) (aref latin-word x))
                                   (fsc-rearrange-random-intergers-list (- (length latin-word) 2)))
                           (list (aref latin-word (1- (length latin-word)))))))
             (if (equal fin latin-word)
                 (fsc-rearrange--latin latin-word)
               fin)))))
          
(loop repeat 50 collect (fsc-rearrange--latin "Test"))


(defun fsc-rearrange--chinese (input)
  "Input should be a chinese string (not include punctuation).
e.g. \"他的包袱掉出兩粒橘子\"
=> (\"他的\" \"包袱\" \"掉出兩\" \"粒橘子\") ; LIST
=> (\"的他\" \"袱包\" \"出掉兩\" \"橘子粒\") ; R_LIST
=> 的他袱包出掉兩橘子粒                      : FIN"
  (let* (LIST R_LIST FIN)
    (while (> (length input) 3)
      (let ((n (fsc-rearrange-random-length)))
        (setq LIST (cons (substring-no-properties input 0 n) LIST))
        (setq input (substring-no-properties input n))))
    (when (>= (length input) 1)
      (setq LIST (cons input LIST)))
    ;; Reverse
    (mapcar (lambda (x)           ; x = "字串"
              (let ((new-string "")
                    (rnd-list (fsc-rearrange-random-intergers-list (length x))))
                (mapcar (lambda (y) ;y is an interger from rnd-list
                          (setq new-string (concat new-string (fsc-sub-char x y)))) rnd-list)
                (setq R_LIST (cons new-string R_LIST))
                ))
            LIST)
    ;; FIN
    (apply #'concat R_LIST)))

(setq fsc-rearrange-weighting-list [1 1 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4])
(defun fsc-rearrange-random-length ()
  "Generate a random length for Chinese volcabulary.
Take a look of `fsc-rearrange-weighting-list'"
  (aref fsc-rearrange-weighting-list
        (random (length fsc-rearrange-weighting-list))))

(defun fsc-rearrange-process-input-single (input)
  "Input can be a *SINGLE* Latin word or Chinese/Japanese string ('字串').
This function will decide the input should use `fsc-rearrange--latin' or
`fsc-rearrange--chinese' to disarrange word, then return the result."
  ;; ("中文和" "1234567890" "and" "English" "words" "同時摻雜" "in" "a" "sentence")
  ;; [FIXME] 記得不要動到數字的順序。
  (cond ((string-match "\\cc" input)
         (fsc-rearrange--chinese input))
        ((string-match "\\cl" input)
         (concat (fsc-rearrange--latin input) " "))
        (t
         (concat input " "))))

(defun fsc-rearrange (input)
  "Main function to handle sentences (include newlines, CJK/Latin)."
    (mapconcat (lambda (x)                 ;原始list
                 (mapconcat (lambda (y)     ; ("The" "sentence" ".")
                              (fsc-rearrange-process-input-single y)) x ""))
                 (fsc-rearrange--split-sentence input)
                 "\n") ; (("The" "sentence" ".")("Apple"))
    )

'("This" "is" "..." "一個簡單測試" "。")
(fsc-rearrange "WTFPL（Do What The Fuck You Want To Public License，中文譯名：你他媽的想幹嘛就幹嘛公眾授權條款）
是一種不太常用的、極度放任的自由軟體授權條款...。")




(provide 'fsc-rearrange)
