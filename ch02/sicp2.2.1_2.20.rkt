; 練習問題 2.20 任意の数の引数を取る手続き
;ドット末尾記法 (dotted-tail notation)
;手続きの定義の中で、仮引数リストの最後の仮引数名の前にドットのあるものは、
;手続きが呼ばれるときに、前のほうの仮引数は (もしあれば) 通常通り前のほうの引数の値を持つことになるが、
;最後の仮引数の値は残りの引数すべてのリスト (list) となる。

;ひとつ以上の整数を引数として取り、最初の引数と同じ偶奇性を持つ引数すべてのリストを返す手続き same-parity を書け。
(define (same-parity . l)
  (let ((p? (if (even? (car l)) even? odd?)))
    (define (iter l)
      (let ((first (car l))
             (rest (cdr l)))
        (cond ((null? rest) (if (p? first) (list first) nil))
               ((p? first) (cons first (iter (cdr l))))
               (else (iter (cdr l))))))
    (iter l)))
