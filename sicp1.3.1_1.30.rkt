; 練習問題 1.30
; sum 手続きを総和計算が反復的に行われるように書き直す

; 元のsum
;(define (sum term a next b)
;  (if (< b a) 0
;       (+ (term a)
;          (sum term (next a) next b))))
(load "sicp1.3.1.rkt")
(define (sum term a next b)
  (define (iter a result)
    (if (< b a) result
       (iter (next a) (+ result (term a)))))
  (iter a 0))


