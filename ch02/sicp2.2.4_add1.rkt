; SICP 2.2.4 add1 例: 図形言語/高階演算
;ペインタ演算を操作対象の要素として扱い、それらの要素を組み合わせる手段
;—ペインタ演算を引数として取り、新しいペインタ演算を作るような手続き—
;を書くことができる

;四つの一引数ペインタ演算を引数として取り、ある与えられたペインタをこれらの四つの演算によって
;変形したものを正方形に配置するペインタ演算を作る手続き
;tl, tr, bl, br は、それぞれ左上、右上、左下、右下の画像に適用する変換です
(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
           (bottom (beside (bl painter) (br painter))))
      (below bottom top))))
;こうすると、flipped-pairs は square-of-four によって以下のように定義できます。
(define (flipped-pairs painter)
  (let ((combine4 (square-of-four
                       identity flip-vert identity flip-vert)))
    (combine4 painter)))
;等価な書き方
;(define flipped-pairs
;  (square-of-four identity flip-vert identity flip-vert))
;また、square-limit は次のように表現できます。
(load "sicp2.2.4_2.44.rkt")
(load "util.rkt")
(define (square-limit painter n)
  (let ((combine4 (square-of-four
                       flip-horiz identity rotate180 flip-vert)))
    (combine4 (corner-split painter n))))
(define rotate180 (compose flip-vert flip-horize))