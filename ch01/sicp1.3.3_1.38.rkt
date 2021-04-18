; 練習問題 1.38

(load "sicp1.3.3_1.37.rkt")
; e − 2(e は自然対数の底) の連分数
; Ni はすべて 1 で、Di は 1, 2, 1, 1, 4, 1, 1, 6, 1, 1,... という数列である。
; オイラーの連分数展開をもとに、練習問題 1.37のcont-frac 手続きを使って e を近似するプログラムを書け。
(define (N i)
  1.0)
(define (D i)
  (if (= 2 (remainder i 3)) (/ (inc i) 1.5)
      1))
(define (e k)
  (+ 2
    (cont-frac N D k)))

