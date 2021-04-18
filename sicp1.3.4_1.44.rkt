; 練習問題 1.44
;関数の平滑化 (smoothing) は、信号処理において重要な概念である。
;f が関数で dx がある小さな値であるとき、f を平滑化したものは
;x での値が f (x − dx), f (x), f (x + dx) の平均となる関数である。
;入力として f を計算する手続きを取り、f を平滑化したものを計算する手続きを返す手続き smooth を書け。
(define dx 0.000001)
(define (smooth f)
  (lambda (x) (/ (+ (f (- x dx))
                      (f x)
                      (f (+ x dx)))
                   3.0)))


;時には、関数を繰り返し平滑化する (つまり、平滑化した関数をさらに平滑化することを続ける) ことによって
;n 重平滑化関数 (n-fold smoothed function) を得ることが役に立つこともある。
;smooth と練習問題 1.43の repeated を使って任意の関数の n 重平滑化関数を生成するやり方を示せ。
(load "sicp1.3.4_1.43.rkt")
(define (n-fold-smooth f n)
  ((repeat smooth n) f))