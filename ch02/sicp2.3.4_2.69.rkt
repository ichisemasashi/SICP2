; 練習問題 2.69
;以下の手続きは、引数として記号・頻度ペアのリスト (同じ記号が二つ以上のペアに出てくることはない) を取り、
;ハフマンアルゴリズムに従ってハフマン符号化木を生成する。
(load "sicp2.3.4.rkt")

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

;make-leaf-set は、上で記述した、ペアのリストを葉の順序つき集合に変換する手続きである。
;successive-merge は、集合の中で重みが最小の要素を make-code-tree を使って順番にくっつけていき、
;最後に要素がひとつだけ残るようにするというものである。その要素が求めるハフマン木となる。
;この手続きを書け (この手続きにはちょっと厄介なところがあるが、そこまで複雑ではない。も
;し手続きの設計が複雑になったとしたら、ほぼ確実に何かを間違えている。
;順序つきの集合表現を使っているということが大きな助けになる)。

(define (successive-merge leaf-set)
  (if (<= (length leaf-set) 1) leaf-set
      (let ((left (car leaf-set))
            (right (cadr leaf-set)))
        (successive-merge (adjoin-set (make-code-tree left right)
                                      (cddr leaf-set))))))

;;;
(define (successive-merge leaf-list)
  (define (successive-it ll tree)
    (if (null? ll) tree
        (successive-it (cdr ll)
                       (make-code-tree (car ll) tree))))
  (successive-it (cdr leaf-list) (car leaf-list)))



