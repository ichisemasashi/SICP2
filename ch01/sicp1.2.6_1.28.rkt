; 練習問題 1.28
;
; フェルマーの小定理
; n が素数で、a が n より小さい任意の正の整数であるとき、
; a の n 乗は法 n に関して a と合同である。


; 騙すことができないフェルマーテストの変種: ミラー-ラビンテスト (Miller-Rabin test)
; フェルマーの小定理の別の形
; n が素数で、かつ a が n 以下の任意の正の整数であれば、a の (n − 1) 乗は法 n に関して 1 と合同である。
; Miller-Rabin テストで数値 n の素数性をテストするには
; a < n である適当な a を選び、expmod 手続きを使って a の (n − 1)乗の n を法とする剰余を求める。
; しかし、expmod 手続きの中で二乗を行うステップで、毎回 “法 n に関する自明でない 1 の平方根”を見つけたかチェックする。
; これは、1 とも n − 1 とも等しくない数値で、その二乗が法 n に関して 1 に等しい数値である。
; そのような自明でない 1 の平方根が存在すれば n は素数ではないということは証明できる。
; また、もし n が素数でない奇数であれば、少なくとも a < n である a のうち半分は、
; このように a n−1 を演算すると、法 n に関する自明でない 1 の平方根が現れるということも証明できる
;;;;;
; expmod 手続きを変更し、自明でない 1 の平方根を見つけるとシグ
; ナルを送るようにして、それを使って fermat-test と同じような
; 手続きとして Miller-Rabin テストを実装せよ。ヒント:expmod にシグナ
; ルを送らせる簡単な方法のひとつとして、0 を返すようにするとい
; うものがある。

;; 元のexpmod
;(define (expmod base exp m)
;  (cond ((= exp 0) 1)
;        ((even? exp ) (remainder (square (expmod base (/ exp 2) m)) m))
;        (else (remainder (* base (expmod base (- exp 1) m)) m))))
(load "util.rkt")
(define (test-sqrt1 x n)
  ; 1 とも n − 1 とも等しくない数値で、その二乗が法 n に関して 1 に等しい数値=法 n に関する自明でない 1 の平方根
  (cond ((= 1 x) false)
         ((= (- n 1) x) false)
         ((= 1 (remainder (square x) n)) true)
         (else false)))
(define (expmod base exp m)
  (cond
    ((= exp 0) 1)
    ((test-sqrt1 base m) 1)
    ((even? exp) (remainder (square (expmod base (/ exp 2) m)) m))
    (else (remainder (* base (expmod base (- exp 1) m)) m))))

; 元のfermat-test
;(define (fermat-test n)
;  (define (try-it a)
;    (= (expmod a n n) a))
;  (try-it (+ 1 (random (- n 1)))))
(define (miller-rabin-test n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((miller-rabin-test n) (fast-prime? n (- times 1)))
        (else #f)))
(define (prime? n)
  ;; Miller-Rabin テストを 20 回行うので誤りの確率は
  ;; (1/4)^20 ≈ 10^(-12)
  (fast-prime? n 20))

;;;;;;;;
;> (prime? 561)
;#f
;> (prime? 1105)
;#f
;> (prime? 1729)
;#f
;> (prime? 2465)
;#f
;> (prime? 2821)
;#f
;> (prime? 6601)
;#f
;> 