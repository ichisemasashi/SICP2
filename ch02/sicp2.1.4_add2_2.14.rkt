; 練習問題 2.14
(load "sicp2.1.4_add2.rkt")
(load "sicp2.1.4_add1_2.12.rkt")
; いろいろな数値演算の式についてこのシステムの挙動を調査せよ。
(define x (make-interval 2 8))
(define y (make-interval 5 6))
;> (par1 x y)
;(mcons 6.857142857142857 0.7142857142857142)
;> (par2 x y)
;(mcons 3.428571428571429 1.4285714285714286)
;> 

;何らかの区間 A と Bを作成し、それらを使って式 A/A と A/B を計算せよ
(define A/A (div-interval x x))
(define A/B (div-interval x y))
;> A/A
;(mcons 4.0 0.25)
;> A/B
;(mcons 1.6 0.3333333333333333)
;>

;中央値-パーセント形式の計算結果を調べよ。
(define i (make-center-percent 10 5))
(define j (make-center-percent 32 3))
;> (par1 i j)
;(mcons 8.536753823384311 6.785089737689829)
;> (par2 i j)
;(mcons 7.963184537505754 7.273803650715343)
;> 
