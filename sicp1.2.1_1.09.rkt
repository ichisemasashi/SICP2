; 練習問題 1.9
;

; (define (+ a b)
;   (if (= a 0) b (inc (+ (dec a) b))))
; (define (+ a b)
;   (if (= a 0) b (+ (dec a) (inc b))))

;; 前者の+の定義で評価したとき
; (+ 4 5)
;=> (inc (+ (dec 4) 5))
;=> (inc (+ 3 5))
;=> (inc (inc (+ (dec 3) 5)))
;=> (inc (inc (+ 2 5)))
;=> (inc (inc (inc (+ (dec 2) 5))))
;=> (inc (inc (inc (inc (+ (dec 1) 5)))))
;=> (inc (inc (inc (inc (+ 0 5)))))
;=> (inc (inc (inc (inc 5))))
;=> (inc (inc (inc 6)))
;=>(inc (inc 7))
;=> (inc 8)
;=> 9
; 再帰的


;; 後者の+の定義で評価したとき
; (+ 4 5)
;=> (+ (dec 4) (inc 5))
;=> (+ 3 6)
;=> (+ (dec 3) (inc 6))
;=> (+ 2 7)
;=> (+ (dec 2) (inc 7))
;=> (+ 1 8)
;=> (+ (dec 1) (inc 8))
;=> (+ 0 9)
;=> 9
; 反復的
