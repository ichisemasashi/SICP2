; 練習問題 1.7
;

(load "sicp1.1.7.rkt")

(sqrt 2)
;=> 1.4142156862745097

(sqrt 0.000002)
;=> 0.0312713096020622 # バグってる!

; (sqrt 200000000000000000000)
;=> 帰ってこない!!

(define (sqrt-iter2 guess pre-guess x)
  (if (good-enough2? guess pre-guess)
      guess
      (sqrt-iter2 (improve guess x) guess x)))

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good-enough2? guess pre-guess)
  (< (/ (abs (- guess pre-guess)) guess) 0.001))

(define (sqrt2 x)
  (sqrt-iter2 1.0 100.0 x))

(sqrt2 2)
;=> 1.4142135623746899

(sqrt2 0.000002)
;=> 0.0014142135626178485

(sqrt 200000000000000000000)
;=> 14142135623.730951

;
; good-enough2?を利用すると計算できる!!
;
