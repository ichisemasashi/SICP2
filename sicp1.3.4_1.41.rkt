; 練習問題 1.41
;引数がひとつの手続きを引数として取り、その手続きを二回適用する手続きを返す手続き double を定義せよ。
(define (double f)
  (lambda (x) (f (f x))))
; (((double (double double)) inc) 5)