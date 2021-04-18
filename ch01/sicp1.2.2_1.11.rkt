; 練習問題 1.11
;

;; 再帰プロセス
(define (f n)
  (if (< n 3) n
      (+ (f (- n 1)) (f (- n 2)) (f (- n 3)))))


;; 反復プロセス
(define (ff n)
  (define (iter new old old2 count)
    (if (>= count n) new
        (iter (+ new old old2) new old (+ 1 count))))
  (iter 3 2 1 3))

(ff 10)
;=> 230
(f 10)
;=> 230

