; 練習問題 2.68

;encode 手続きは、引数としてメッセージと木を取り、メッセージを符号化したビットのリストを返す。
(load "sicp2.3.4.rkt")

(define (encode message tree)
  (if (null? message) '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

;encode-symbol は、与えられた木に従って与えられた記号を符号化したビット列を返す。
;この手続きを書け。記号が木に含まれていなければエラーを出すように encode-symbol を設計せよ。
;練習問題 2.67で得た結果をサンプルの木を使って符号化し、それが元のサンプルメッセージと
;同じになるかどうか確認して、書いた手続きをテストせよ。

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (encode-symbol symbol tree)
  (define (search symbol tree)
    (cond ((leaf? tree) '())
          ((element-of-set? symbol (symbols (left-branch tree)))
           (cons 0 (encode-symbol symbol (left-branch tree))))
          (else
           (cons 1 (encode-symbol symbol (right-branch tree))))))
  (if (element-of-set? symbol (symbols tree))
      (search symbol tree)
      (error "try to encode NO exist symbol -- ENCODE-SYMBOL" symbol)))

(load "sicp2.3.4_2.67.rkt")
(define test-message '(A D A B B C A))
;> (prn (encode test-message sample-tree))
;(0 1 1 0 0 1 0 1 0 1 1 1 0 )

;(0 1 1 0 0 1 0 1 0 1 1 1 0) <- sample-message
