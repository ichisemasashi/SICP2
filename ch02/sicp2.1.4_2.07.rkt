; 練習問題 2.7
(define (make-interval a b)
  (let ((up (max a b))
         (down (min a b)))
    (cons up down)))
(define (upper-bound z)
  (car z))
(define (lower-bound z)
  (cdr z))
