; 練習問題 1.22
; timed-prime-test 手続きは、整数 n を引数として呼ばれると、n を表示し、n が素数であるかチェックする。n が素数であれば、手続きは 3 つのアスタリスクと、テスト実行にかかった時間を表示する。

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))
      ))
(define (report-prime elaspsed-time)
  (display " *** ")
  (display elaspsed-time))

(load "sicp1.2.6.rkt")
(load "util.rkt")

;; 指定した範囲の連続した奇数について素数判定を行う手続き search-for-primes

(define (search-for-primes a b)
  (search-for-primes-iter a b))
(define (search-for-primes-iter a b)
  (if (< a b)
      (and (if (prime? a)
               (timed-prime-test a))
           (search-for-primes-iter (+ a 1) b))))

;; 1000, 10,000, 100,000 より大きな素数をそれぞれ 3 つ見つけよ。
; (search-for-primes 1000 1050)
; (search-for-primes 10000 10050)
; (search-for-primes 100000 100050)
; (search-for-primes 1000000 1000050)

; n が10倍になると要する時間はおよそ√10（≒3.162）倍となっている。