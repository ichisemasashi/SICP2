; 練習問題 2.47
;枠のコンストラクタに対し、適切なセレクタを加えて枠の実装を完成させよ。
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))
(define (frame-origin f)
  (car f))
(define (frame-edge1 f)
  (cadr f))
(define (frame-edge2 f)
  (caddr f))
;---
(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define (frame-origin f)
  (car f))
(define (frame-edge1 f)
  (cadr f))
(define (frame-edge2 f)
  (cddr f))