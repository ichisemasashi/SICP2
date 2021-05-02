; 練習問題 2.39 fold-right と fold-left によるreverse(練習問題 2.18)
(load "sicp2.2.3_2.38.rkt")
(define a (list 1 2 3 4 5 6))
(define (reverse seq)
  (define (f x acc)
    (append acc (list x)))
  (fold-right f nil seq))
;> (reverse a)
;(mcons 6 (mcons 5 (mcons 4 (mcons 3 (mcons 2 (mcons 1 '()))))))
;> 
(define (reverse seq)
  (define (f acc x)
    (cons x acc))
  (fold-left f nil seq))
;> (reverse a)
;(mcons 6 (mcons 5 (mcons 4 (mcons 3 (mcons 2 (mcons 1 '()))))))
;> 