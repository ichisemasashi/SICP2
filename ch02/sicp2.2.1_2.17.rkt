; 練習問題 2.17
;与えられた (空でない) リストの最後の要素のみを持つリストを返す手続き last-pair を定義せよ。
(define (last-pair l)
  (if (null? (cdr l)) l
     (last-pair (cdr l))))
;> (last-pair (list 23 72 149 34))
;(mcons 34 '())
;> 