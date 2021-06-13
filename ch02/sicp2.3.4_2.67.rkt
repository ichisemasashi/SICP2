; 練習問題 2.67
;符号化木とサンプルメッセージを次のように定義する。
(load "sicp2.3.4.rkt")

(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree (make-leaf 'B 2)
                                  (make-code-tree (make-leaf 'D 1)
                                                  (make-leaf 'C 1)))))
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

;decode 手続きを使ってメッセージを復号し、結果を示せ。
;> (prn (decode sample-message sample-tree))
;(A D A B B C A )
