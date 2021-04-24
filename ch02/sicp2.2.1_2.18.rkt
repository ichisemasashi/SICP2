; 練習問題 2.18
;リストを引数として取り、同じ要素を逆順に持つリストを返す手続き reverse を定義せよ。
(define (reverse l)
  (define (iter s result)
    (if (null? s) result
       (iter (cdr s) (cons (car s) result))))
  (iter l nil))
;> (reverse (list 1 4 9 16 25))
;(mcons 25 (mcons 16 (mcons 9 (mcons 4 (mcons 1 '())))))
;> 