; 練習問題 1.39
(load "sicp1.3.3_1.37.rkt")

; tan(x) = x/(1 - x^2/(3 - x^2/(5 - ...
;正接関数の近似値を求める手続き (tan-cf x k) を定義せよ。
(define (tan-cf x k)
  (cont-frac (lambda (i) (if (= 1 i) x (- (* x x))))
               (lambda (i) (- (* 2 i) 1))
               k))