; 練習問題 2.2 平面上の線分を表現する
; それぞれの線分は、始点と終点という点のペアとして表す。
;コンストラクタ make-segment とセレクタ start-segment, end-segmentを定義せよ。
;点は x 座標と y 座標という数値のペアとして表現できる。
;最後に、定義したセレクタとコンストラクタによって、線分を引数として取りその中点
;(両端点の座標を平均した座標を持つ点) を返す midpoint-segment 手続きを定義せよ。
;点を表示する
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))
(define (make-point x y)
  (cons x y))
(define (x-point p)
  (car p))
(define (y-point p)
  (cdr p))
;---
(define (make-segment p1 p2)
  (cons p1 p2))
(define (start-segment p)
  (car p))
(define (end-segment p)
  (cdr p))
(define (print-segment s)
  (let ((S (start-segment s))
         (E (end-segment s)))
    (newline)
    (display "(")
    (display (x-point S))
    (display ",")
    (display (y-point S))
    (display ")--(")
    (display (x-point E))
    (display ",")
    (display (y-point E))
    (display ")")))
;---
(define (midpoint-segment s)
  (let ((S (start-segment s))
         (E (end-segment s)))
    (make-point (/ (+ (x-point S) (x-point E)) 2.0)
                  (/ (+ (y-point S) (y-point E)) 2.0))))