; 練習問題 2.21 引数として数値のリストを取り、それらの数値の二乗の列を持つリストを返す手続き square-list
;二つの異なる square-list の定義を完成させよ。
(load "util.rkt")
(define (square-list seq)
  (if (null? seq) nil
     (cons (square (car seq)) (square-list (cdr seq)))))
(define (square-list seq)
  (map square seq))