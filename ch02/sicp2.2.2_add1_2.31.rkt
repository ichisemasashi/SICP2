; 練習問題 2.31 手続き tree-mapを作れ。
(define (tree-map fn tree)
  (define (f x)
    (if (atom? x) (fn x)
       (tree-map fn x)))
  (map f tree))

(load "util.rkt")
(define (square-tree tree)
  (tree-map square tree))
;> (square-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)))
;(mcons 1 (mcons (mcons 4 (mcons (mcons 9 (mcons 16 '())) (mcons 25 '()))) (mcons (mcons 36 (mcons 49 '())) '())))
;> 