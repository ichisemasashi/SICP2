; 練習問題 2.6 チャーチ数(Church numeral)
; 手続きを扱うことができる言語では、(少なくとも、非負整数に関する限りは) 数値なしでもやっていける。
;0と、1 を足すという演算
(define zero
  (lambda (f)
    (lambda (x)
      x)))
(define (add-1 n)
  (lambda (f)
    (lambda (x)
      (f ((n f) x)))))
;---
;one と two を直接 (zero と add-1 を使わずに) 定義せよ
;(ヒント:置換を使って (add-1 zero) を評価する)。
; (add-1 zero)
;=> (lambda (f)
;      (lambda (x)
;        (f ((zero f) x))))
;=> (lambda (f)
;       (lambda (x)
;         (f ((lambda (x) x) x))))
;=> (lambda (f)
;       (lambda (x)
;         (f x)))
(define one
  (lambda (f)
    (lambda (x) (f x))))
; (add-1 one)
;=> (lambda (f)
;      (lambda (x)
;        (f ((one f) x))))
;=> (lambda (f)
;      (lambda (x)
;        (f ((lambda (x) (f x)) x))))
;=> (lambda (f)
;      (lambda (x)
;        (f (f x))))
(define two
  (lambda (f)
    (lambda (x) (f (f x)))))
; maybe
(define three
  (lambda (f)
    (lambda (x)
      (f (f (f x))))))

;加算手続きの直接的な定義 +(add-1 の繰り返し適用は用いない) を与えよ。
;(define (add a b)
;  (lambda (f)
;    (lambda (x)
;      ...)))
;... = (f (f (f (f ...(f x) ; fが(a+b)個並ぶ

;(define (add-1 n)
;  (lambda (f)
;    (lambda (x)
;      (f ((n f) x))))) ;<= fが(n+1)個並ぶ

(define (add a b)
  (lambda (f)
    (lambda (x)
      ((a f) ((b f) x)))))

;; for print
(define (inc x)
  (+ x 1))
(define (to-s z)
  ((z inc) 0))
