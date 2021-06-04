; 練習問題 2.64
; 次の手続き list->tree は、順序つきリストをバランスの取れた木に変換する。
; 補助手続き partial-tree は、整数 n と、少なくとも n 個の要素を持つリストを引数に取り、
; リストの最初の n 個の要素を含むバランスの取れた木を生成する。
; partial-tree の返り値はペア (cons で構築される) で、car には構築された木を持ち、
; cdr には木に含まれなかった要素のリストを持つ。
(load "sicp2.3.3_add2.rkt")
(load "util.rkt")
(define (list->tree elements)
  (car (partial-tree elements (length elements))))
(define (partial-tree elts n)
  (if (= n 0) (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result
               (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result
                   (partial-tree (cdr non-left-elts)
                                 right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry
                                 left-tree
                                 right-tree)
                      remaining-elts))))))))

;;;;;;;;;;
; a.
; partial-treeがどのように動くのか
; リスト (1 3 5 7 9 11) に対して list->tree が生成する木を描け。
;> (prn (list->tree '(1 3 5 7 9 11)))
;(5 (1 () (3 () () )(9 (7 () () (11 () () )))))

;   5
; /  \
;1    9
; \   / \
;  3 7   11

;PARTIAL-TREEは、リストELTSを、中央値のアイテムTHIS-ENTRY、中央値より小さいアイテムのリスト、
;中央値より大きいアイテムのリストの3つの部分に分割します。ルートノードがTHIS-ENTRY、左サブツリーが
;小さい要素のPARTIAL-TREE、右サブツリーが大きい要素のPARTIAL-TREEとなる二分木を作成します。

;;;;;;;;;;;;
; b.
;list->tree が n 要素のリストを変換するのに必要なステップ数の増加オーダーはどのようになるだろうか。

;PARTIAL-TREEは各ステップで、長さnのリストをおおよその長さn÷2の2つのリストに分割します。
;リストを分割するための作業は、(QUOTIENT (- N 1) 2)と(- N (+ LEFT-SIZE 1))で、
;どちらも一定時間かかる。結果を結合するための作業は、(MAKE-TREE THIS-ENTRY LEFT-TREE RIGHT-TREE)で、
;これも一定です。したがって、n個の要素を持つリストの部分木を作るための時間は
;
;T(n) = 2T(n÷2) + Θ(1)
;
;マスター定理により、a = 2, b = 2, f(n) = Θ(1)となります。
;したがって、T(n)=Θ(n)となります。
;
;長さnのリストに対するLIST->TREEの所要時間は、PARTIAL-TREEの所要時間に、
;そのリストに対するLENGTHの所要時間を加えたものになります。
;どちらの手続きも成長の順番がΘ(n)なので、LIST->TREEの成長の順番はΘ(n)となります。

