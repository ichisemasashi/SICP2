; 練習問題 2.36
;手続き accumulate-n は accumulate に似ているが、
;三番目の引数として列の列を取る (要素となる列の⻑さは一定であるとする) という違いがある。
;この手続きは、指定された集積手続きを適用してそれぞれの列の最初の要素を結合したもの、それ
;ぞれの列の二番目の要素を結合したもの . . . を返り値とする。
;例えば、s が ((1 2 3) (4 5 6) (7 8 9) (10 11 12)) という四つの列を持つ列であるときに
;(accumulate-n + 0 s) の値が (22 26 30)になるようにする。
;次の accumulate-n の定義に欠けている式を埋めよ。
(load "sicp2.2.3.rkt")

; 2.2.3のaccumulate
;(define (accumulate op init seq)
;  (if (null? seq) init
;     (op (car seq)
;          (accumulate op init (cdr seq)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs)) nil
     (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))
(define s (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))
;> (accumulate-n + 0 s)
;(mcons 22 (mcons 26 (mcons 30 '())))
;> 