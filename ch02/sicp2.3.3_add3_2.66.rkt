; 練習問題 2.66
;レコードの集合が、キーの数値の大小によって順序づけられた二分木という構造になっている場合について、
; lookup 手続きを実装せよ。
(load "sicp2.3.3_add3.rkt")

(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) false)
        ((= given-key (key (entry set-of-records)))
         (entry set-of-records))
        ((< given-key (key (entry set-of-records)))
         (lookup given-key (left-branch set-of-records)))
        (else (lookup given-key (right-branch set-of-records)))))
