; 練習問題 2.4 手続きによるペアの表現
; この表現で、任意のオブジェクト x と y に対して、(car (cons x y)) が x を返すことを確認せよ。
(define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))
; (ヒント:これが動作することを確認するには1.1.5 節の置換モデルを利用する)
; === 適用順序評価: 手続き適用の置換モデル
; (f 5)
; f の本体を取得
; (sum-of-squares (+ a 1) (* a 2))
; 仮引数である a を、引数 5 で置き換え
; (sum-of-squares (+ 5 1) (* 5 2))
; (+ (square 6) (square 10))
; (+ (* 6 6) (* 10 10))
; (+ 36 100)
; 136
;---
; (car (cons x y))
;=> (car (lambda (m) (m x y))
;=> ((lambda (m) (m x y)) (lambda (p q) p))
;=> ((lambda (p q) p) x y)
;=> x


;対応する cdr の定義はどうなるだろうか。
(define (cdr z)
  (z (lambda (p q) q)))