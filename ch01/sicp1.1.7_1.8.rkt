; 練習問題 1.8
;

(define (cbrt-iter guess pre-guess x)
  (if (good-enough? guess pre-guess)
      guess
      (cbrt-iter (improve guess x) guess x)))

(define (improve guess x)
  (/ (+ (/ x (* guess guess))
        (* 2 guess))
     3))


(define (good-enough? guess pre-guess)
  (< (/ (abs (- guess pre-guess)) guess) 0.0001))


(define (cbrt x)
  (cbrt-iter 1.0 100.0 x))

(cbrt 8)
;=> 2.000000000012062

(cbrt 27)
;=> 3.0000000000000977

(cbrt 0.000002)
;=> 0.012599210498948799

(cbrt 200000000000000000000)
;=> 5848035.476470061

