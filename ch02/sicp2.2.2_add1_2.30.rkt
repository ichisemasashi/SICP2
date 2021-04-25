; 練習問題 2.30 square-tree
;練習問題 2.21の square-list と似たような手続き square-tree を定義せよ。
;直接的な (つまり、高階手続きをまったく使わない) やり方と、
;mapと再帰を使うやり方の両方で、square-tree を定義せよ。
;(square-tree
; (list 1
;      (list 2 (list 3 4) 5)
;      (list 6 7)))
;=> (1 (4 (9 16) 25) (36 49))
(load "util.rkt")
(define (square-tree tree)
  (cond ((null? tree) nil)
         ((atom? tree) (square tree))
         (else (cons (square-tree (car tree))
                       (square-tree (cdr tree))))))
;>  (square-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)))
;(mcons 1 (mcons (mcons 4 (mcons (mcons 9 (mcons 16 '())) (mcons 25 '()))) (mcons (mcons 36 (mcons 49 '())) '())))
;>
(define (square-tree tree)
  (define (st x)
    (if (atom? x) (square x)
       (square-tree x)))
  (map st tree))
