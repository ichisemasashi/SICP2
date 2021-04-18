; SICP 1.3.1 引数としての手続き

;a から b まで整数の和を計算する
(define (sum-integers a b)
  (if (< b a) 0
       (+ a (sum-integers (+ a 1) b))))

; 範囲内の整数について、三乗の和を計算する
(load "util.rkt")
(define (sum-cubes a b)
  (if (< b a) 0
       (+ (cube a) (sum-cubes (+ a 1) b))))

;次のような級数の和を計算する. (π/8に収束する。)
; 1/(1・3) + 1/(5・7) + 1/(9・11) + ...
(define (pi-sum a b)
  (if (< b a) 0
     (+ (/ 1.0 (* a (+ a 2)))
        (pi-sum (+ a 4) b))))

;;;;
; ↑の三つの手続きの背後には、明らかに共通のパターンがあります。
;(define (<name> a b)
;  (if (< b a) 0
;       (+ (<term> a)
;          (<name> (<next> a) b))))

; こういった共通パターンがあるということは、便利な抽象化が潜んでいて、見
; つけ出されるのを待っているということの強力な証拠です。

; 私たちの手続き言語を使うと、上に書いた共通のひな形を持ってきて、その “穴” を仮引数
; に変えるだけですぐにできます。

(define (sum term a next b)
  (if (< b a) 0
       (+ (term a)
          (sum term (next a) next b))))

(define (sum-cubes a b)
  (sum cube a inc b))

(define (sum-integers a b)
  (sum identity a inc b))

(define (pi-sum a b)
  (define (pi-term x)
    (/ 1.0 (* x (+ x 2))))
  (define (pi-next x)
    (+ x 4))
  (sum pi-term a pi-next b))


;; 関数 f の範囲 a から b の定積分
; F = [f(a + dx/2) + f(a + dx + dx/2) + f(a + 2dx + dx/2) + ...]dx
(define (integral f a b dx)
  (define (add-dx x)
    (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) dx))
