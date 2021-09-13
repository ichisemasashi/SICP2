;; 練習問題 2.82

;;apply-generic を一般化し、複数の引数一般について強制型変換を扱うようにするやり方を示せ。
;;戦略のひとつとしては、すべての引数を一つ目の引数の型に強制型変換することを試み、
;;次に二つ目の引数の型に強制型変換することを試み、ということを続けるというものだ。
;;この戦略について (また、上で述べた二引数バージョンについても)、
;;それが十分に一般的でないような状況の例を挙げよ
;;(ヒント:テーブルには適切な混合型演算があり、それが試行されないという場合について考える)。

(define (any-false? items)
  (cond ((null? items) false)
        ((not (car items)) true)
        (else (any-false? (cdr items)))))

(define (coerce type-tags args)
  (define (iter tags)
    (if (null? tags) false
        (let ((type-to (car tags)))
          (let ((coercions
                 (map (lambda (type-from)
                        (if (eq? type-from type-to)
                            (lambda (x) x);;identity "coercion" for same-types
                            (get-coercion type-from type-to)))
                      type-tags)))
            (if (any-false? coercions)
                (iter (cdr tags))
                (map (lambda (coercion arg) (coercion arg))
                     coercions
                     args))))))
  (iter type-tags))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (let ((coerced-args (coerce type-tags args)))
            (if coerced-args
                (let ((coerced-type-tags (map type-tag coerced-args)))
                  (let ((new-proc (get op coerced-type-tags)))
                    (apply new-proc (map contents coerced-args))))
                (error "No method for these types"
                       (list op type-tags))))))))

