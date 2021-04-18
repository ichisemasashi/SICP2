; 練習問題 1.27
; フェルマーテストを騙してしまうカーマイケル数 (Carmichael number)
;   561, 1105, 1729, 2465, 2821, 6601, ...
(load "sicp1.2.6.rkt")

; http://community.schemewiki.org/?sicp-ex-1.27

(define (test-fermat-prime n expected)
  (define (report-result n result expected)
    (newline)
    (display n)
    (display ":")
    (display result)
    (display ":")
    (display (if (eq? result expected) "OK" "FOOLED")))
  (report-result n (full-fermat-prime? n) expected))
(define (full-fermat-prime? n)
  (define (iter a n)
    (if (= a n) true
         (if (= (expmod a n n) a) (iter (+ a 1) n) false)))
  (iter 1 n))

;> (test-fermat-prime 2 true) 
;
;2:#t:OK
;> (test-fermat-prime 14 false) 
;
;14:#f:OK
;> (test-fermat-prime 561 false)
;
;561:#t:FOOLED
;> (test-fermat-prime 1105 false)
;
;1105:#t:FOOLED
;> (test-fermat-prime 1729 false)
;
;1729:#t:FOOLED
;> (test-fermat-prime 2465 false)
;
;2465:#t:FOOLED
;> (test-fermat-prime 2821 false)
;
;2821:#t:FOOLED
;> (test-fermat-prime 6601 false)
;
;6601:#t:FOOLED
;> 