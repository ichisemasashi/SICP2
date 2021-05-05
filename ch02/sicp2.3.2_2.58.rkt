; 練習問題 2.58 中置演算子の微分プログラム
;微分プログラムを修正して、+ と * が中置演算子となるような、通常の数学の記法に対して動作させたいとする。
;微分プログラムは抽象データによって定義されているので、
;微分プログラムの動作基盤となる代数式の表現を定義する述語、セレクタ、コンストラクタを変更するだけで、
;異なる表現を扱うように修正できる。
(load "sicp2.3.2_2.57.rkt")
;;;;;;;;;;
; a.
(define fa '(x + (3 * (x + (y + 2)))))
;問題を簡単にするため、+ と * は常に二つの引数を取り、式は完全に括弧でくくられていると仮定せよ。
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
         ((=number? a2 0) a1)
         ((and (number? a1) (number? a2)) (+ a1 a2))
         (else (list a1 '+ a2))))
(define (sum? x)
  (and (pair? x)
        (eq? (cadr x) '+)))
(define (addend s)
  (car s))
(define (augend s)
  (caddr s))
(define (make-product m1 m2)
  (cond ((=number? m1 1) m2)
         ((=number? m2 1) m1)
         ((or (=number? m1 0) (=number? m2 0)) 0)
         ((and (number? m1) (number? m2)) (* m1 m2))
         (else (list m1 '* m2))))
(define (product? x)
  (and (pair? x)
        (eq? (cadr x) '*)))
(define (multiplier x)
  (car x))
(define (multiplicand x)
  (caddr x))

;;;;;;;;;;
; b.
; b方式の式をa方式に変換する方式で対応
(define fb '(x + 3 * (x + y + 2)))
(define (to-pair-exp f)
  (cond ((not (pair? f)) f)
         ((null? (cdr f)) (to-pair-exp (car f)))
  (else (let ((a1 (car f))
         (op (car (cdr f)))
         (a2 (cdr (cdr f))))
    (cond ((not (or (eq? op '+)
                      (eq? op '*)
                      (eq? op '**)))
            (error "operator error" op))
           ((and (not (pair? a1))
                  (not (pair? a2)))
            (list a1 op a2))
           ((and (not (pair? a1)) (pair? a2)) (list a1 op (to-pair-exp a2)))
           ((and (pair? a1) (not (pair? a2))) (list (to-pair-exp a1) op a2))
           (else (list (to-pair-exp a1) op (to-pair-exp a2))))))))
;> fa
;(mcons 'x (mcons '+ (mcons (mcons 3 (mcons '* (mcons (mcons 'x (mcons '+ (mcons (mcons 'y (mcons '+ (mcons 2 '()))) '()))) '()))) '())))
;> (to-pair-exp fb)
;(mcons 'x (mcons '+ (mcons (mcons 3 (mcons '* (mcons (mcons 'x (mcons '+ (mcons (mcons 'y (mcons '+ (mcons 2 '()))) '()))) '()))) '())))
;> (to-pair-exp fa)
;(mcons 'x (mcons '+ (mcons (mcons 3 (mcons '* (mcons (mcons 'x (mcons '+ (mcons (mcons 'y (mcons '+ (mcons 2 '()))) '()))) '()))) '())))
;> 