; 練習問題 2.51
;ペインタに対する below 演算を定義せよ。
; below は二つのペインタを引数に取る。
;返り値となるペインタは、枠が与えられたとき、一つ目のペインタで枠の下部を描画し、二つ目のペインタで上部を描画する。
;二つのやり方で below を定義せよ。
;一つ目は、上に示した beside 手続きと似たような手続きを書くというもので、
;二つ目は、beside と適切な回転演算 (練習問題 2.50のもの) によって定義するというものである。
(load "sicp2.4.4_add4_2.50.rkt")
(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-bottom (transfrom-painter painter1
                                          (make-vect 0.0 0.0)
                                          (make-vect 1.0 0.0)
                                          split-point))
           (paint-top (transform-painter painter2
                                        split-point
                                        (make-vect 1.0 0.5)
                                        (make-vect 0.0 1.0))))
      (lambda (frame)
        (paint-bottom frame)
        (paint-top frame)))))
;---
(define (below painter1 painter2)
  (rotate90 (beside (rotate270 painter1)
                       (rotate270 painter2))))
