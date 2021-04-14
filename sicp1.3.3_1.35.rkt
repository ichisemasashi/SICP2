; 練習問題 1.35
; ⻩金比 φが x → 1 + 1/x という変形の不動点であることを示し

; φ^2 = φ + 1なので、φ = 1 + 1/φつまり、x → 1 + 1/x

; φ を fixed-point 手続きによって求めよ。

(load "sicp1.3.3.rkt")
(define phi (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0))