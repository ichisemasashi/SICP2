; 練習問題 2.61 順序つき表現を使った adjoin-set

;順序つき表現を使った adjoin-set を実装せよ。
; element-of-set? から類推して、順序つきであることの利点を生かして、順序なしの表現に比べて
;平均的に半分のステップを必要とする手続きを作るやり方を示せ。

;順序なしの表現を使った adjoin-set
;(define (adjoin-set x set)
;  (if (element-of-set? x set) set
;     (cons x set)))

; 参考：
(define (element-of-set? x set)
  (cond ((null? set) false)
         ((= x (car set)) true)
         ((< x (car set)) false)
         (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((= x (car set)) set)
        ((< x (car set)) (cons x set))
        (else (cons (car set) (adjoin-set x (cdr set))))))
