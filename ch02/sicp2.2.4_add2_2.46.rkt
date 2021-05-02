; 練習問題 2.46
;原点からある一点に張られる二次元ベクトルは、x 座標と y 座標からなるペアとして表現できる。
;コンストラクタmake-vect と、それに対応するセレクタ xcor-vect, ycor-vect を与え、ベクトルに対するデータ抽象化を実装せよ。
;それらのセレクタとコンストラクタによって、ベクトルの足し算、引き算、スカラによるかけ算という演算を行う
;手続き add-vect, sub-vect, scale-vect を実装せよ。
;(x1 , y1 ) + (x2 , y2 ) = (x1 + x2 , y1 + y2 ),
;(x1 , y1 ) − (x2 , y2 ) = (x1 − x2 , y1 − y2 ),
;s·(x, y) = (sx, sy).
(define (make-vect x y)
  (cons x y))
(define (xcor-vect v)
  (car v))
(define (ycor-vect v)
  (cdr v))

(define (eq-vect? v1 v2)
  (and (= (xcor-vect v1) (xcor-vect v2))
        (= (ycor-vect v1) (ycor-vect v2))))
(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
               (+ (ycor-vect v1) (ycor-vect v2))))
(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
               (- (ycor-vect v1) (ycor-vect v2))))
(define (scale-vect s v)
  (make-vect (* s (xcor-vect v))
               (* s (ycor-vect v))))
