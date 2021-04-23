; SICP 2.1.4 add1
;中央値と許容誤差で表される数値を扱うプログラムに修正。
; 例: 3.5 ± 0.15のような区間を使って作業をしたい
(load "sicp2.1.4_2.08.rkt")
(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2.0))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2.0))
;実際の工学の現場では、測定値の誤差は小さなもので、区間の中央値に対する幅の割合として表されます。
;技師は普通、上で書いた抵抗のスペックのように、装置のパラメータに対するパーセント許容誤差を規定するものです。