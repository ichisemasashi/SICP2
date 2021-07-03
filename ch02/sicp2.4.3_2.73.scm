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
(load "./sicp2.3.2.rkt")

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

;何をやっているかについて。
;「数字」と「変数」以外の「型タグ（演算子）が付加されている式オブジェクト」に対して適用させる汎用微分手続きを、その型タグを使用して取得し、残りの引数を取得した実装レベルの微分手続きで微分するようにしている。

;述語 number? や variable? がデータ主導の振り分けに吸収できない理由について。
;「数値」と「変数」もオブジェクトに相当するが、これらは単項の型タグを持たない式オブジェクトである為、テーブルに実装レベルの微分手続きを割り当てることができない。なので、別途 cond の条件ロジックに定義しておく必要がある。

;;;;;;;;;;
; b.
;和と積に対する微分手続きと、上記のプログラムで使っているテーブルに
;それらを組み込む補助コードを書け。

(define (install-sum-package)
  (define (make-sum a1 a2)
    (cons a1 a2))
  (define (addend s)
    (cadr s))
  (define (augend s)
    (caddr s))
  (define (deriv-sum s)
    (make-sum (deriv (addend s))
              (deriv (augend s))))
  (define (tag x)
    (attach-tag '+ x))
  (put 'deriv '(+) deriv-sum)
  (put 'make-sum '+ (lambda (x y) (tag (make-sum x y))))
  'done)

(define (make-sum x y)
  ((get 'make-sum '+) x y))

(define (install-product-package)
  (define (make-product m1 m2)
    (cons m1 m2))
  (define (multiplier p)
    (cadr p))
  (define (multiplicand p)
    (caddr p))
  (define (deriv-product p)
    (make-sum
     (make-product (multiplier exp)
                   (deriv (multiplicand exp) var))
     (make-product (deriv (multiplier exp) var)
                   (multiplicand exp))))
  (define (tag x)
    (attach-tag '* x))
  (put 'deriv '(*) deriv-product)
  (put 'make-product '*
       (lambda (x y) (tag (make-product x y))))
  'done)

(define (make-product x y)
  ((get 'make-porduct '*) x y))

(define (deriv x)
  (apply-generic 'deriv x))



;;;;;;;;;;
; c.
;任意の微分規則 (例えば、練習問題 2.56の指数の微分など) を 選び、
;それをこのデータ主導システムに組み込め。

(define (exponentation-deriv expr var)
  (make-product (exponent expr)
                (make-product (make-expnentiation (base expr)
                                                  (make-sum (exponent expr) -1))
                              (deriv (base expr) var))))
(define (exponent expr)
  (cadr expr))
(define (base expr)
  (car expr))
(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((=number? base 1) 1)
        (else (list '** base exponent))))
(put 'deriv '** exponentation-deriv)

;;;;;;;;;;
; d.
;この単純な代数操作では、式の型は式をまとめる代数演算子となっている。
;しかし、仮に手続きのインデックスを逆にして、deriv でディスパッチを行う
;箇所を次のようにするとする。
; ((get (operator exp) 'deriv) (operands exp) var)
;これに対応して、微分システムにはどのような変更を加える必要があるだろうか。

;; 各手続きの put の引数の"演算"と"型"を逆転すればよい。
