; 練習問題 1.26
; Louisのexpmod
;( define ( expmod base exp m)
;  (cond ((= exp 0) 1)
;         (( even? exp)
;          ( remainder (* ( expmod base (/ exp 2) m)  ; square 手続きを呼ぶのでなく、明示的にかけ算を使っている
;                           ( expmod base (/ exp 2) m))
;           m))
;         (else
;          ( remainder (* base
;                        ( expmod base (- exp 1) m))
;                     m))))
;
; Evaの指摘「いや、違うって。手続きの書き方のせいで、Θ(log n) のプロセスが Θ(n) のプロセスになっちゃったんだよ」
;
; suquareを使うことで、θ(log n)だったが、suquareを使わないため、Θ(n) 