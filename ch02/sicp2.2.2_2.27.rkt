; 練習問題 2.27 deep-reverse
;練習問題 2.18の reverse 手続きを修正し、deep-reverse という手続きを書け。
;deep-reverse は、ひとつのリストを引数として取り、
;要素が逆順で、サブリストもすべて要素が逆順になっているリストを返す手続きである。

(load "sicp2.2.1_2.18.rkt")
(define x (list (list 1 2) (list 3 4)))
;> (reverse x)
;(mcons (mcons 3 (mcons 4 '())) (mcons (mcons 1 (mcons 2 '())) '()))
;>

(define (deep-reverse x)
  (define (iter seq result)
    (cond ((null? seq) result)
           ((not (pair? (car seq)))
            (iter (cdr seq) (cons (car seq) result)))
           (else
            (iter (cdr seq) (cons (deep-reverse (car seq)) result)))))
  (iter x nil))
;> (deep-reverse x)
;(mcons (mcons 4 (mcons 3 '())) (mcons (mcons 2 (mcons 1 '())) '()))
;> 