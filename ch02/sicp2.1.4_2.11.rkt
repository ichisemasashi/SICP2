; 練習問題 2.11
;区間の両端点の符号をテストすると mul-interval は 9 パターンに場合分けできて、
;3 回以上のかけ算が必要になるのはその中のひとつだけ
(load "sicp2.1.4_2.08.rkt")
(define (mul-interval x y)
  (let ((xl (lower-bound x))
         (xu (upper-bound x))
         (yl (lower-bound y))
         (yu (upper-bound y)))
    (cond ((< 0 xl)
            (cond ((< 0 yl) (make-interval (* xl yl) (* xu yu)))
                   ((< yu 0) (make-interval (* xu yl) (* xl yu)))
                   (else     (make-interval (* xu yl) (* xu yu)))))
           ((< xu 0)
            (cond ((< 0 yl) (make-interval (* xl yu) (* xu yl)))
                   ((< yu 0) (make-interval (* xu yu) (* xl yl)))
                   (else     (make-interval (* xl yu) (* xl yl)))))
            (else
             (cond ((< 0 yl) (make-interval (* xl yu) (* xu yu)))
                    ((< yu 0) (make-interval (* xu yl) (* xl yl)))
                    (else    (make-interval
                                (min (* xl yu) (* xu yl))
                                (max (* xl yl) (* xu yu)))))))))
