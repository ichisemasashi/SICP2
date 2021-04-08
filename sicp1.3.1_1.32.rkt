; 練習問題 1.32 sumとproductをさらに抽象化

; a
; sum と product (練習問題 1.31) は、どちらも accumulate(集積) という
; より一般的な概念の特殊なケースであることを示せ。
; ( accumulate combiner null-value term a next b)
;accumulate は、sum や product と同じく項と範囲指定の引数を取り、それに加えて、
;それまでの項の集積と現在の項をどうやって結合するかを指定する combiner 手続き (2 引数)
;と、項がなくなったときにどのような基本値を使うかを指定する null-value を引数に取る。
; 参考
;(define (sum term a next b)
;  (if (< b a) 0
;       (+ (term a)
;          (sum term (next a) next b))))
;(define (product term a next b)
;  (if (< b a)
;    1
;    (* (term a)
;       (product term (next a) next b))))
(define (accumulate combiner null-valu term a next b)
  (if (< b a) null-value
     (combiner (term a) (accumulate combiner null-value term (next a) next b))))

(define (sum term a next b)
  (accumulate + 0 term a next b))
(define (product term a next b)
  (accumulate * 1 term a next b))

; b
;線形プロセスを生成するaccumulate
;(define (sum term a next b)
;  (define (iter a result)
;    (if (< b a) result
;       (iter (next a) (+ result (term a)))))
;  (iter a 0))
;(define (product term a next b)
;  (define (iter a result)
;    (if (< b a) result
;       (iter (next a) (* (term a) result))))
;  (iter a 1))
(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (< b a) result
       (iter (next a) (combiner result (term a)))))
  (iter a null-value))
