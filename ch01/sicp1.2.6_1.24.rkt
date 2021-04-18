; 練習問題 1.24

; 練習問題 1.22の timed-prime-test 手続きを fast-prime?(フェルマー法) を使うように修正し
(load "sicp1.2.6_1.22.rkt")
(define (start-prime-test n start-time)
  (if (fast-prime? n 3)
      (report-prime (- (runtime) start-time))))

;練習問題 1.22で見つけた 12 個の素数をそれぞれテストせよ。
; (search-for-primes 1000 1050)
; (search-for-primes 10000 10050)
; (search-for-primes 100000 100050)
; (search-for-primes 1000000 1000050)

;; 早くならない。試行回数の指定として、適切な数値が不明。