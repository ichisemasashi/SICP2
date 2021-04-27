; 練習問題 2.38 fold-left と fold-right
;accumulate 手続きは、列の最初の要素と、右のすべての要素を組み合わせた結果とを組み合わせるため、
;fold-right としても知られている。
;fold-left というものもあり、これは fold-right に似ているが、要素の組み合わせを逆方向に行うという点が違う。
(load "sicp2.2.3.rkt")
(define fold-right accumulate)

(define (fold-left op init seq)
  (define (iter result rest)
    (if (null? rest) result
       (iter (op result (car rest)) (cdr rest))))
  (iter init seq))

(define a (list 1 2 3))
;> (fold-right / 1 a)
;3/2
;> (fold-left / 1 a)
;1/6
;> (fold-right list nil a)
;(mcons 1 (mcons (mcons 2 (mcons (mcons 3 (mcons '() '())) '())) '()))
;> (fold-left list nil a)
;(mcons (mcons (mcons '() (mcons 1 '())) (mcons 2 '())) (mcons 3 '()))
;>

;fold-right と fold-left が任意の列に対して同じ値を返すことを保証するために、
;op が満たさなければならない性質を答えよ。
;fold-leftとfold-rightが同じ結果になるように、opは可換でなければなりません。
;シーケンスを [x1, x2, ... xn] とすると、
;(fold-left op init シーケンス) は(op (op ... (op x1 init) x2) ... xn)となり、
;(fold-right op init sequence)は(op (op ... (op xn init) xn))となります。
;(op xn init) xn-1) ... x1)となります。
;ここで、sequenceが1つの要素しか含まない特殊なケースを考えてみましょう。
;sequence = [x1]とすると、fold-leftは(op init x1)、fold-rightは(op x1 init)となりますが、
;この2つが等しくなるためには、opが可換でなければなりません。