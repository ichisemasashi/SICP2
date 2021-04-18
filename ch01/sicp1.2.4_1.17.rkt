;
; 練習問題 1.17
;

; かけ算手続き(b に対して線形のステップ数を取る)
(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

; 整数を倍にする
(define (double x)
  (+ x x))

; (偶数の) 整数を 2 で割る
(define (halve x)
  (/ x 2))

; 対数的ステップ数を取るかけ算手続き
(define (mul a b)
  (mul-iter 0 a b))
(define (mul-iter acc a b)
  (cond ((= b 0) acc)
        ((even? b) (mul-iter acc (double a) (halve b)))
        (else (mul-iter (+ acc a) a (- b 1)))))

(define (even? n)
  (= (remainder n 2) 0))

; racket@> (require racket/trace)
; racket@> (trace <procedure name>)
