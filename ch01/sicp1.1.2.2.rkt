; SICP 1.2.2
;

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))


;; フィボナッチ数を反復的に計算
(define (fib n)
  (fib-iter 1 0 n))
(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

;; 両替パターンの計算
;  1 ドルを両替する やり方はいくつあるでしょうか。
; 使うのは、50 セント、25 セント、10 セント、 5 セント、1 セントのコインです。
;  n 種類のコインを使って金額 a を両替するやり方のパターン数は、以下の 合計となる。
; • 一つ目の種類のコイン以外のすべての種類の
;   コインを使って金額 a を両 替するやり方のパターン数。
; • n 種類の硬貨すべてを使って、金額 a − d を両替するやり方のパターン
;   数。d は、一つ目の種類のコインの額面とする。
(define (count-change amount)
  (cc amount 5))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1) ; もしaがちょうど0なら、両替パターンは1と数える。
        ((or (< amount 0) (= kinds-of-coins 0)) 0) ;もしaが0未満なら、両替パターンは0と数える。or もしnが0なら、両替パターンは0と数える。
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

(count-change 100)
;=> 292

