; 練習問題 2.29 二枝モビール
;二枝モビールは、左の枝と右の枝のという二つの枝から構成されている。
;それぞれの枝はある⻑さを持つ棒で、おもりか別の二枝モビールがぶら下がっている。
;二枝モビールは、二つの枝によって構成することで、(例えば list を使って) 複合データによって表現できる。
(define (make-mobile left right)
  (list left right))
;枝は、⻑さ length(必ず数値) と構造 structure からなり、
;structureは数値 (単純なおもりを表す) か、または別のモビールである。
(define (make-branch length structure)
  (list length structure))
;;;;;;;;;;
; a
;これに対応する、モビールの枝を返すセレクタ left-branchと right-branch、
;枝の構成要素を返す branch-length と branch-structure を書け。
(define (left-branch m)
  (car m))
(define (right-branch m)
  (car (cdr m)))
(define (branch-length b)
  (car b))
(define (branch-structure b)
  (car (cdr b)))
;;;;;;;;;;
; b
;これらのセレクタを使って、モビールの総重量を返す手続き total-weight を定義せよ。
; 構造(structure)がおもりかどうか判定。
(define (st-weight? structure)
  (not (pair? structure)))
; 枝の先の構造がおもりか？
(define (br-weight? branch)
  (if (not (pair? branch)) false
     (st-weight? (branch-structure branch))))
(define (total-weight mobile)
  (define (branch-weight branch)
    (if (null? branch) 0
       (let ((st (branch-structure branch)))
         (if (br-weight? branch) st
            (+ (branch-weight (left-branch st))
              (branch-weight (right-branch st)))))))
  (cond ((st-weight? mobile) mobile)
         ((br-weight? mobile) (branch-structure mobile))
         (else (+ (branch-weight (left-branch mobile))
                 (branch-weight (right-branch mobile))))))

(define x (make-branch 2 3))
(define a (make-mobile x x))

;;;;;;;;;;
; c
;モビールについて、バランスが取れている (balanced) というのは、
; - 一番上の左枝にかかるトルク (回転力) が一番上の右の枝にかかるトルクと等しく
;   (つまり、左の棒の⻑さとかかる重さの積が、右の棒についてのその積と等しい) 、
; - かつ両枝からぶら下がっている各部分モビールのバランスが取れている
;状態について言う。
;ある二枝モビールがバランスが取れているかどうかテストする述語を設計せよ。

; 枝のトルクを求める手続き
(define (torque branch)
  (if (br-weight? branch)
     (* (branch-length branch)
        (branch-structure branch))
    (* (branch-length branch)
       (total-weight (branch-structure branch)))))
; mobileの場合分け
; null  --> trueで様子見
; atom  --> st-weight?がtrue
; (atom) --> atom? car, null? cdr
; (list) --> 以下に混ぜることが可能
; (atom atom) --> trueで様子見
; (atom list)
; (list atom)
; (list list)=(branch,branch) --> この場合だけ計算できる
; branchの場合分け
; (atom atom)=(len,wei) --> br-weight?がtrue
; (atom list)=(len,branch) --> br-weight?がfalse
(define (balanced? mobile)
  (cond ((null? mobile) true)
         ((and (pair? mobile)
                (pair? (left-branch mobile))
                (pair? (right-branch mobile)))
          (let ((l (left-branch mobile))
                 (r (right-branch mobile)))
            (cond ((pair? (branch-length l)) (error "incorrect branch left" l))
                   ((pair? (branch-length r)) (error "incorrect branch right" r))
                   ((and (br-weight? l) (br-weight? r))
                    (= (torque l) (torque r)))
                   ((br-weight? l)
                    (and (= (torque l) (torque r))
                          (balanced? (branch-structure r))))
                   ((br-weight? r)
                    (and (= (torque l) (torque r))
                          (balanced? (branch-structure l))))
                   (else (and (= (torque l) (torque r))
                                (balanced? (branch-structure l))
                                (balanced? (branch-structure r)))))))
         (else (error "incorrect mobile" mobile))))
(define b (make-branch 10 a))
(define c (make-branch 12 5))
(define d (make-mobile b c))
(define m1 (make-mobile (make-branch 4 6)
                            (make-branch 5 (make-mobile
                                                (make-branch 3 7)
                                                (make-branch 9 8)))))

;;;;;;;;;;
; d
;モビールの表現を変更し、以下のようなコンストラクタにする。
(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure))
;あなたのプログラムを新しい表現に移行するにはどの程度の変更が必要だろうか。
(define (right-branch m)
  (cdr m))
(define (branch-structure b)
  (cdr b))

(define X (make-branch 12 45))
(define A (make-mobile X X))
(define B (make-branch 9 A))
(define C (make-branch 79 3))
(define D (make-mobile B C))
;> (right-branch A)
;(mcons 12 45)
;> (right-branch X)
;45
;> (balanced? D)
;#f
;> (balanced? A)
;#t
;> (branch-structure X)
;45
;> 
