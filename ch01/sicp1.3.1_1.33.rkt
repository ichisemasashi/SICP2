; 練習問題 1.33 さらに一般的なバージョンの accumulate

; 結合する項に対するフィルタ (filter)
; 指定された条件を満たす範囲内の値から導出される項だけを結合する
;
;(define (accumulate combiner null-valu term a next b)
;  (if (< b a) null-value
;     (combiner (term a) (accumulate combiner null-value term (next a) next b))))
;(define (accumulate combiner null-value term a next b)
;  (define (iter a result)
;    (if (< b a) result
;       (iter (next a) (combiner result (term a)))))
;  (iter a null-value))
(define (filtered-accumulate combiner null-value term a next b filter)
  (if (< b a) null-value
     (combiner (if (filter a) (term a)
                  null-value)
              (filtered-accumulate combiner null-value term (next a) next b filter))))
(define (filtered-accumulate combiner null-value term a next b filter)
  (define (iter a result)
    (if (< b a) result
       (iter (next a) (combiner result (if (filter a)
                                                 (term a)
                                                 null-value)))))
  (iter a null-value))

; a
; a から b の区間の素数の二乗の和
(load "util.rkt")
(define (sum-of-prime-square a b)
  (filtered-accumulate + 0 square a inc b prime?))
; b
; n と互いに素である n 未満のすべての正の整数 (つまり、gcd(i, n) = 1 となるすべての整数 i < n) の積
(define (produc-of-gcd n)
  (define (term x) x)
  (define (f i)
    (if (and (< i n) (= (gcd i n) 1)) true false))
  (filtered-accumulate * 1 term 1  inc n f))