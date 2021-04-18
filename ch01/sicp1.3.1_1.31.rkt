; 練習問題 1.31
; a
; 特定範囲の点における関数の値の積を返す似たような仕組みの手続き
(define (product term a next b)
  (if (< b a)
    1
    (* (term a)
       (product term (next a) next b))))

; 次の公式を使って、productによって π の近似値を計算せよ。
; π/4 = (2 * 4 * 4 * 6 * 6 * 8 * ...)/(3 * 3 * 5 * 5 * 7 * 7 * ...)
(define (pi-term n)
  (if (even? n)
     (/ (+ n 2) (+ n 1))
     (/ (+ n 1) (+ n 2))))
(define (next x)
  (+ x 1))

;> (* (product pi-term 1 next 6) 4.0)
;3.3436734693877552
;> (* (product pi-term 1 next 100) 4.0)
;3.1570301764551676
;>

; b
; 線形プロセスを生成するproduct
(define (product term a next b)
  (define (iter a result)
    (if (< b a) result
       (iter (next a) (* (term a) result))))
  (iter a 1))

