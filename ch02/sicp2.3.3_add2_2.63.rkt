; 練習問題 2.63
;次の二つの手続きは、どちらも二分木をリストに変換する。
(load "sicp2.3.3_add2.rkt")
(define (tree->list-1 tree)
  (if (null? tree) '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))
(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree) result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree) result-list)))))
  (copy-to-list tree '()))

;;;;;;;;;;
; a. 二つの手続きは、すべての木に対して同じ結果を生成するだろうか。
;    そうでないとしたら、結果はどのように異なるだろうか。
;    二つの手続きは、図 2.16の木に対してどのようなリストを生成するだろうか。
(define fig2-16-1 '(7 (3 (1 () ()) (5 () ())) (9 () (11 () ()))))
(define fig2-16-2 '(3 (1 () ()) (7 (5 () ()) (9 () (11 () ())))))
(define fig2-16-3 '(5 (3 (1 () ()) ()) (9 (7 () ()) (11 () ()))))

(load "util.rkt")
; 二つの手続きは同じ結果を生成する。
;> (prn (tree->list-1 fig2-16-1))
;(1 3 5 7 9 11 )
;> (prn (tree->list-2 fig2-16-1))
;(1 3 5 7 9 11 )
;> (prn (tree->list-1 fig2-16-2))
;(1 3 5 7 9 11 )
;> (prn (tree->list-2 fig2-16-2))
;(1 3 5 7 9 11 )
;> (prn (tree->list-1 fig2-16-3))
;(1 3 5 7 9 11 )
;> (prn (tree->list-2 fig2-16-3))
;(1 3 5 7 9 11 )
;>

;;;;;;;;;;;;
; b. 二つの手続きは、n 要素のバランスの取れた木を変換する際
;    に、同じステップ数の増加オーダーを持っているだろうか。
;    そうでないなら、どちらが遅いだろうか。

; T(n)をノード数nのバランスツリーに対する手続きの所要時間とする。
;[tree->list-1の場合]
;  T(n) = 2*T(n/2) + O(n/2) (手続き append が線形時間を要するため)
; 上の式を解くと、T(n)=O(n * log n)となります。
;[tree->list-2の場合]
;  T(n) = 2*T(n/2) + O(1)
; 上の式を解くと、T(n)=O(n)となります。

