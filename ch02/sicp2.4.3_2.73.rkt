#lang sicp
; 練習問題 2.73
;2.3.2 節では、記号微分を行うプログラムについて説明した。
;(define (deriv exp var)
;  (cond ((number? exp) 0)
;        ((variable? exp)
;         (if (same-variable? exp var) 1 0))
;        ((sum? exp)
;         (make-sum (deriv (addend exp) var)
;                   (deriv (augend exp) var)))
;        ((product? exp)
;         (make-sum (make-product (multiplier exp)
;                                 (deriv (multiplicand exp) var))
;                   (make-product (deriv (multiplier exp) var)
;                                 (multiplicand exp))))
;        ; <more rules can be added here>
;        (else (error "unknown expression type: DERIV" exp))))
;このプログラムは、微分する式の型によってディスパッチを実行していると捉えることもできる。
;この場合、データの “タイプタグ” は代数演算記号 (+ など) で、
;行う演算は deriv ということに なる。
;基本的な微分を行う手続きを次のように書き直すと、プログラムをデータ主導スタイルに変形できる。
(load "sicp2.3.2.rkt")

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        (else ((get 'deriv (operator exp))
               (operands exp) var))))
(define (operator exp)
  (car exp))
(define (operands exp)
  (cdr exp))

;;;;;;;;;;
; a.
;上で何をしているか説明せよ。
;手続きnumber?とvariable? は、なぜデータ主導ディスパッチとして
;取り込むことができないのだろうか。

;;;;;;;;;;
; b.
;和と積に対する微分手続きと、上記のプログラムで使っているテーブルに
;それらを組み込む補助コードを書け。

;;;;;;;;;;
; c.
;任意の微分規則 (例えば、練習問題 2.56の指数の微分など) を 選び、
;それをこのデータ主導システムに組み込め。

;;;;;;;;;;
; d.
;この単純な代数操作では、式の型は式をまとめる代数演算子となっている。
;しかし、仮に手続きのインデックスを逆にして、deriv でディスパッチを行う
;箇所を次のようにするとする。
; ((get (operator exp) 'deriv) (operands exp) var)
;これに対応して、微分システムにはどのような変更を加える必要があるだろうか。