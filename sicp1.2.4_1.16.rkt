;
; 練習問題1.16
;

; fast-expt と同じように二乗の連続を使って、指数計算を対数的ステップ数で実行する反復的プロセスを生成する手続き

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))
(define (even? n)
  (= (remainder n 2) 0))
(define (square x)
  (* x x))


(define (fast-expt2 a b n)
  (cond ((= n 0) a)
        ((even? n)  (fast-expt2 a (* b b) (/ n 2) ))
        (else (fast-expt2 (* a b) b (- n 1)))))
