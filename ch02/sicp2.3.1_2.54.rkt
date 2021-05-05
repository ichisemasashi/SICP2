; 練習問題 2.54
;二つのリストは、同じ要素を同じ順番で持つときに equal? である
;( equal? '(this is a list) '(this is a list )) ;=> true
;( equal? '(this is a list) '(this (is a) list )) ;=> false

;記号が等しいかどうかという基本的な eq? を使って、再帰的に equal? を定義できる。
;a と b は、どちらも記号であってそれらが eq? であるか、
;どちらもリストであって、(car a) と (car b) が equal? であり、かつ (cdr a) と(cdr b) が equal? である場合、
;equal? である。
;equal? を手続きとして実装せよ。
(load "util.rkt")
(define (equal? list1 list2)
  (cond ((and (atom? list1) (atom? list2)) (eq? list1 list2))
         ((and (pair? list1) (pair? list2))
          (and (equal? (car list1) (car list2))
                (equal? (cdr list1) (cdr list2))))
         (else false)))

;> (equal? '(1 2 3 (4 5) 6) '(1 2 3 (4 5) 6))
;#t
;> (equal? '(1 2 3 (4 5) 6) '(1 2 3 (4 5 7) 6))
;#f
;> 