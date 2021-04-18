; SICP 1.3.2 lambda を使って手続きを構築する

; 入力に 4 を足したものを返す手続き
(lambda (x) (+ x 4))

; 入力と入力に 2 を足したものの積の逆数を返す手続き
(lambda (x) (/ 1.0 (* x (+ x 2))))


; 補助手続きをまったく定義しないpi-sum 手続き
(load "util.rkt")
(define (pi-sum a b)
  (sum (lambda (x) (/ 1.0 (* x (+ x 2))))
      a
      (lambda (x) (+ x 4))
      b))

; 補助手続き add-dx を定義しないintegral 手続き
(define (integral f a b dx)
  (* (sum f
           (+ a (/ dx 2.0))
           (lambda (x) (+ x dx))
           b)
     dx))

; lambda は define 同様、手続きを作るために使われますが、その手続きに名前を指定しないという点が違います。
; (lambda (⟨formal-parameters⟩) ⟨body⟩)

; ( define (plus4 x) (+ x 4)) 
;これは、以下と同値です。
; ( define plus4 ( lambda (x) (+ x 4)))

; lambda 式は次のように複合式の中で演算子として使うことができます。
((lambda (x y z) (+ x y (square z)))
 1 2 3)

;;;;;;;;;;;
;; let を使って局所変数を作る
;lambda の別の使い方として、局所変数を作るというものがあります。
; 例えば、次の関数を計算したいとします。
; f (x, y) = x(1 + xy)^2 + y(1 − y) + (1 + xy)(1 − y),
; 次のように表現することもできます。
; a = 1 + xy, b = 1 − y,
; f (x, y) = xa^2 + yb + ab.
; 局所変数を束縛するために補助手続きを使う
(define (f x y)
  (define (f-helper a b)
    (+ (* x (square a))
       (* y b)
       (* a b)))
  (f-helper (+ 1 (* x y)) (- 1 y)))
; lambda 式を使う
(define (f x y)
  ((lambda (a b)
     (+ (* x (square a))
        (* y b)
        (* a b)))
   (+ 1 (* x y)) (- 1 y)))
; let を使うと
(define (f x y)
  (let ((a (+ 1 (* x y)))
         (b (- 1 y)))
    (+ (* x (square a))
       (* y b)
       (* a b))))

; let 式の一般形式
;(let ((⟨var 1 ⟩ ⟨exp 1 ⟩)
;       (⟨var 2 ⟩ ⟨exp 2 ⟩)
;       ...
;       (⟨var n ⟩ ⟨exp n ⟩))
;  ⟨body⟩)
;let 式の最初の部分は、名前・式というペアのリストです。
;let が評価されるとき、それぞれの名前は対応する式の値と関連づけられます。
;let の本体は、これらの名前が局所変数として束縛された状態で評価されます。
; これは、let 式が以下のものの別の文法として評価されているということです。
;(( lambda (⟨var 1 ⟩ . . . ⟨var n ⟩)
;     ⟨body⟩)
;   ⟨exp 1 ⟩
;    ...
;   ⟨exp n ⟩)
; let式は、その裏にある lambda 適用に対するシンタックスシュガーにすぎません。
; - let を使うと、変数を可能な限り局所的に使用箇所に束縛できます。
; - 変数の値は、let の外側で計算されます。
; 局所変数の値を提供する式が局所変数自身と同じ名前を持った変数に依存している場合には、このことが関係してきます。
; 例えば、x の値が 2 であれば、次の式の値は 12 になります。
;(let ((x 3)
;      (y (+ x 2)))
;  (* x y))
;これは、let の本体の中では x は 3 になり、y は 4(つまり、外側の x に 2を足したもの) になっているからです。

; let と同じ結果を得るために、内部定義が使える場合もあります。
; 例えば、上の手続き f
(define (f x y)
  (define a (+ (* x y)))
  (define b (- 1 y))
  (+ (* x (square a))
     (* y b)
     (* a b)))
