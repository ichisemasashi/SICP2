; SICP 2.1.4 add1
;ほしいのは中央値と許容誤差で表される数値を扱うプログラムだ
;例えば、3.5 ± 0.15のような区間
(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2.0))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2.0))
