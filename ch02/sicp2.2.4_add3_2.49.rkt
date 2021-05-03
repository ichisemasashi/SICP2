; 練習問題 2.49
;segments->painter を使って、以下の基本ペインタを定義せよ。
(load "sicp2.2.4_add3.rkt")
(load "sicp2.2.4_add3_2.48.rkt")

;;;;;;;;;;
; a. 指定された枠の輪郭を描くペインタ。
(define A
  (let ((tl (make-vect 0 1))
         (tr (make-vect 1 1))
         (bl (make-vect 0 0))
         (br (make-vect 1 0)))
    (segments->painter (list (make-segment bl tl)
                                  (make-segment tl tr)
                                  (make-segment tr br)
                                  (make-segment br bl)))))
;;;;;;;;;;;
; b. 枠の対角線同士をつないで “X” を描くペインタ。
(define B
  (let ((tl (make-vect 0 1))
         (tr (make-vect 1 1))
         (bl (make-vect 0 0))
         (br (make-vect 1 0)))
    (segments->painter (list (make-segment bl tr)
                                  (make-segment br tl)))))
;;;;;;;;;;;
; c. 枠の辺の中点をつないで菱形を描くペインタ。
(define C
  (let ((l (make-vect 0 0.5))
         (t (make-vect 0.5 1))
         (r (make-vect 1 0.5))
         (b (make-vect 0.5 0)))
    (segments->painter
      (list (make-segment l t)
             (make-segment t r)
             (make-segment r b)
             (make-segment b l)))))
;;;;;;;;;;;;
; d. wave ペインタ。
 (define wave 
   (segments->painter (list 
                       (make-segment (make-vect .25 0) (make-vect .35 .5)) 
                       (make-segment (make-vect .35 .5) (make-vect .3 .6)) 
                       (make-segment (make-vect .3 .6) (make-vect .15 .4)) 
                       (make-segment (make-vect .15 .4) (make-vect 0 .65)) 
                       (make-segment (make-vect 0 .65) (make-vect 0 .85)) 
                       (make-segment (make-vect 0 .85) (make-vect .15 .6)) 
                       (make-segment (make-vect .15 .6) (make-vect .3 .65)) 
                       (make-segment (make-vect .3 .65) (make-vect .4 .65)) 
                       (make-segment (make-vect .4 .65) (make-vect .35 .85)) 
                       (make-segment (make-vect .35 .85) (make-vect .4 1)) 
                       (make-segment (make-vect .4 1) (make-vect .6 1)) 
                       (make-segment (make-vect .6 1) (make-vect .65 .85)) 
                       (make-segment (make-vect .65 .85) (make-vect .6 .65)) 
                       (make-segment (make-vect .6 .65) (make-vect .75 .65)) 
                       (make-segment (make-vect .75 .65) (make-vect 1 .35)) 
                       (make-segment (make-vect 1 .35) (make-vect 1 .15)) 
                       (make-segment (make-vect 1 .15) (make-vect .6 .45)) 
                       (make-segment (make-vect .6 .45) (make-vect .75 0)) 
                       (make-segment (make-vect .75 0) (make-vect .6 0)) 
                       (make-segment (make-vect .6 0) (make-vect .5 .3)) 
                       (make-segment (make-vect .5 .3) (make-vect .4 0)) 
                       (make-segment (make-vect .4 0) (make-vect .25 0)) 
                       ))) 