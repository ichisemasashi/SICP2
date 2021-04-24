; 練習問題 2.16 なぜ代数的に等価な式が異なる答えになることがあるのか
;この欠点のない区間演算パッケージを開発することはできるだろうか。
;それとも、このタスクは不可能なのだろうか。


;区間演算システムでは, 代数の法則のいくつかが特定の操作に適用されないため、
;非区間演算システムでは等価な代数式が、区間演算システムでは必ずしも等価ではありません。
;例：a*(b+c) と a*b + a*c
(load "sicp2.1.4_add2.rkt")
(load "sicp2.1.4_add1_2.12.rkt")
(define a (make-interval 2 4))
(define b (make-interval -2 0))
(define c (make-interval 3 8))
(define i (mul-interval a (add-interval b c)))
(define j (add-interval (mul-interval a b) (mul-interval a c)))
;> i
;(mcons 32 2)
;> j
;(mcons 32 -2)
;> 