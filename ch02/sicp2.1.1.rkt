; SICP 2.1.1 例: 有理数の数値演算
;有理数を使って数値演算を行いたいという場合について考えてみましょう。行いたい演算は、
;足し算、引き算、かけ算、割り算や、二つの有理数が等しいかどうかテストするといったものになるでしょう。
; - 分子と分母から有理数を構築する方法はすでに持っていると仮定しましょう。
; - また、有理数が与えられたときに、その分子と分母を抽出 (セレクト) する方法もあるとします。
; - さらに、コンストラクタとセレクタは手続きとして使うことができるとします。
; • (make-rat ⟨n⟩ ⟨d⟩) は、分子が整数 ⟨n⟩ で分母が整数 ⟨d⟩ である有理数を返す。
; • (numer ⟨x⟩) は、有理数 ⟨x⟩ の分子を返す。
; • (denom ⟨x⟩) は、有理数 ⟨x⟩ の分母を返す。
;希望的思考(wishful thinking) を使っています。
; n1/d1 + n2/d2 = {n1d2 + n2d1}/d1d2
; n1/d1 - n2/d2 = {n1d2 - n2d1}/d1d2
; n1/d1 x n2/d2 = n1n2/d1d2
; n1/d1 ÷ n2/d2 = n1d2/d1n2
; n1/d1 = n2/d2 if and only if n1d2 = n2d1
(define (add-rat r1 r2)
  (make-rat (+ (* (numer r1) (denom r2))
                 (* (numer r2) (denom r1)))
              (* (denom r1) (denom r2))))
(define (sub-rat r1 r2)
  (make-rat (- (* (numer r1) (denom r2))
                 (* (numer r2) (denom r1)))
              (* (denom r1) (denom r2))))
(define (mul-rat r1 r2)
  (make-rat (* (numer r1) (numer r2))
              (* (denom r1) (denom r2))))
(define (div-rat r1 r2)
  (make-rat (* (numer r1) (denom r2))
              (* (denom r1) (numer r2))))
(define (equal-rat? r1 r2)
  (= (* (numer r1) (denom r2))
     (* (numer r2) (denom r1))))

;;;;;;;;;;
; ペア
;テータ抽象化の具体的なレベルを実装するペア (pair) という複合構造
;これは、cons という基本手続きによって構築できます。
;この手続きは二つの引数を取り、それら二つの引数を部品として含む複合データオブジェクトを返します。
;ペアがあるとき、それらの部品は car と cdr という基本手続きを使って取り出すことができます。
;(define x (cons 1 2))
;(car x) ;=> 1
;(cdr x) ;= 2
;(define  i (cons 1 2))
;(define j (cons 3 4))
;(define z (cons i j))
;(car (car z)) ;=> 1
;(car (cdr z)) ;=> 3
;ペアを組み合わせるこの能力が、ペアというものをすべての複雑なデータ構造を作るための
;汎用ブロックとして使えるものにしている
;ペアによって構築されるデータオブジェクトは リスト構造 (list-structured) のデータと呼ばれます。

;;;;;;;;;;
; 有理数を表現する
(define (make-rat n d)
  (cons n d))
(define (numer x)
  (car x))
(define (denom x)
  (cdr x))
; 計算結果を表示するために、有理数を分子、スラッシュ、分母として表示する
(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))
; --- TEST ---
;(define one-half (make-rat 1 2))
;(print-rat one-half) ;=> 1/2
;(define one-third (make-rat 1 3))
;(print-rat (add-rat one-half one-third)) ;=> 5/6
;(print-rat (mul-rat one-half one-third)) ;=> 1/6
;(print-rat (add-rat one-third one-third));=> 6/9
;---
(load "util.rkt")
(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))
; (print-rat (add-rat one-third one-third));=>2/3