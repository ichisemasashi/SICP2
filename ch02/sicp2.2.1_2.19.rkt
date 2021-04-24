; 練習問題 2.19 両替パターン数計算プログラム
; プログラムで使う通貨を変えられるようにしたい。
;1.2.2 節のプログラムでは、通貨についての知識は一部はfirst-denomination に、
;一部は count-change (アメリカには 5 種類のコインがあるということを知っている) に分散されている。
;両替に使うコインのリストを与えられるようになればもっとよくなるだろう。
;手続き cc を書き直して、二つ目の引数として取るものを、どのコインを使うかを指定する整数ではなく、
;使うコインの値のリストとなるようにしたい。

;通貨の種類を定義するリスト
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define (cc amount coins)
  (cond ((= amount 0) 1)
         ((or (< amount 0)
               (no-more? coins))
          0)
         (else (+ (cc amount (except-first-denomination coins))
                   (cc (- amount (first-denomination coins)) coins)))))
(define (no-more? c)
  (null? c))
(define (except-first-denomination c)
  (cdr c))
(define (first-denomination c)
  (car c))
;> (cc 100 us-coins )
;292
;> 
;リスト coins の順序は、cc によって返される解答に影響を与えるだろうか、それとも与えないだろうか。
(define us2-coins (list 1 5 10 25 50))
;> (cc 100 us-coins )
;292
;> (cc 100 us2-coins )
;292
;> (cc 100 uk-coins)
;104561
;> (cc 100 (reverse uk-coins))
;104561
;> 