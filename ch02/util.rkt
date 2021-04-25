; utility
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
(define (square x)
  (* x x))
(define (atom? x)
  (not (pair? x)))
;; フィボナッチ数を反復的に計算
(define (fib n)
  (fib-iter 1 0 n))
(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))
