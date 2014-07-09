;;; fsc.el ---  Fuck the Speeching Censorship                  -*- lexical-binding: t; -*-

;; Copyright (C) 2014  kuanyui

;; Author: kuanyui <azazabc123@gmail.com>
;; Keywords: tools, games

;; License: WTFPL1.0

;;; Commentary:

;; 

;;; Code:

(require 'cl)
(require 'makey)
(require 'fsc-rearrange)
(require 'fsc-spook)
(require 'fsc-vertical)
(require 'fsc-flip-and-reverse)


(setq fsc-context-menus
  '(
    (fsc
     (description "FSC: Fuck the Speeching Censorship!")
     (actions
      ("Which"
       ("r" "Region" makey-key-mode-popup-fsc-region)
       ("m" "Minibuffer" makey-key-mode-popup-fsc-minibuffer)
       ("s" "Spook" makey-key-mode-popup-fsc-spook))))
    (fsc-region
     (description "Read text from region")
     (actions
      ("Flip/Reverse"
       ("l" "Reverse (Right-to-Left)" fsc/reverse-region)
       ("f" "Flip (Upside-down)" fsc/flip-region)
       ("F" "Flip and Reverse" fsc/flip-and-reverse-region))
      ("Flip/Reverse (Translate Back)"
       ("bf" "Flip" fsc/flip-back-region)
       ("bF" "Flip and Reverse" fsc/flip-and-reverse-back-region))
      ("Vertical Line"
       ("v" "Rotate vertically" fsc/vertical-region)
       ("V" "Rotate vertically and copy" fsc/vertical-region-and-copy))
      ("Rearrange Characters"
       ("r" "Rearrange characters of words" fsc/rearrange-region)
       ("R" "Rearrange characters and copy" fsc/rearrange-region-and-copy))))
    (fsc-minibuffer
     (description "Read text from minibuffer")
     (actions
      ("Flip/Reverse"
       ("l" "Reverse (Right-to-Left)" fsc/reverse-minibuffer)
       ("f" "Flip (Upside-down)" fsc/flip-minibuffer)
       ("F" "Flip and Reverse" fsc/flip-and-reverse-minibuffer))
      ("Flip/Reverse (Back) "
       ("bf" "Flip" fsc/flip-back-minibuffer)
       ("bF" "Flip and Reverse" fsc/flip-and-reverse-back-minibuffer))
      ("Vertical Line"
       ("v" "Rotate vertically" fsc/vertical-minibuffer))
      ("Rearrange Characters"
       ("r" "Rearrange characters of words" fsc/rearrange-minibuffer))))
    (fsc-spook
     (description "Insert Wonderful Words for Censors")
     (lisp-switches
      ("SPC" "Specify amounts of words" current-prefix-arg '(4) nil))
     (actions
      ("Insert"
       ("w" "Insert wonderful words for Wheelparty" fsc/spook-insert-wheelparty)
       ("g" "Insert wonderful words for Greatwall" fsc/spook-insert-greatwall))
      ("Edit Spook Files"
       ("O" "Open the spook files directory" fsc/spook-edit-open-spook-directory)
       ("E" "Decode and start editing this spook file" fsc/spook-edit-start))))
    )
  )

(makey-initialize-key-groups fsc-context-menus)

(defalias 'fsc 'makey-key-mode-popup-fsc)
(defalias 'fsc/spook 'makey-key-mode-popup-fsc-spook)
(defalias 'fsc/region 'makey-key-mode-popup-fsc-region)
(defalias 'fsc/minibuffer 'makey-key-mode-popup-fsc-minibuffer)

(provide 'fsc)
;;; fsc.el ends here
