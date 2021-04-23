; 練習問題 2.10 ゼロをまたぐ区間で割った場合にどうなるかはっきりしていない
;この条件についてチェックして、もしこれが起こればエラーのシグナルを送るようにせよ。
(load "sicp2.1.4_2.08.rkt")
; 元のdiv-interval
;(define (div-interval x y)
;  (mul-interval x (make-interval (/ 1.0 (upper-bound y))
;                                       (/ 1.0 (lower-bound y)))))
(define (div-interval x y)
  (let ((l (lower-bound y))
         (u (upper-bound y)))
    (if (<= (* l u) 0)
       (error "Division error (interval spans 0)." y)
       (mul-interval
          x
          (make-interval (/ 1.0 u) (/ 1.0 l))))))
