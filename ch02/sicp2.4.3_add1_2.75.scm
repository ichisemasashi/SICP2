;; 練習問題 2.75
;;コンストラクタmake-from-mag-angをメッセージパッシングスタイルで実装せよ。
;;この手続きは、上で与えた make-from-real-imag と似たようなものになるだろう。
(define (make-from-mag-ang r a)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (* r (cos a)))
          ((eq? op 'imag-part) (* r (sin a)))
          ((eq? op 'magnitude) r)
          ((eq? op 'angle) a)
          (else (error "Unknown op -- MAKE-FROM-MAG-ANG" op))))
  dispatch)
