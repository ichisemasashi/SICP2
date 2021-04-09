
(define (square x)
  (* x x))

;(define false #f)
;(define true #t)

;(define (runtime)
;  (current-milliseconds))

(define (cube x)
  (* x x x))

(define (prime? n)
  (if (= 1 n) false
     (= n (smallest-divisor n))))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((< n (square test-divisor)) n)
        ; もし n が素数でないならば、それは√n 以下の約数を持つ
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (< b a) result
       (iter (next a) (combiner result (term a)))))
  (iter a null-value))
(define (sum term a next b)
  (accumulate + 0 term a next b))
