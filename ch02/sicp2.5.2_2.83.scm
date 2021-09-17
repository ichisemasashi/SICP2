;; 練習問題 2.83

;;図2.25に示した型のタワー (整数、有理数、実数、複素数) を扱うジェネリック算術演算システムを設計しているとする。
;;それぞれの型 (複素数を除く) に対し、その型のオブジェクトをタワーの中で一階上げる手続きを設計せよ。
;;それぞれの型 (複素数を除く) に対して動作するジェネリックな raise 演算を組み込む方法を示せ。

(define (raise x) (apply-generic 'raise x))

(put 'raise 'integer
     (lambda (x) (make-rational x 1)))

(put 'raise 'rational
     (lambda (x) (make-real (/ (numer x) (denom x)))))

(put 'raise 'real
     (lambda (x) (make-from -real-imag x 0)))


