; 練習問題 1.3
;

(define (square x)
  (* x x)) 
  
(define (squareSum x y)
  (+ (square x) (square y)))

;
;(define (sumOfLargestTwoSquared x y z) 
;  (cond ((and (>= (+ x y) (+ y z)) (>= (+ x y) (+ x z))) (squareSum x y)) 
;        ((and (>= (+ x z) (+ y z)) (>= (+ x z) (+ x y))) (squareSum x z)) 
;        (else (squareSum y z))))

(define (sumOfLargestTwoSquared x y z)
  (cond ((and (< x y) (< x z)) ; xが最小
         (squareSum y z))
        ((and (< y x) (< y z)) ; yが最小
         (squareSum x z))
        (else (squareSum x y))))

(sumOfLargestTwoSquared 1 2 3)
;=> 13
(sumOfLargestTwoSquared 3 2 1)
;=> 13
(sumOfLargestTwoSquared 2 3 1)
;=> 13
