;; 練習問題 2.81

;;Louis Reasoner は、引数の型がすでに同じであっても、apply-generic は引数を
;;お互いの型に強制型変換しようとしてもいいのではないかと気がついた。
;;そのため、それぞれの型の引数をそれ自身の型に強制型変換 (coerce) する手続きを
;;強制型変換テーブルに入れる必要があると彼は考えた。
;;例えば、上に示した scheme-number->complexという強制型変換に加え、彼は次のことを行う。

(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)
(put-coercion 'scheme-number
              'scheme-number
              scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

;;;;;;;;;;
;; a. Louisの強制型変換手続きを組み込むと、もしscheme-number 型の二つの引数や
;;complex 型の二つの引数とある演算に対して apply-generic が呼ばれ、
;;その演算がテーブル内でそれらの型に対して見つからない場合は、
;;何が起こるだろうか。

;; -> apply-genericはcoerced型に対して再帰的に自分自身を呼び出すので、無限再帰になってしまいます。

;; 例えば、ジェネリックな指数関数演算を定義したとする。
(define (exp x y)
  (apply-generic 'exp x y))

;;そして、Scheme-number パッケージに対して指数関数手続きを追加し、
;;ほかのパッケージには追加しないとする。

;;以下は Scheme-number パッケージに追加する
(put 'exp '(scheme-number scheme-number)
     (lambda (x y) (tag (expt x y))))
     ;; 基本手続きexptを使う

;;exp を二つの複素数の引数で呼び出した場合、何が起こるだろうか。


;;;;;;;;;;
;; b.同じ型の引数に対する強制型変換について手を加えないといけないとする Louis の考え方は正しいだろうか。
;;それとも、apply-generic はそのままの状態で正しく動作するだろうか。

;; ->  Louisのコードは動作しません。apply-genericはそのまま動作します。




;;;;;;;;;;
;; c.apply-genericを修正し、二つの引数が同じ型であれば強制型変換を試行しないようにせよ。

(define (apply-generic op . args)
  (define (no-method type-tags)
    (error "No method for these types"
           (list op type-tags)))
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (if (equal? type1 type2)
                    (no-method type-tags)
                    (let ((t1->t2 (get-coercion type1 type2))
                          (t2->t1 (get-coercion type2 type1))
                          (a1 (car args))
                          (a2 (cadr args)))
                      (cond (t1->t2 (apply-generic op (t1->t2 a1) a2))
                            (t2->t1 (apply-generic op a1 (t2->t1 a2)))
                            (else (no-method type-tags))))))
              (no-method type-tags))))))
