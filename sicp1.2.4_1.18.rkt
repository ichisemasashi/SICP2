;
; 練習問題 1.18
;
; かけ算を対数的ステップ数で実行 する反復的プロセスを生成する手続き
; -> 1.17で完成している。

; > (require racket/trace)
; > (trace mul-iter)
; > (mul 4 5)
; >(mul-iter 0 4 5)
; >(mul-iter 4 4 4)
; >(mul-iter 4 8 2)
; >(mul-iter 4 16 1)
; >(mul-iter 20 16 0)
; <20
; 20
; >

