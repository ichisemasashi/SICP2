; SICP 2.1.4 add2
;並列抵抗の式が代数的に等価な以下の二つの方法で書ける
;R = R1R2/(R1+R2)
;  = 1/{1/R1 + 1/R2}
;---
;並列抵抗の式を異なったやり方で計算する手続き
(load "sicp2.1.4_add1.rkt")
(load "sicp2.1.4_2.11.rkt")
(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                   (add-interval r1 r2)))
(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval
      one
      (add-interval (div-interval one r1)
                       (div-interval one r2)))))
;par1とpar2は異なる値を返す