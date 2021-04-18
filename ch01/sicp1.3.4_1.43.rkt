; 練習問題 1.43
;f が数値関数で n が正の整数であれば、f の n 回適用というものを作ることができ、
;それは x での値が f (f (. . . (f (x)) . . . ))である関数として定義できる。
;入力として f を計算する手続きと正の整数 n を取り、f の n 回適用を計算する手続きを返す手続きを書け。
(load "sicp1.3.4_1.42.rkt")
(load "util.rkt")
(define (repeat f n)
  (if (< n 1) (lambda (x) x)
     (compose f (repeat f (dec n)))))
;> ((repeat square 2) 5) 
;625
;>
(define (repeat f n)
  (define (iter n result)
    (if (< n 1) result
       (iter (dec n) (compose f result))))
  (iter n identity))
