;; Red_d_: 有沒有人以可一寫個音注入輸法，是但打子完句，字可以新重的排列。#地方的民鄉需要化進
;;FSC - Fuck the Speeching Censorship

(defun free-speech ()
  (interactive "r")
  )

(defun random-intergers-list (range-max)
  "input should be an interger, and output a list which elements are out of order.
Index from 1.
For example: input is 7, output is like (5 2 6 7 4 3 1)."
  (let ((OUTPUT '()))
    (while (< (length OUTPUT) range-max)
      (let* ((x (random (1+ range-max))))
        (when (not (eq x 0))
          (add-to-list 'OUTPUT x))))
    OUTPUT))

(defun sub-char (string integer)
  "Indexing from 1.
e.g. (sub-char \"test\" 2) => \"e\""
  (make-string 1 (aref string (1- integer))))

(defun free-speech--split-sentence (input)
  "Input can be a multiple lines strings.
This function split the input (by space) into a nested list (by newline).
e.g. \"The first line \nThe second line\"
=> ((\"The\" \"first\" \"line\") (\"The\" \"second\" \"line\"))"
  (setq input (replace-regexp-in-string "\\(\\cc\\)\\(\\ca\\)" "\\1 \\2" input))
  (setq input (replace-regexp-in-string "\\(\\ca\\)\\(\\cc\\)" "\\1 \\2" input))
  (setq input (replace-regexp-in-string "\\([。，！？；：「」『』（）、【】《》〈〉]\\)" " \\1 " input))
  (let (output)
    (mapcar (lambda (x)
              (push (split-string-and-unquote x " +") output))
            (reverse (split-string-and-unquote input "\n")))
    output
    ))

(free-speech--split-sentence "中文、 English 和 123 數字摻雜在一起的 sentence ，中文有一堆亂七八糟的情況，像是標點符號多到爆炸，我都不知該怎麼做好了。The quick fox, jumps.")

(defun my-split-sentence (INPUT)
)

(defun free-speech-process-input (input)
  "Input can be a single Latin word or Chinese/Japanese string ('字串').
This function will decide the input should use `free-speech--latin' or `free-speech--chinese'
to disarrange word, then return the result."
  ;; ("中文和" "1234567890" "and" "English" "words" "同時摻雜" "in" "a" "sentence")
  ;; [FIXME] 記得不要動到數字的順序。
  (split-string-and-unquote input "")
  )
(substring-no-properties "一個簡單的中文句子，加上標點。" 14 15)

"個一單簡中的句文，子上加點標。"
(sort  #'>)
;; [FIXME] ...orz如果latin-word是"(parenthesis)"這樣的字串勒...需要用到 (("符號" . 位置) ...)這麼機車的方法處理嗎...
(defun free-speech--latin (latin-word)
  "input should be a single word and output whose characters are randomly ordered one.
e.g. \"foobar!\" => \"fboaor!\". (If ending contains punctuation, it remains in there)"
  (let* (input output
         (PUNC (if (string-match "[.,?!\)]$" latin-word) ;if punctuation exist in the end of word
                   (progn (setq input (substring-no-properties latin-word 0 (1- (length latin-word))))
                          (sub-char latin-word (length latin-word)))
                 (progn (setq input latin-word)
                        nil)))
         (INPUT_LENGTH (length input))   ;"test" => 4
         (RAND_LIST (random-intergers-list (length input))) ;"test" => (1 3 4 2)
         )
    (case INPUT_LENGTH
      (1 input)
      (2 input)
      (3 (concat (sub-char input 1) (sub-char input 3) (sub-char input 2)))
      (t
       (setq RAND_LIST (remove INPUT_LENGTH RAND_LIST)) ;delete largest num and 1, because we want the string keeping the char order of head & tail.
       (setq RAND_LIST (remove 1 RAND_LIST))
       (setq output (sub-char input 1)) ;the first char of the input string. "test" => "t"
       (dolist (x RAND_LIST)      ;get random interger from RAND_LIST
         (setq output (concat output (sub-char input x))))
       (setq output (concat output (sub-char input INPUT_LENGTH)))
       (if (and (>= INPUT_LENGTH 4)     ;Ensure the word in indeed "randomed"
                (equal input output))
           (free-speech--latin latin-word)   ;If the same as input, do again.
         (if PUNC
             (format "%s%s" output PUNC)
           output
           ))))))


(defun free-speech--chinese (input)
  ""
  (let* ((RAND_LIST (random-intergers-list (length input)))
         output)
    (dolist (x RAND_LIST)
      (setq output (concat output (sub-char input x))))
    (if (equal input output)
        (free-speech--chinese input)
         output)))

(setq free-speech-weighting-list [2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4])

(defun free-speech-random-length ()
  "Generate a random length for Chinese volcabulary.
Take a look of `free-speech-weighting-list'"
  (aref free-speech-weighting-list
        (random (length free-speech-weighting-list))))
(free-speech-random-length)
;; [FIXME] 記得可以用mapcar把("中文" "句子")送給`free-speech--chinese'處理。
;; (mapcar '1+ [3 4 5] ) => (4 5 6)

(defun free-speech-split-chinese-sentence (input)
  "Split the input sentence into several elements of a list as output.
the length of an element is from `free-speech-random-length'. e.g.:
\"他的包袱掉出兩粒橘子\" => (\"他的\" \"包袱\" \"掉出兩\" \"粒橘子\")"
    ;; [FIXME] 中文字串要先判斷剩餘長度，再決定要不要用亂數處理

  (let* ((INPUT-LIST (split-string-and-unquote input ""))
         output)
    (
     (let ((x)
           (LEN (free-speech-random-length)))
      (dotimes (i LEN) ;i is useless
        (setq x (concat x (pop INPUT-LIST)))))



     ;; [FIXME] 數字不要動啦...

     (mapcar (lambda (y)
               (mapcar 'free-speech--latin y))
             '(("Do" "you" "want" "to" "come" "to" "COSCUP" "2014," "but" "are" "worried" "about" "not" "getting" "TICKETS" "at" "the" "first" "time?")
               ("This" "year" "we" "have" "an" "Open" "Source" "Contributor" "Registration" "Program" "for" "people" "who" "make" "contribution" "to" "open" "source" "society" "to" "attend" "COSCUP." "We" "will" "send" "Registration" "Codes" "to" "qualified" "applicants." "Activating" "a" "Registration" "Code" "by" "the" "registration" "deadline" "(to" "be" "published" "later)" "will" "get" "an" "invitation" "to" "COSCUP" "2014."))
             )
        )

(apply #'concatenate 'string '("the" "quick" "fox"))

