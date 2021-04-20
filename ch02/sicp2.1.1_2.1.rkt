; 練習問題 2.1 正と負の両方の引数を扱うことができる改良版 make-rat を定義せよ。
; make-rat は符号を正規化し、正の有理数であれば分子と分母の両方が正となり、
;負の有理数であれば分子のみが負になるようにする。
(load "sicp2.1.1.rkt")
(define (make-rat n d)
  (let ((g (gcd (abs n) (abs d)))
         (s (* n d)))
    (let ((N (/ (abs n) g))
           (D (/ (abs d) g)))
    (if (<= 0 s)
       (cons N D)
       (cons (* -1 N) D)))))
; (define one-third (make-rat 1 -3))
; (print-rat (add-rat one-third one-third)) ;=> -2/3