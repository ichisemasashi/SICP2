;
; SICP 1.2.4
; 指数計算
;

; b^nを求める手続き
; 再帰的定義：b^n =b·b^(n−1), b^0 =1

; 線形再帰プロセス
; Θ(n) のステップ数と Θ(n) の空間
(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))

; 線形反復
; Θ(n) のステップ数と Θ(1) の空間
(define (expt b n)
  (expt-iter b n 1))
(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b
                 (- counter 1)
                 (* b product))))


; b^n = (b^(n/2))2    n が偶数の場合,
; b^n = b · b^(n−1)   n が奇数の場合.
; Θ(log n)
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))
(define (even? n)
  (= (remainder n 2) 0))
(define (square x)
  (* x x))

