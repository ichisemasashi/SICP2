; 練習問題 2.37 行列演算
;ベクトル v = (v_i ) を数値の列として表現し、行列m = (m_{ij}) をベクトル (行列の行) の列として表現するとする。
;例えば、以下の行列は
; / 1 2 3 4 \
; | 4 5 6 6 |
; \ 6 7 8 9 /
;列 ((1 2 3 4) (4 5 6 6) (6 7 8 9)) として表現される。
;この表現を使うと、列操作によって基本的な行列とベクトルの演算を簡潔に表現できる。
;(dot-product v w)       総和Σ_i v_i w_i を返す
;(matrix-*-vector m v)   t_i = Σ_j m_{ij} v_j であるようなベクトルtを返す
;(matrix-*-matrix m n)   p_ij = Σ_k m_{ik} n_{kj} であるような行列pを返す
;(transpose m)            n_{ij} = m_{ji} であるような行列nを返す
(load "sicp2.2.3_2.36.rkt")
;内積は、次のように定義できる。
(define (dot-product v w)
  (accumulate + 0 (map * v w)))
;ほかの行列演算を計算する以下の手続きについて、欠けた式を補え
(define (matrix-*-vector m v)
  (map (lambda (r) (dot-product r v)) m))
(define (transpose m)
  (accumulate-n cons nil m))
(define (matrix-*-matrix m n)
  (let ((nt (transpose n)))
    (map (lambda (r) (matrix-*-vector nt r)) m)))

(define a (list 1 2 3))
(define b (list 4 5 6))
(define c (list 2 3 4 5))
(define m (list (list 1 2 3 4) (list 5 6 7 8) (list 9 10 11 12)))
(define n (list (list 1 2) (list 1 2) (list 1 2) (list 1 2)))
;> (dot-product a b)
;32
;> (matrix-*-vector m c)
;(mcons 40 (mcons 96 (mcons 152 '())))
;> (transpose m)
;(mcons (mcons 1 (mcons 5 (mcons 9 '()))) (mcons (mcons 2 (mcons 6 (mcons 10 '()))) (mcons (mcons 3 (mcons 7 (mcons 11 '()))) (mcons (mcons 4 (mcons 8 (mcons 12 '()))) '()))))
;> (matrix-*-matrix m n)
;(mcons (mcons 10 (mcons 20 '())) (mcons (mcons 26 (mcons 52 '())) (mcons (mcons 42 (mcons 84 '())) '())))
;> 