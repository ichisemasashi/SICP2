;; 練習問題 2.85

;;この節では、あるデータオブジェクトを型のタワーの中で可能な限り下げていくことによって
;;“単純化” するという方法について触れた。
;;練習問題 2.83で述べたタワーについて、これを実行する手続き drop を設計せよ。
;;ポイントは、オブジェクトを下げることができるかどうかを何らかの汎用的なやり方で決めるということにある。
;;例えば、複素数 1.5 + 0i は real まで下げることができ、複素数 1 + 0i は integer まで下げることができるが、
;;複素数 2 + 3i はまったく下げることができない。
;;以下に、あるオブジェクトを下げることができるかどうかを決める計画のひとつを示す。
;;まず、オブジェクトをタワーの中で一階下に “押す” ジェネリック演算 project (射影) を定義する。
;;例えば、複素数の射影では虚部を捨てることになる。こうすると、ある数値を project して、
;;その結果を元の型に raise したときに、最初のものと等しい何かになっていれば、
;;その数値は下げることができるということになる。
;;可能な限りオブジェクトを落とす手続き drop を書くことで、この考え方を実装するやり方を詳しく示せ。
;;いろいろな射影演算を設計し、projectをジェネリック演算としてシステムに組み込むことが必要になる。
;;また、練習問題 2.79で述べたジェネリック等価性述語を利用することも必要となる。
;;最後に、drop を使って練習問題 2.84の apply-generic を書き直し、解答を “単純化” するようにせよ。

;; 有理数パッケージに入れる
(put 'project 'rational
     (lambda (x) (make-scheme-number (round (/ (numer x) (denom x))))))

;; 実数パッケージに追加
(put 'project 'real
     (lambda (x)
       (let ((rat (rationalize (Inexact->exact x) 1/100)))
         (make-rational (numeratro rat)
                        (denominator rat)))))

;;複素数パッケージに追加
(put 'project 'complex
     (lambda (x) (make-real (real-part x))))

(define (drop x)
  (let ((project-proc (get 'project (type-tag x))))
    (if project-proc
        (let ((project-number (project-proc (contexts x))))
          (if (equ? project-number (raise project-number))
              (drop project-number)
              x))
        x)))

;; apply-generic
(drop (apply proc (map contents args)))

