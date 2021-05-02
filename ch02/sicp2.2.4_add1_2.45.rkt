; 練習問題 2.45 汎用の分割演算

; split 手続きを定義せよ。
(define (split orig-placer split-placer)
  (lambda (painter n)
    (if (= n 0) painter
       (let ((smaller ((split orig-placer split-placer) painter (dec n))))
         (orig-placer painter (split-placer smaller smaller))))))

(define right-split (split beside below))
(define up-split (split below beside))
; (paint (right-split mark-of-zorro 2))
; (paint (up-split mark-of-zorro 3))