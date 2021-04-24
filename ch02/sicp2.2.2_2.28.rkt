; 練習問題 2.28
;リストとして表現された木を引数として取り、
;その木のすべての葉を左から右の順で要素として持つリストを返す
;手続き fringe を書け。
(define x (list (list 1 2) (list 3 4)))

(define (fringe tree)
  (cond ((null? tree) nil)
         ((not (pair? (car tree)))
          (cons (car tree) (fringe (cdr tree))))
         (else (append (fringe (car tree))
                         (fringe (cdr tree))))))
;> (fringe x)
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 '()))))
;> (fringe (list 1 2 3 4))
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 '()))))
;> 