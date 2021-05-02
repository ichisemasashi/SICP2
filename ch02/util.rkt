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

(define (compose f g)
  (lambda (x) (f (g x))))

(define bonsai
   (load-painter "bonsai.gif"))

;(define wave
;  (segments->painter
;   (list (make-segment (make-vect 0.2 0.0) (make-vect 0.4 0.4))
;         (make-segment (make-vect 0.4 0.4) (make-vect 0.3 0.5))
;         (make-segment (make-vect 0.3 0.5) (make-vect 0.1 0.3))
;         (make-segment (make-vect 0.1 0.3) (make-vect 0.0 0.6))
;         (make-segment (make-vect 0.0 0.8) (make-vect 0.1 0.5))
;         (make-segment (make-vect 0.1 0.5) (make-vect 0.3 0.6))
;         (make-segment (make-vect 0.3 0.6) (make-vect 0.4 0.6))
;         (make-segment (make-vect 0.4 0.6) (make-vect 0.3 0.8))
;         (make-segment (make-vect 0.3 0.8) (make-vect 0.4 1.0))
;         (make-segment (make-vect 0.6 1.0) (make-vect 0.7 0.8))
;         (make-segment (make-vect 0.7 0.8) (make-vect 0.6 0.6))
;         (make-segment (make-vect 0.6 0.6) (make-vect 0.8 0.6))
;         (make-segment (make-vect 0.8 0.6) (make-vect 1.0 0.4))
;         (make-segment (make-vect 1.0 0.2) (make-vect 0.6 0.4))
;         (make-segment (make-vect 0.6 0.4) (make-vect 0.8 0.0))
;         (make-segment (make-vect 0.7 0.0) (make-vect 0.5 0.3))
;         (make-segment (make-vect 0.5 0.3) (make-vect 0.3 0.0)))))
