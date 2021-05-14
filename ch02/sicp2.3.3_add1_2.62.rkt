; 練習問題 2.62
;順序つきリストとして表現された集合に対して、 union-set を Θ(n) で実装せよ。

;順序なしの表現を使った union-set
;(define (union-set A B)
;  (cond ((null? B) A)
;         ((element-of-set? (car B) A)
;          (union-set A (cdr B)))
;         (else (cons (car B) (union-set A (cdr B))))))

; 参考：
(define (element-of-set? x set)
  (cond ((null? set) false)
         ((= x (car set)) true)
         ((< x (car set)) false)
         (else (element-of-set? x (cdr set)))))

(define (union-set A B)
  (cond ((null? A) B)
        ((null? B) A)
        ((= (car A) (car B))
         (cons (car A) (union-set (cdr A) (cdr B))))
        ((< (car A) (car B))
         (cons (car A) (union-set (cdr A) B)))
        (else (cons (car B) (union-set A (cdr B))))))
