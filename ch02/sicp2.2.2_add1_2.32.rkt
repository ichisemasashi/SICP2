; 練習問題 2.32 部分集合の集合
;集合は、それぞれ異なる要素を持つリストとして表現できる。
;また、集合のすべての部分集合の集合は、リストのリストとして表現できる。
;例えば、集合が (1 2 3) の場合、すべての部分集合の集合は
;(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)) となる。
;集合のすべての部分集合の集合を生成する手続きを完成させ、なぜそれが動作するのかを明確に説明せよ。
(define (subsets s)
  (define (fn x)
    (cons (car s) x))
  (if (null? s) (list nil)
     (let ((rest (subsets (cdr s))))
       (append rest (map fn rest)))))
(define a nil)
(define b (list 3))
(define c (list 2 3))
(define d (list 1 2 3))
;> (subsets b)
;(mcons '() (mcons (mcons 3 '()) '()))
;> (subsets a)
;(mcons '() '())
;> (subsets c)
;(mcons '() (mcons (mcons 3 '()) (mcons (mcons 2 '()) (mcons (mcons 2 (mcons 3 '())) '()))))
;> (subsets d)
;(mcons
; '()
; (mcons
;  (mcons 3 '())
;  (mcons
;   (mcons 2 '())
;   (mcons (mcons 2 (mcons 3 '())) (mcons (mcons 1 '()) (mcons (mcons 1 (mcons 3 '())) (mcons (mcons 1 (mcons 2 '())) (mcons (mcons 1 (mcons 2 (mcons 3 '()))) '()))))))))
;> 