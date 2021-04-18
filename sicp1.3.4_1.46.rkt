; 練習問題 1.46 反復改良法 (iterative improvement)
;何かを計算するにあたって、答えに対する初期推測値から始めて、
;その推測値が十分によいかテストし、よくなければ推測値を改良し、
;改良した推測値を新しい推測値としてそのプロセスを続ける

;二つの手続きを引数として取る手続き iterative-improve を書け。
;引数はそれぞれ、推測値が十分によいか判断する手続きと、推測値
;を改良する手続きとする。iterative-improve の返り値は、引数
;として初期推測値を取り、それが十分によくなるまで改良を続ける手続きとする。
(define (iter-improve good-enough? improve)
  (lambda (guess)
    (if (good-enough? guess) guess
       ((iter-improve good-enough? improve) (improve guess)))))

;1.1.7 節の sqrt 手続きと1.3.3 節の fixed-point手続きを iterative-improve によって書き直せ。
(load "util.rkt")
(define (sqrt x)
  (define (good-enough? v)
    (< (abs (- (square v) x)) 0.000001))
  (define (improve y)
    (average y (/ x y)))
  ((iter-improve good-enough? improve) 1.0))

(define (fixed-point f guess)
  (define (good-enough? v)
    (< (abs (- v (f v))) 0.000001))
  ((iter-improve good-enough? f) guess))
