; 練習問題 1.42
;f と g を二つの 1 引数関数とする。g に f を合成(composition) するということを、
;関数 x 7→ f (g(x)) として定義する。合成を実装する手続き compose を定義せよ。
(define (compose f g)
  (lambda (x) (f (g x))))
