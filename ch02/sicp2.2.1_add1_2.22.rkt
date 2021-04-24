; 練習問題 2.22
;square-list 手続きを書き直し、反復プロセスを展開するようにしようとしている。
(load "util.rkt")
(define (square-list items)
  (define (iter things answer)
    (if (null? things) answer
       (iter (cdr things) (cons (square (car things)) answer))))
  (iter items nil))
;> ( square-list (list 1 2 3 4))
;(mcons 16 (mcons 9 (mcons 4 (mcons 1 '()))))
;>
;答えとなるリストは望むものの逆順になってしまう。なぜだろうか。
;=> answerとしてconsしている順序が逆だから。
;---
;cons の引数を逆順にしてバグを直そうとした。
(define (square-list items)
  (define (iter things answer)
    (if (null? things) answer
       (iter (cdr things) (cons answer (square (car things))))))
  (iter items nil))
;> ( square-list (list 1 2 3 4))
;(mcons (mcons (mcons (mcons '() 1) 4) 9) 16)
;> 
;これもうまくいかない。説明せよ。
;=> リストの終端がnilでないから。