; SICP 1.1.4
;

(define (square x) (* x x))


(square 21)
;=> 441
(square (+ 2 5))
;=> 49
(square (square 3))
;=> 81

; x^2 + y^2
; (+ (square x) (square y))

(define (sum-of-squares x y)
  (+ (square x) (square y)))

(sum-of-squares 3 4)
;=> 25


(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

(f 5)
;=> 136
