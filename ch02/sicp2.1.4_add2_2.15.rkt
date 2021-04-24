; 練習問題 2.15
;別のユーザーも、代数的に等価な異なる式によって計算すると異なる区間になることに気がついた。
;不確定な数値を表す変数が繰り返し出てこないように書けば、より厳密な誤差限界を返すようにできる
;つまり、並列抵抗を計算するのに par2 は par1 よりも “よりよい” プログラムだ
;彼女は正しいだろうか。また、それはなぜだろうか。
;[参考] par1 par2
;(define (par1 r1 r2)
;  (div-interval (mul-interval r1 r2)
;                   (add-interval r1 r2)))
;(define (par2 r1 r2)
;  (let ((one (make-interval 1 1)))
;    (div-interval
;      one
;      (add-interval (div-interval one r1)
;                       (div-interval one r2)))))
;---
;引数r1,r2が不確かな値(非ゼロの幅)であるとき、oneは幅がゼロなので
;par1は不確かな値同士の計算が3回(mul,add,div)、
;par2は不確かな値同士の計算が1回(add)
;つまり、par2はpar1より「よりよい」結果を出すプログラムである。