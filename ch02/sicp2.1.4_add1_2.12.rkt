; 練習問題 2.12
; 中央値とパーセント許容誤差を取り、求める範囲を返すコンストラクタ make-center-percent を定義せよ。
(load "sicp2.1.4_add1.rkt")
(load "sicp2.1.4_2.11.rkt")
(define (make-center-percent c p)
  (let ((width (* c (/ p 100.0))))
    (make-center-width c width)))
;---
;与えられた区間に対してパーセント許容誤差を返すセレクタ percent
(define (percent z)
  (let ((c (center z))
         (w (width z)))
    (* 100 (/ w c))))
;> (define i (make-center-percent 10 50))
;> (center i)
;10.0
;> (width i)
;5.0
;> (upper-bound i)
;15.0
;> (lower-bound i)
;5.0
;> (percent i)
;50.0
;> 