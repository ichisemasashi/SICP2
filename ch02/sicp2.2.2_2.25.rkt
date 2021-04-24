; 練習問題 2.25
; それぞれのリストから 7 を取り出す car と cdr の組み合わせを書け。
(define x (list 1 3 (list 5 7) 9))
(define y (list (list 7)))
(define z (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))

;> (car (cdr (cdr x)))
;(mcons 5 (mcons 7 '()))
;> (car (cdr (car (cdr (cdr x)))))
;7
;> (car (car y))
;7
;> (cdr (cdr z))
;'()
;> (car (cdr z))
;(mcons 2 (mcons (mcons 3 (mcons (mcons 4 (mcons (mcons 5 (mcons (mcons 6 (mcons 7 '())) '())) '())) '())) '()))
;> (cdr (car (cdr z)))
;(mcons (mcons 3 (mcons (mcons 4 (mcons (mcons 5 (mcons (mcons 6 (mcons 7 '())) '())) '())) '())) '())
;> (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr z))))))))))))
;7
;> 