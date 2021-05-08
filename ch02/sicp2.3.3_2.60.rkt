; 練習問題 2.60 重複を許すリストとしての集合
;重複を許す場合について考えてみよう。
;この表現に対して演算を行う手続き element-of-set?, adjoin-set, union-set, intersection-set を設計せよ。
;それぞれの効率は、重複なし表現に対する手続きでそれに対応するものと比べてどうだろうか。
;重複なしの表現よりもこの表現のほうが向いているような応用はあるだろうか。
(define (element-of-set? x set)
  (cond ((null? set) false)
         ((equal? x (car set)) true)
         (else (element-of-set? x (cdr set)))))
(define (adjoin-set x set)
  (cons x set))
(define (intersection-set-strict set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
         ((element-of-set? (car set1) set2)
          (cons (car set1)
                 (intersection-set-strict (cdr set1) set2)))
         (else (intersection-set-strict (cdr set1) set2))))
(load "util.rkt")
(define (intersection-set set1 set2)
  (let ((inter (intersection-set-strict set1 set2))
         (union (union-set set1 set2)))
    (filter (lambda (x) (element-of-set? x inter)) union)))
(define (union-set set1 set2)
  (append set1 set2))
