; SICP 2.2.2 階層構造
;リストによる列の表現は、要素がそれ自身列であるような列を表現するように自然に一般化できます
;例 オブジェクト ((1 2) 3 4)は、三つの項目を持つリストとして見ることができ、
;その一つ目の項目はそれ自身が (1 2) というリストということになります。

;要素が列であるような列は、木 (tree) として考えることもできます。
;列の要素は木の枝で、それ自身が列である要素は部分木となります。
;再帰は木構造を扱う自然なツールです。
;再帰を使うことで、木への演算をその枝に対する演算に縮約し、
;それを今度は枝の枝に対する演算に縮約し . . .と続けていくことで木の葉にたどり着く、
;というようにできることがよくあります。

; 2.2.1 節の length 手続きと、木の葉の総数を返す count-leaves 手続きを比べてみましょう。
(load "sicp2.2.1.rkt")
( define x (cons (list 1 2) (list 3 4)))
;> (length x)
;3
;> (length (list x x))
;2
;>
;( count-leaves x) ;=> 4
;(count-leaves (list x x)) ;=> 8

;length の計算で使った再帰計画
;• リスト x の length は、x の cdr の length に 1 を足した値である。
;• 空リストの length は 0 である。

;count-leaves も似たようなものになります。
;• 空リストの count-leaves は 0 である。
;• 木 x の count-leaves は、 x の car の count-leaves と x の cdr の count-leaves を足した値である。
;• 葉の count-leaves は 1 である。
; 引数がペアであるかどうかをテストする手続きpair?
(define (count-leaves tree)
  (cond ((null? tree) 0)
         ((not (pair? tree)) 1)
         (else (+ (count-leaves (car tree))
                   (count-leaves (cdr tree))))))