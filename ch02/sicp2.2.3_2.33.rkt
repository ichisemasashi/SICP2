; 練習問題 2.33 基本的なリスト操作
;基本的なリスト操作のいくつかを集積として定義したものを以下に示す。欠けている式を埋めて、完成させよ。
(load "sicp2.2.3.rkt")
(define (map p seq)
  (define (fn x acc)
    (cons (p x) acc))
  (accumulate fn nil seq))
(define (append seq1 seq2)
  (accumulate cons seq2 seq1))
(define (length seq)
  (accumulate (lambda (x acc) (+ 1 acc)) 0 seq))

(define x (list 1 2 3))
(define y (list 4 5 6))
(define z (list 1 2 3 y))
;> (map inc x)
;(mcons 2 (mcons 3 (mcons 4 '())))
;> (append x y)
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 (mcons 5 (mcons 6 '()))))))
;> (length y)
;3
;> 