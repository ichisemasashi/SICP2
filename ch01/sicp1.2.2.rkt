; SICP 1.2.2 木の再帰
; 木の再帰 (tree recursion)
; 例  フィボナッチ数列の計算
; この数列では、それぞれの数値はその直前にある二つの数値の合計になっています。
; 0, 1, 1, 2, 3, 5, 8, 13, 21, . . . .
; Fib(n) = 0
;           1
;           Fib(n-1) + F(n-2)
(define (fib n)
  (cond ((= n 0) 0)
         ((= n 1) 1)
         (else (+ (fib (- n 1))
                   (fib (- n 2))))))
; この計算のパターンについて考えてみます。
; (fib 5) = (fib 4) + (fib 3)
;          = {(fib 3 + fib 2)} + ...
; 一般に、展開されたプロセスは、木のような形をしています。
; 枝は、(底以外の) それぞれのレベルで二つに分かれています。
; これは、fib 手続きが呼ばれるたびに自身を二回呼び出すということを反映しています。
; Fib(n)はφ^n/√5に最も近い整数になる。
; φ = (1+√5)/2 = 1.6180
; φ^2 = φ + 1を満たします。
; 木の再帰のプロセスで必要なステップ数は木のノード数に比例し、
; 必要な空間は木の最大の深さに比例します。

; フィボナッチ数の計算は、反復プロセスとして定式化することもできます。
; a と b という整数のペアを使い、Fib(1) = 1, Fib(0) = 0 と初期化し
; て、次の変換を同時に適用することを繰り返すというものです。
; a ← a + b,
; b ← a.
; この変換を n 回適用した後、a と b がそれぞれ Fib(n + 1) と Fib(n) に等しい
(define (fib n)
  (fib-iter 1 0 n))
(define (fib-iter a b count)
  (if (= count 0) b
     (fib-iter (+ a b) a (- count 1))))

;;;;;
; 両替パターンの計算
; 1 ドルを両替するやり方はいくつあるでしょうか。
; 使うのは、50 セント、25 セント、10 セント、5 セント、1 セントのコインです。
; n 種類のコインを使って金額 a を両替するやり方のパターン数は、以下の合計となる。
; - 一つ目の種類のコイン以外のすべての種類のコインを使って金額 a を両替するやり方のパターン数。
; - n 種類の硬貨すべてを使って、金額 a − d を両替するやり方のパターン数。d は、一つ目の種類のコインの額面とする。

; • もし a がちょうど 0 なら、両替パターンは 1 と数える。
; • もし a が 0 未満なら、両替パターンは 0 と数える。
; • もし n が 0 なら、両替パターンは 0 と数える。
(define (count-change amount)
  (cc amount 5))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
         ((< amount 0) 0)
         ((= kinds-of-coins 0) 0)
         (else (+ (cc amount (- kinds-of-coins 1))
                   (cc (- amount (first-denomination kinds-of-coins))
                        kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
         ((= kinds-of-coins 2) 5)
         ((= kinds-of-coins 3) 10)
         ((= kinds-of-coins 4) 25)
         ((= kinds-of-coins 5) 50)))
