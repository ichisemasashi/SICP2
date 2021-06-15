; 練習問題 2.71
; n 記号のアルファベットに対するハフマン木があり、記号の相対頻度は 1, 2, 4, . . . , 2^{n−1} であるとする。
; n = 5、 n = 10の場合の木をスケッチせよ。
;そのような木では、(一般の n について) 最も頻度の高い記号を符号化するのに何ビット必要になるだ
;ろうか。最も頻度の低い記号はどうだろうか。

(load "sicp2.3.4_2.70.rkt")

(define n5-tree (generate-huffman-tree '((A 1) (B 2) (C 4) (D 8) (E 16))))

(define n10-tree
  (generate-huffman-tree
   '((n1 1) (n2 2) (n3 4) (n4 8) (n5 16) (n6 32) (n7 64) (n8 128) (n9 256) (n10 512))))

;> (prn n5-tree)
;((leaf E 16 ((leaf D 8 ((leaf C 4 ((leaf B 2 (leaf A 1 (B A 3 )))(C B A 7 )))(D C B A 15 )))(E D C B A 31 ))))
;> (prn n10-tree)
;((leaf n10 512 ((leaf n9 256 ((leaf n8 128 ((leaf n7 64 ((leaf n6 32 ((leaf n5 16 ((leaf n4 8 ((leaf n3 4 ((leaf n2 2 (leaf n1 1 (n2 n1 3 )))(n3 n2 n1 7 )))(n4 n3 n2 n1 15 )))(n5 n4 n3 n2 n1 31 )))(n6 n5 n4 n3 n2 n1 63 )))(n7 n6 n5 n4 n3 n2 n1 127 )))(n8 n7 n6 n5 n4 n3 n2 n1 255 )))(n9 n8 n7 n6 n5 n4 n3 n2 n1 511 )))(n10 n9 n8 n7 n6 n5 n4 n3 n2 n1 1023 ))))

;> (prn (encode '(E) n5-tree))
;(0 ) ; 最も頻度の低い記号
;> (prn (encode '(A) n5-tree))
;(1 1 1 1 )  ; 最も頻度の高い記号
;> (prn (encode '(n1) n10-tree))
;(1 1 1 1 1 1 1 1 1 ) ;最も頻度の高い記号
;> (length (encode '(n1) n10-tree))
;9
;> (prn (encode '(n10) n10-tree))
;(0 ) ;最も頻度の低い記号
