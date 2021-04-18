; 練習問題 1.25

; expmod を単純にこんなふうに書いたら正しいだろうか。
;( define ( expmod base exp m)
;   (remainder (fast-expt base exp) m))
; remainderの位置が残念。fast-exptの中にremainderがないため、扱う数値が巨大になってしまう。



;; 参考
; ある数値の冪乗の、別のある数値を法とした剰余を求める
; 二乗の連続を使っているため、ステップ数は指数に対して対数的に増加
;(define (expmod base exp m)
;  (cond ((= exp 0) 1)
;        ((even? exp ) (remainder (square (expmod base (/ exp 2) m)) m))
;       (else (remainder (* base (expmod base (- exp 1) m)) m))))

; b^n = (b^(n/2))2    n が偶数の場合,
; b^n = b · b^(n−1)   n が奇数の場合.
; Θ(log n)
;(define (fast-expt b n)
;  (cond ((= n 0) 1)
;        ((even? n) (square (fast-expt b (/ n 2))))
;        (else (* b (fast-expt b (- n 1))))))
