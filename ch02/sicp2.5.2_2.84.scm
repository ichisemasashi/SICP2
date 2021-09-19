;; 練習問題 2.84

;;練習問題 2.83の raise 演算を使って apply-generic 手続きを修正して、
;;この節で検討した通り、連続して “上げる” という方法によって
;;引数が同じ型を持つよう強制型変換を行うようにせよ。
;;二つの型のどちらがタワーの中で高い位置にあるかをテストする方法を考える必要がある。
;;システムのほかの部分と “互換性がある” ようなやり方でこれを行い、
;;タワーに新しい階を追加する際に問題を引き起こさないようにせよ。

;;タイプが単純なタワー型に配置されていると仮定した場合。
(define (apply-generic op . args)
  ;;sをtに上げ、成功すればsを返し、そうでなければfalseを返す。
  (define (raise-into s t)
    (let ((s-type (type-tag s))
          (t-type (type-tag t)))
      (cond ((equal? s-type t-type) s)
            ((get 'raise (list s-type))
             (raise-into ((get 'raise (list s-type)) (contents s)) t))
            (else false))))
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((a1 (car args))
                    (a2 (cadr args)))
                (cond ((raise-into a1 a2) (apply-generic op (raise-into a1 a2) a2))
                      ((raise-into a2 a1) (apply-generic op a1 (raise-into a2 a1)))
                      (else (error "No method for these types" (list op type-tags)))))
              (error "No method for these types" (list op type-tags)))))))

