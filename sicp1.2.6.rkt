; SICP 1.2.6 例: 素数判定
;
; 約数を探す素直な方法
; ステップ数は、増加オーダーが Θ(√n)
(define (prime? n)
  (= n (smallest-divisor n)))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((< n (square test-divisor)) n)
        ; もし n が素数でないならば、それは√n 以下の約数を持つ
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))
(define (square x)
  (* x x))

; フェルマーテスト
; フェルマーの小定理によるΘ(log n) の素数判定
;---
; フェルマーの小定理: n が素数で、a が n より小さい任意の正の整数であるとき、a の n 乗は法 n に関して a と合同である。
;
; 素数判定アルゴリズム:
; ある数値 n が与えられたとき、a < n である適当な数値 a を取り、法 n に関する a n の剰余を求めます。
; もし結果が a と等しくなければ、n は確実に素数ではありません。
; もし a と等しければ、n は素数かもしれません。
; 今度は、別の適当な数値 a を取り、同じ方法でテストを行います。
; それもまた等式を満たせば、n が素数であることについてより確信が持てるようになります。たくさんの a について試験を行っていくことで、結果についての確信を増やしていくことができます。このアルゴリズムは、フェルマーテストとして知られています。


; ある数値の冪乗の、別のある数値を法とした剰余を求める
; 二乗の連続を使っているため、ステップ数は指数に対して対数的に増加
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp ) (remainder (square (expmod base (/ exp 2) m)) m))
        (else (remainder (* base (expmod base (- exp 1) m)) m))))

; フェルマーテスト  1 以上 n − 1 以下のランダムな数値 a を選び、a の n乗の modulo n が a に等しいかをチェックする
(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))
               ; random は、受け取った整数よりも小さい非負整数を返します。

; 引数で与えられた数値の回数だけテストを実行します。
(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

; 確率的手法
; フェルマーテストでは、得られた答えは答えの正しさは確率的なものでしかありません。
; 間違いの確率が好きなだけ小さくなることが証明できるテストの存在は、この種類のアルゴリズムへの関心を引き起こしました。今では、そのようなアルゴリズムは 確率的アルゴリズム (probabilistic algorithm) と呼ばれるようになっています。
