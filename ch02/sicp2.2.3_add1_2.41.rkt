; 練習問題 2.41
;ある整数 n 以下の異なる正の整数が大小順に並んだ三つ組 i, j, k の中で、
;合計がある整数 s となるものすべてを見つける手続きを書け。
(load "sicp2.2.3_add1.rkt")
(define (unique-tuples n k)
  (define (iter m k)
    (if (= k 0) (list nil)
       (flatmap (lambda (j) (map (lambda (tuple) (cons j tuple)) (iter (inc j) (dec k))))
                  (enumerate-interval m n))))
  (iter 1 k))
(define (triples-of-sum s n)
  (filter (lambda (seq) (= (accumulate + 0 seq) s)) (unique-tuples n 3)))