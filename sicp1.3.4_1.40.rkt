; 練習問題 1.40
; 次のような形の式で newtons-method 手続きと組み合わせて使うことによって、
;三次方程式 x^3 + ax^2 + bx + c = 0
;の零点の近似値を求めることができるような手続き cubic を定義せよ。
; (newtons-method (cubic a b c) 1)

(load "sicp1.3.4.rkt")
(define (cubic a b c)
  (lambda (x) (+ (cube x)
                   (* a (square x))
                   (* b x)
                   c)))
                  