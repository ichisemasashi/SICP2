; 練習問題 2.23 map に似ている手続き for-each
;引数として手続きと要素のリストを取る。
;しかし、結果のリストを生成するのではなく、
;for-each は手続きをそれぞれの要素に左から右に順番に手続きを適用していくだけである。
;手続きを要素に適用して返される値はまったく使わない
;for-each への呼び出しに返される値は何でもよく、例えば真の値などでもよい。
;for-each を実装せよ。
(define (for-each f seq)
  (map f seq)
  true)
;> (for-each (lambda (x) (newline) (display x)) (list 57 321 88))
;
;57
;321
;88#t
;> 