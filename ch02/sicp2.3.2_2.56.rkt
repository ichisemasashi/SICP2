; 練習問題 2.56
;より多くの種類の式を扱えるようにこの基本的な
;微分プログラムを拡張するにはどうすればよいかを示せ。例えば、
;次の微分規則を実装せよ。
; d(u^n)/dx = nu^{n-1}・du/dx
;実装にあたっては、deriv プログラムに新しい節を追加し、また
;exponentiation?, base, exponent, make-exponentiation を適切
;に定義せよ (冪乗の表現には ** という記号を使ってもよい)。任意
;の数の 0 乗は 1 であり、任意の数の 1 乗はそれ自身であるという
;規則を組み込め。

(load "sicp2.3.2.rkt")
(define (exponentiation? e)
  (and (pair? e)
        (eq? (car e) '**)))
(define (base e)
  (cadr e))
(define (exponent e)
  (caddr e))
(define (make-exponentiation base exp)
  (cond ((=number? base 1) 1)
         ((=number? exp 0) 1)
         ((=number? exp 1) base)
         ((and (number? base) (number? exp)) (expt base exp))
         (else (list '** base exp))))
(define (deriv exp var)
  (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         ((sum? exp)
          (make-sum (deriv (addend exp) var)
                      (deriv (augend exp) var)))
         ((product? exp)
          (make-sum (make-product (multiplier exp) (deriv (multiplicand exp) var))
                      (make-product (deriv (multiplier exp) var) (multiplicand exp))))
         ((exponentiation? exp)
          (make-product
            (make-product (exponent exp)
                         (make-exponentiation (base exp)
                                            (if (number? (exponent exp))
                                               (- (exponent exp) 1)
                                               (' (- (exponent exp) 1)))))
            (deriv (base exp) var)))
         (else (error "unknown expression type -- DERIV" exp))))
(define X (make-exponentiation 'x 3))
(define A (make-exponentiation (make-sum (make-product 2 'x) 3) 3))
(define a (make-product 2 'x))
(define z (make-sum 'x 3))
(define b (make-sum (make-product 2 'x) 3))