; 練習問題 2.59
; 順 序 な し リ ス ト と し て 表 現 した 集 合に 対 する union-set 演算を実装せよ。
(load "sicp2.3.3.rkt")

(define (union-set A B)
  (cond ((null? B) A)
         ((element-of-set? (car B) A)
          (union-set A (cdr B)))
         (else (cons (car B) (union-set A (cdr B))))))

(define (union-set A B)
  (define (iter A B U)
    (cond ((or (null? B) (null? A)) U)
           ((element-of-set? (car B) A) (iter A (cdr B) U))
           (else (iter A (cdr B)) (cons (car B) U))))
  (iter A B A))
