; 練習問題 1.23
;入力が 2であれば 3 を返し、そうでなければ入力に 2 を足したものを返す手続き next を定義せよ。
(define (next n)
  (cond ((<= n 2) (+ n 1))
       (else (+ n 2))))

; smallest-divisor 手続きを、(+ test-divisor 1) の代わりに (next test-divisor) を使うように修正せよ。
(load "sicp1.2.6.rkt")
(load "sicp1.2.6_1.22.rkt")

(define (find-divisor n test-divisor)
  (cond ((< n (square test-divisor)) n)
       ((divides? test-divisor n) test-divisor)
       (else (find-divisor n (next test-divisor)))))

; 変更したバージョンの smallest-divisor 手続きを組み込んだ timed-prime-test を使い、
; 練習問題 1.22で見つけた 12個の素数についてテストを実行せよ。
; この変更はテストのステップ数を半分にするため、2 倍の速度で実行できると予想できる。
;;; 1.2〜1.4倍くらいにしかならない？？？