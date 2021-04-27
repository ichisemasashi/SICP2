; 練習問題 2.40
(load "sicp2.2.3_add1.rkt")
;整数 n に対し、1 ≤ j < i ≤ n となるペア (i, j) の列を生成する手続き unique-pairs を定義せよ。
(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (list i j)) (enumerate-interval 1 (- i 1))))
             (enumerate-interval 1 n)))

;unique-pairs を使って上の prime-sum-pairs の定義を簡単にせよ。
(define (prime-sum-pairs n)
  (map make-pair-sum (filter prime-sum? (unique-pairs n))))