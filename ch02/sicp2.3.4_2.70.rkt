; 練習問題 2.70
;以下に示す 8 記号の相対頻度つきアルファベットは、1950 年代のロックの歌詞を
;効率よく符号化できるよう設計されたものである (“アルファベット” の “記号” が単独の文字である
;とは限らないことに注意)。

;A 2
;BOOM 1
;GET 2
;JOB 2
;SHA 3
;NA 16
;WAH 1
;YIP 9

;generate-huffman-tree(練習問題 2.69) を使って対応するハフマン木を生成し、
;encode (練習問題 2.68) を使って次のメッセージを符号化せよ。

;Get a job
;Sha na na na na na na na na
;Get a job
;Sha na na na na na na na na
;Wah yip yip yip yip yip yip yip yip yip
;Sha boom

;符号化には何ビット必要だろうか。もし固定⻑符号をこの 8 記号アルファベットに使ったとしたら、
;最低でどれだけのビット数が必要になるだろうか。

(load "sicp2.3.4_2.68.rkt")
(load "sicp2.3.4_2.69.rkt")

(define rock-tree (generate-huffman-tree '((A 2) (BOOM 1) (GET 2) (JOB 2) (SHA 3) (NA 16) (WAH 1) (YIP 9))))

(define rock-song '(GET A JOB SHA NA NA NA NA NA NA NA NA GET A JOB SHA NA NA NA NA NA NA NA NA WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP SHA BOOM))
(define encoded-rock-song (encode rock-song rock-tree))

;> (prn rock-tree)
;((leaf NA 16 ((leaf YIP 9 ((leaf SHA 3 ((leaf A 2 ((leaf GET 2 ((leaf JOB 2 ((leaf BOOM 1 (leaf WAH 1 (BOOM WAH 2 )))(JOB BOOM WAH 4 )))(GET JOB BOOM WAH 6 )))(A GET JOB BOOM WAH 8 )))(SHA A GET JOB BOOM WAH 11 )))(YIP SHA A GET JOB BOOM WAH 20 )))(NA YIP SHA A GET JOB BOOM WAH 36 ))))
;> (prn encoded-rock-song)
;(1 1 1 1 0 1 1 1 0 1 1 1 1 1 0 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 0 1 1 1 0 1 1 1 1 1 0 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 0 1 1 1 1 1 1 0 )
;> (length encoded-rock-song)
;87
;> ;ロックの曲を固定長の符号化で表現すると、1シンボルあたり3ビット（8＝2^3）が必要となり、つまりは
;(* 3 (length rock-song))
;108


