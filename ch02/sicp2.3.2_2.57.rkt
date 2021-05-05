; 練習問題 2.57
;微分プログラムを拡張し、(2 以上の) 任意の数の項の和と積を扱えるようにせよ。
;deriv 手続きにはまったく手を加えず、和と積の表現のみを変更することによって解け。
;例えば、和の addend(加数) は最初の項で、augend(被加数) は残りの項の和というようにする。
(load  "sicp2.3.2_2.56.rkt")
(define (augend s)
  (let ((other (cddr s)))
    (if (= 1 (length other)) (car other)
       (cons '+ other))))
(define (multiplicand p)
  (let ((other (cddr p)))
    (if (= 1 (length other)) (car other)
       (cons '* other))))
(define f '(* x y (+ x 3)))
;> (deriv f 'x)
;(mcons
; '+
; (mcons
;  (mcons '* (mcons 'x (mcons 'y '())))
;  (mcons (mcons '* (mcons 'y (mcons (mcons '+ (mcons 'x (mcons 3 '()))) '()))) '())))
;> 