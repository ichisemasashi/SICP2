; SICP 2.2.2 add1 階層構造/木に対するマップ
;map に再帰を組み合わせたものは木を扱うための強力な抽象化になります。

;引数としては、数値の係数と、葉が数値である木を取ります。
;返り値は同じ形の木で、それぞれの数値が係数倍されたものとなるscale-tree手続き
(define (scale-tree tree factor)
  (cond ((null? tree) nil)
         ((not (pair? tree)) (* tree factor))
         (else (cons (scale-tree (car tree) factor)
                       (scale-tree (cdr tree) factor)))))
;> ( scale-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)) 10)
;(mcons 10 (mcons (mcons 20 (mcons (mcons 30 (mcons 40 '())) (mcons 50 '()))) (mcons (mcons 60 (mcons 70 '())) '())))
;>
;scale-tree の別の実装方法として、木を部分木の列と見なして map を使うというものがあります。
;列にマップを行い、それぞれの部分木を順番に係数倍し、結果のリストを返すということになります。
;木が葉である基本ケースでは、単純に係数倍します。
(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
            (scale-tree sub-tree factor)
            (* sub-tree factor)))
      tree))
;木の操作の多くは、列の操作と再帰を組み合わせて同じように実装できます。