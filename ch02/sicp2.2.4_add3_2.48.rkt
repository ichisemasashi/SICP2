; 練習問題 2.48
;平面上の方向つきの線分は、ベクトルのペア—原点から線分の始点へと張られるベクトルと、原点から線分の終点へと張られるベクトル—として表現できる。
;練習問題 2.46で書いたベクトル表現を使って、
;make-segment というコンストラクタと start-segment と end-segment というセレクタによって線分の表現を定義せよ。
(load "sicp2.2.4_add2_2.46.rkt")
(define (make-segment start-point end-point)
  (list (make-vect 0 start-point)
         (make-vect 0 end-point)))
(define (start-segment seg)
  (car seg))
(define (end-segment seg)
  (cadr seg))