; 練習問題 2.42  8クイーンパズル
;“8 クイーンパズル” とは、どのクイーンもほかのクイーンの利き筋に入らない
;(つまり、同じ行・列・対角線の上に二つのクイーンがあるということがないようにする) ように
;8 個のクイーンをチェス盤の上に置く方法を問うものである。
;このパズルを解くひとつのやり方として、
;各列にひとつのクイーンを置きながらチェス盤を横に移動していくというものがある。
;k − 1 個のクイーンを置いた状態では、k 個目のクイーンは、すでに盤上にあるどのクイーンも利き筋に入らない位置に置く必要がある。
;この解き方は再帰的に定式化できる。最初の k − 1 列に k − 1 個のクイーンを置くパターンをすべて生成済みだと想定する。
;それぞれのパターンに対して、k 列目のそれぞれの行にクイーンを置いていって、位置の集合を拡張したものを生成する。
;次にこれらをフィルタして、k 列目のクイーンがほかのクイーンに利かないものだけを残す。
;こうすると、最初の k 列に k 個のクイーンを置くすべてのパターンの列ができる。このプロセスを続けると、
;パズルの解答のひとつだけではなく、すべての解答が得られる。
;この解き方を queens という手続きとして実装し、n × n のチェス盤に n 個のクイーンを置くという問題に
;対するすべての答えの列を返すようにする。queens は、盤の最初の k 列にクイーンを置くすべてのパターンの列を返す内部手続き queen-cols を持っている。
(load "sicp2.2.3_add1.rkt")
(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0) (list empty-board)
       (filter (lambda (positions) (safe? k positions))
              (flatmap
               (lambda (rest-of-queens)
                 (map (lambda (new-row)
                        (adjoin-position
                         new-row k rest-of-queens))
                     (enumerate-interval 1 board-size)))
               (queen-cols (dec k))))))
  (queen-cols board-size))
;この手続きの中で、 rest-of-queens は最初の k − 1 列に k − 1 個のクイーンを置くパターンのひとつで、
;new-row は k 列目のクイーンを置く候補となる行である。
;盤上の位置集合に対する表現方法と、位置集合に新しい行・列の位置を追加する adjoin-position 手続きと
;位置の空集合を表す empty-board を実装し、プログラムを完成させよ。
(define (adjoin-position new-row k rest-of-queens)
  (cons (list new-row k) rest-of-queens))
(define empty-board nil)

;また、位置集合に対して、k 列目のクイーンがほかのクイーンに利いていないかを調べる safe? 手続きも書く必要がある
;(新しいクイーンの利きだけをチェックすればいいということに注意。ほかのクイーンは互いに利いていないことが保証済みである)。
(define (safe? k positions)
  (let ((trial (car positions))
         (trial-row (caar positions))
         (trial-col (cadar positions))
         (rest (cdr positions)))
    (define (f pos result)
      (let ((row (car pos))
             (col (cadr pos)))
        (and (not (= (- trial-row trial-col) (- row col)))
              (not (= (+ trial-row trial-col) (+ row col)))
              (not (= trial-row row))
              result)))
    (accumulate f true rest)))