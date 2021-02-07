; 練習問題 1.12
; パスカルの三角形

(define (pascal x y) ;x:行, y:列
  (cond ((= y 1) 1)
        ((= x y) 1)
        (else (+ (pascal (- x 1) (- y 1))
                 (pascal (- x 1) y)))))

(pascal 3 2)
;=> 2
(pascal 5 3)
;=> 6

;     1
;    1 1
;   1 2 1
;  1 3 3 1
; 1 4 6 4 1

