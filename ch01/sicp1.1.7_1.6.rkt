; 練習問題 1.6
;

; (define (new-if predicate then-clause else-clause)
;  (cond (predicate then-clause)
;        (else else-clause)))
;
; (define (sqrt-iter guess x)
;   (new-if (good-enough? guess x)
;           guess
;           (sqrt-iter (improve guess x) x)))

; new-ifを使うと、このsqrt-iterはnew-ifに作用させるために(sqrt-iter (improve guess x) x) が無限に呼ばれてしまう。
