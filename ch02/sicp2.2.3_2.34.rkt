; 練習問題 2.34 x の多項式を評価するホーナー法 (Horner’s rule)
;次の多項式について考える。
; a_n x^n + a_{n−1} x^{n−1} + · · · + a_1 x + a_0
;ホーナー法では、この計算を以下のような構造にする。
; (...(a_n x + a_{n-1}) x + ... + a_1)x + a_0.
;つまり、a_n から始めて、それに x をかけ、a_{n−1} を足し、x をかけ... ということを、a_0 まで繰り返す。
;多項式をホーナー法によって評価する手続きを作れ。
;多項式の係数 a_0 . . . a_n は列として並んでいるとする。
(load "sicp2.2.3.rkt")
(define (horner-eval x coefficient-seq)
  (define (fn an-1 an)
    (+ (* an x) an-1))
  (accumulate fn 0 coefficient-seq))
;例えば、x = 2 のときの 1 + 3x + 5x^3 + x^5 を計算するには、次を評価する。
; (horner-eval 2 (list 1 3 0 5 0 1))
;> (horner-eval 2 (list 1 3 0 5 0 1))
;79
;> 