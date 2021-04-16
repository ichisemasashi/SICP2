; 練習問題 1.37

;;;
; a

; 無限連分数 (continued fraction)
;f = N1/(D1+N2/(D2+ N3/(D3+ ...
;無限連分数の近似値を求める方法のひとつは、与えられた項数で展開を打ち切るというものである。
; 展開を打ち切ったもの— いわゆるk 項有限連分数 (k-term finite continued fraction)—は、以下のような形になる。
; N1/(D1+N2/....+Nk/Dk)
;n と d を 1 引数 (項の添字 i) の手続きとし、それぞれ連分数の項 Ni と Di を返すとする。
;(cont-frac n d k) を評価すると k 項有限連分数の値を計算するような手続き cont-fracを定義せよ。
(define (cont-frac n d k)
  (define (iter i)
    (cond ((= i k) 0)
           (else (/ (n i) (+ (d i) (iter (inc i)))))))
  (iter 1))
; 一連の k の値に対し、以下によって 1/φ の近似を求め、その手続きをチェックせよ。
(define (a k)
  (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) k))

;;;;;
; b
; 線形プロセスを生成するもの
(define (cont-frac n d k)
  (define (iter i result)
    (cond ((= i 0) result)
           (else (iter (dec i) (/ (n i) (+ (d i) result))))))
  (iter k 0))