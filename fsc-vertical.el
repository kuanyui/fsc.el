(defun fsc-split-sentence-to-lists (vOriginal vLineCharNum)
  "First arg is an ONE-LINE string as inputed sentence. The
second is 'How many characters in a vertical line', an integer.
For example, when vLineCharNum = 3, Output is a reversed list."
  ;; (...
  ;;  (\"四\" \"五\" \"六\")
  ;;  (\"一\" \"二\" \"三\"))
  (let* ((vOriginal (fsc-convert-halfwidth-to-fullwidth vOriginal))
         (vSplittedString (split-string-and-unquote vOriginal ""))
         (vStart 0)
         vOutput
         (vSentenceLength (length vOriginal)) ;Length of input
         (vLack (- vLineCharNum (% vSentenceLength vLineCharNum))))
    ;; vLack is how many char lacks in the last list (use "　" to fill)
    ;; When !=0, add "　" of vLack in the last list.
    (dotimes (i (/ vSentenceLength vLineCharNum))
      (push (subseq vSplittedString vStart
                    (+ vStart vLineCharNum)) vOutput)
      (setq vStart (+ vStart vLineCharNum)))
    ;; Add "　"(s) into the last list to fit rectangle array.
    (when (not (= vLack 0))
      (let* ((TEMP-LIST (make-list vLack "　")))
        (setq TEMP-LIST
              (append (subseq vSplittedString vStart vSentenceLength)
                      TEMP-LIST))
        (push TEMP-LIST vOutput)))
    vOutput))

(defun fsc-rotate-text-and-gen-list (input num)
  "First arg is an ONE-LINE string as inputed sentence.
The second is 'How many characters in a line', an integer.
Output is a SINGLE-LIST containing elements of string."
  ;;(("　" "　" "　" "李" "白" "　")
  ;; ("低" "頭" "思" "故" "鄉" "。")
  ;; ("舉" "頭" "望" "明" "月" "，")
  ;; ("疑" "似" "地" "上" "霜" "，")
  ;; ("床" "前" "明" "月" "光" "，"))
  ;; =1=> Elements of string in single list
  ;; ("　 低 舉 疑 床 "
  ;;  "　 頭 頭 似 前 "
  ;;  "　 思 望 地 明 "
  ;;  "李 故 明 上 月 "
  ;;  "白 鄉 月 霜 光 "
  ;;  "　 。 ， ， ， ")
  ;; =2=>
  ;; 　 低 舉 疑 床
  ;; 　 頭 頭 似 前
  ;; 　 思 望 地 明
  ;; 李 故 明 上 月
  ;; 白 鄉 月 霜 光
  ;; 　 。 ， ， ，
  (let (FIN-LIST vInputList)
    (setq vInputList (fsc-split-sentence-to-lists input num))
    (dotimes (n num)         ;一行直行有num個字，n從0開始累加直到num。
      (let (TEMP-STR)        ;產生"　 低 舉 疑 床 "作為TEMP-STR並插入到list的第n個element
        (dolist (x vInputList) ;x依序成為一個個的list，("　" ...) ("低" ...) ("舉" ...)
          (setf TEMP-STR (concat TEMP-STR (elt x n) " ")))  ;，並加上直行之間的空白
        (push TEMP-STR FIN-LIST)))  ;一列列push進FIN-LIST
    (setq FIN-LIST (reverse FIN-LIST))
    FIN-LIST))

(defun fsc-rotate-text (input num)
  "First arg is string (single/multiple line are ok),
second arg is how many characters a line.
Output is rotated text."
  ;; => split lines into elements of a list
  ;; ("床前明月光，疑似地上霜，舉頭望明月，低頭思故鄉。　　　李白"
  ;;  "眾裡尋他千百度；驀然回首，那人卻在燈火闌珊處。")
  ;; element string => `fsc-rotate-text-and-gen-list' =>
  ;; ("　 低 舉 疑 床 "
  ;;  "　 頭 頭 似 前 "
  ;;  "　 思 望 地 明 "
  ;;  "李 故 明 上 月 "
  ;;  "白 鄉 月 霜 光 "
  ;;  "　 。 ， ， ， ")
  ;; 一產出上面這個就立刻把他跟FIN-LIST (make-list num "")的元素一個個concat起來。
  ;; 都concat完後，最後再一口氣把FIN-LIST的東西一項一項加上換行給print出來
  ;; 　 低 舉 疑 床
  ;; 　 頭 頭 似 前
  ;; 　 思 望 地 明
  ;; 李 故 明 上 月
  ;; 白 鄉 月 霜 光
  ;; 　 。 ， ， ，
  (let* ((FIN "")
         ;;把input的每一行切開一個個丟進list'("第一行" "第二行" ...)
         (lInputLines (split-string-and-unquote input "\n"))
         (FIN-LIST (make-list num "")))
    (dolist (x lInputLines)
      (let* ((ELT (fsc-rotate-text-and-gen-list x num)))
        (setq FIN-LIST
              (map 'list (lambda (a b) (concat a b))
                   ELT FIN-LIST))))
    (mapcar (lambda (y)
              (setq FIN (format "%s%s\n" FIN y)))
            FIN-LIST)
    (setq FIN (replace-regexp-in-string " $" "" FIN)) ;去掉每行結尾空格
    (setq FIN (replace-regexp-in-string "^　 " "" FIN))
    FIN
    ))

(defun fsc-rotate-text-from-minibuffer ()
  ""
  (interactive)
  (let* ((text (read-from-minibuffer "Input text (CJK only): "))
         (num (string-to-int (read-from-minibuffer "How many characters a line: "))))
    (insert (fsc-rotate-text text num))))


(defun fsc-convert-halfwidth-to-fullwidth (text)
  ""
  (mapcar (lambda (x)
            (when (string-match (car x) text)
              (setq text (replace-regexp-in-string (car x) (cdr x) text))))
          '(("0" . "０")
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
            ("<" . "＜")
            ("=" . "＝")
            (">" . "＞")
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
            ("_" . "＿")
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
            ("|" . "｜")
            ("}" . "︸")
            ("(" . "︵")
            (")" . "︶")
            ("（" . "︵")
            ("）" . "︶")
            ("「" . "﹁")
            ("」" . "﹂")
            ))
  text)

(provide 'fsc-vertical)
