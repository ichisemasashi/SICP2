; 練習問題 2.50
;ペインタを左右逆にする変換 flip-horiz、
;ペインタを反時計回りに 180 度、270 度回転させる変換を定義せよ。
(load "sicp2.2.4_add4.rkt")
(define (flip-horiz painter)
  (transform-painter painter
                    (make-vect 1.0 0.0)
                    (make-vect 0.0 0.0)
                    (make-vect 1.0 1.0)))
(define (rotate180 painter)
  (rotate90 (rotate90 painter)))
(define (rotate270 painter)
  (rotate90 (rotate90 (rotate90 painter))))