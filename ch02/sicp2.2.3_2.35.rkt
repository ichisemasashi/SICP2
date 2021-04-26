; 練習問題 2.35
;2.2.2 節の count-leaves を集積として再定義せよ。
(load "sicp2.2.3.rkt")
(define (count-leaves tree)
  (define (f x)
    (cond ((null? x) 0)
           ((atom? x) 1)
           (else (count-leaves x))))
  (accumulate + 0 (map f tree)))
