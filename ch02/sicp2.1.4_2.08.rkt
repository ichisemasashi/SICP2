; 練習問題 2.8 二つの区間の差
(load "sicp2.1.4.rkt")
(load "sicp2.1.4_2.07.rkt")

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (lower-bound y))
                    (- (upper-bound x) (upper-bound y))))
