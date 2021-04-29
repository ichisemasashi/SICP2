; 練習問題 2.43 非常に遅い queens 手続き
(load "sicp2.2.3_add1_2.42.rkt")
;(define (queens board-size)
;  (define (queen-cols k)
;    (if (= k 0) (list empty-board)
;       (filter (lambda (positions) (safe? k positions))
;              (flatmap
;               (lambda (rest-of-queens)
;                 (map (lambda (new-row)
;                        (adjoin-position
;                         new-row k rest-of-queens))
;                     (enumerate-interval 1 board-size)))
;               (queen-cols (dec k))))))
;  (queen-cols board-size))

(define (slow-queens board-size)
  (define (queen-cols k)
    (if (= k 0) (list empty-board)
       (filter (lambda (positions) (safe? k positions))
              (flatmap
               (lambda (new-row)
                 (map (lambda (rest-of-queens)
                        (adjoin-position
                         new-row k rest-of-queens))
                     (enumerate-interval 1 board-size)))
               (queen-cols (dec k))))))
  (queen-cols board-size))
; flatmap 内のマップのネストの順番を次のように逆にしてしまっている
;なぜプログラムの実行が遅くなるのか説明せよ。
;練習問題 2.42のプログラムが 8クイーンパズルを解く時間を T として、
;このプログラムがパズルを解くのにかかる時間を見積もれ。
;---
;flatmapでマッピングの順番を入れ替えると、（enumerate-interval 1 board-size）のすべての項目で
;queen-colsを再評価することになります。そのため、すべての再帰レベルにおいて、
;board-sizeの回数ぶん、作業全体を繰り返す必要があります。
;常にboard-sizeの再帰があるので、全体の作業は(board-size)^(board-size)の回数複製される
;ことになります。
;したがって、正しい順序でboard-size=8の場合、関数の実行にT時間かかるとすると、
;順序を入れ替えた場合、実行には(8^8)Tかかることになります。