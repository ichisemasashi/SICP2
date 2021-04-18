; 練習問題 1.20
; (define (gcd a b)
;   (if (= b 0)
;       a
;       (gcd b ( remainder a b))))
;
; (gcd 206 40)を正規順序評価と作用順序評価でのremainderの呼ばれる回数
;;; 正規順序評価だと
; (gcd 206 40)
; = (if (= 40 0) ; #f
;    206
;    (gcd 40 (rem 206 40)))
; = (if (= (rem 206 40) 0) ; #f
;     40
;     (gcd (rem 206 40) (rem 40 (rem 206 40))))
; = (if (= (rem 40 (rem 206 40)) 0) ; #f
;     (rem 206 40)
;     (gcd (rem 40 (rem 206 40)) (rem (rem 206 40) (rem 40 (rem 206 40)))))
; = (if (= (rem (rem 206 40) (rem 40 (rem 206 40))) 0) ; #f
;     (rem 40 (rem 206 40))
;     (gcd (rem (rem 206 40) (rem 40 (rem 206 40))) (rem (rem 40 (rem 206 40)) (rem (rem 206 40) (rem 40 (rem 206 40))))))
; = (if (= (rem (rem 40 (rem 206 40)) (rem (rem 206 40) (rem 40 (rem 206 40)))) 0) ; #t
;     (rem (rem 206 40) (rem 40 (rem 206 40)))
;     (gcd (rem (rem 40 (rem 206 40)) (rem (rem 206 40) (rem 40 (rem 206 40)))) (rem (rem (rem 40 (rem 206 40))) (rem (rem 40 (rem 206 40)) (rem (rem 206 40) (rem 40 (rem 206 40)))))))
;
; (rem (rem 206 40) (rem 40 (rem 206 40)))
; (rem 6 (rem 40 6))
; (rem 6 4)
; 2

; 17回

; -------
;;; 作用的順序だと
; (gcd 206 40)
; = (if (= 40 0) ; #f
;    206
;    (gcd 40 (rem 206 40)))
; = (if (= 40 0) ; #f
;     206
;     (gcd 40 6))
; = (if (= 6 0) ; #f
;     40
;     (gcd 6 (rem 40 6)))
; = (if (= 6 0) ; #f
;     40
;     (gcd 6 4))
; = (if (= 4 0) ; #f
;     6
;     (gcd 4 (rem 6 4)))
; = (if (= 4 0) ; #f
;     6
;     (gcd 4 2))
; = (if (= 2 0) ; #f
;     4
;     (gcd 2 (rem 4 2)))
; = (if (= 2 0) ; #f
;     4
;     (gcd 2 0))
; = (if (= 0 0) ; #t
;     2
;     (gcd 2 0))
; = 2
;
; 4回
