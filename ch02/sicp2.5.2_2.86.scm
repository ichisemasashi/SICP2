;; 練習問題 2.86

;;複素数の実部、虚部、絶対値、偏角に、通常の数値や有理数や、これからシステムに追加するその他の数値を
;;使えるようにしたいとする。そのような複素数を使えるようにするために、システムにどのような変更を
;;加える必要があるか説明し、それを実装せよ。
;;通常の数値と有理数に対してジェネリックに使える sine や cosine のような演算を定義する必要があるだろう。

;;データ型をscheme-numberに変換する
(define (install-type->scheme-number-package)
  ;; real -> scheme-number
  (put 'get-scheme-number '(real)
       (lambda (x) (make-scheme-number x)))
  ;;rational -> scheme-number
  (put 'get-scheme-number '(rational)
       (lambda (r)
         (make-scheme-number
          (contents (div (numer r) (denom r))))))
  ;; scheme-number -> scheme-number
  (put 'get-scheme-number '(scheme-number)
       (lambda (x) (make-scheme-number x)))
  'done)

(define (get-scheme-number x)
  (apply-generic 'get-scheme-number x))

;; 基本的な操作を、結合データを扱える形に書き換える
;; 結果をscheme-numberで返す
(define (decorator f)
  (define (transform args)
    (map (lambda (arg)
           (if (number arg)
               (make-scheme-number arg)
               (get-scheme-number arg)))
         args))
  (lambda (first . other)
    (make-scheme-number
     (let ((args (map contents
                      (transform (cons first other)))))
       (apply f args)))))

(define new-square (decorator square))
(define new-sqrt (decorator sqrt))
(define new-add (decorator +))
(define new-sub (decorator -))
(define new-mul (decorator *))
(define new-div (decorator /))
(define sine (decorator sin))
(define cosine (decorator cos))
(define new-atan (decorator atan))
