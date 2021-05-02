; 練習問題 2.44
;corner-split で使われている up-split 手続きを定義せよ。
(load "sicp2.2.4.rkt")
(define (up-split painter n)
  (if (= n 0) painter
     (let ((smaller (up-split painter (dec n))))
       (below painter (beside smaller smaller)))))
;(paint (up-split einstein 3))
;(paint (corner-split einstein 2))