; 練習問題 2.5
; a と b のペアを積 2^a・3^b の整数で表現することによって、
;非負整数のペアを数値と数値演算だけを使って表現できるということを示せ。
;---
; aは偶数部分に、bは奇数部分に格納されるので、可能である。

;---
;それに対応する cons, car, cdr 手続きを定義せよ。
(define (cons a b)
  (* (expt 2 a) (expt 3 b)))

; n=A^a*Bのときのaを求める手続き
(define (full-divide-counter n A)
  (define (iter n a)
    (if (= 0 (remainder n A))
       (iter (/ n A) (inc a))
       a))
  (iter n 0))

(define (car z)
  (full-divide-counter z 2))
(define (cdr z)
  (full-divide-counter z 3))