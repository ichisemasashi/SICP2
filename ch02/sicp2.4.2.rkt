; SICP 2.4.2 タグつきデータ

;データ抽象化は、“最小責任の原則” の応用として見ることもできます。2.4.1節で複素数システムを実装したとき、
;Ben の直交形式による表現と Alyssa の極形式による表現のどちらを使うこともできました。
;セレクタとコンストラクタが抽象化の壁を作っているため、データオブジェクトの具体的な表現に何を選ぶかということを
;最後の瞬間まで遅らせることができ、そのためシステム設計の柔軟性を最大限にできます。

;最小責任の原則は、さらに極限まで進めることができます。
;もし望むなら、セレクタとコンストラクタを設計した “後” になっても表現を曖昧にしたままで、
; Ben の表現と Alyssa の表現の “両方” を使うようにすることもできます。
;しかし、両方の実装が単独のシステムに含まれている場合、極形式のデータと直交形式のデータを
;区別するための何らかの方法が必要になります。そうしないと、例えば (3, 4) というペアの magnitude (絶対値) を
;求めるよう言われた場合に、答えを (数値を直交形式と解釈して)5 とするべきか (数値を極形式と解釈して)3 とするべきか
;わかりません。これを区別できるようにする素直なやり方は、タイプタグ (type tag)---rectangular または polar という記号---
;を、それぞれの複素数の一部として含めるというものです。こうすると、複素数を操作することが必要になったときに、
;どちらのセレクタを適用するべきかをこのタグを使って決めることができます。

;タグつきデータを操作するために、type-tag と contents という手続きを持っていると想定します。
;type-tag はデータオブジェクトからタグを抽出するもので、
;contents は実際の中身 (複素数の場合、極形式または直交形式の座標) を抽出するものです。
;また、attach-tag という手続きも持っていると仮定します。
;これは、タグと中身を取り、タグつきデータオブジェクトを返すというものです。
;これを実装する素直なやり方は、普通のリスト構造を使うというものです。

(define (attach-tag type-tag contents)
  (cons type-tag contents))
(define (type-tag datum)
  (if (pair? datum) (car datum)
      (error "Bad tagged datum: TYPE-TAG" datum)))
(define (contents datum)
  (if (pair? datum) (cdr datum)
      (error "Bad tagged datum: CONTENTS" datum)))

;これらの手続きを使って、直交形式と極形式をそれぞれ識別する述語 rectangular?, polar? を定義できます。

(define (rectangular? z)
  (eq? (type-tag z) 'rectangular))
(define (polar? z)
  (eq? (type-tag z) 'polar))

;タイプタグを使うことにしたので、Ben と Alyssa はコードを修正して、異なる表現が同じシステムの中で
;共存できるようにしました。Ben が複素数を構築するたびに、それに直交形式というタグをつけます。
;Alyssa が複素数を構築するたびに、それに極形式というタグをつけます。それに加えて、Ben と Alyssa は
;それぞれの手続きの名前が衝突しないようにしなければいけません。これを行う方法としては、Ben が自分の表現の
;手続きに接尾辞 rectangular を追加し、 Alyssa は自分の表現手続きに polar を追加するというものがあります。
;以下は、2.4.1 節の Ben の直交形式表現を修正したものです。
(load "util.rkt")
(define (real-part-rectangular z)
  (car z))
(define (imag-part-rectangular z)
  (cdr z))
(define (magnitude-rectangular z)
  (sqrt (+ (square (real-part-rectangular z))
           (square (imag-part-rectangular z)))))
(define (angle-rectangular z)
  (atan (imag-part-rectangular z)
        (real-part-rectangular z)))
(define (make-from-real-imag-rectangular x y)
  (attach-tag 'rectangular (cons x y)))
(define (make-from-mag-ang-rectangular r a)
  (attach-tag 'rectangular (cons (* r (cos a)) (* r (sin a)))))

;Alyssa の極形式表現の修正版のは次のようになりました。

(define (real-part-polar z)
  (* (magnitude-polar z) (cos (angle-polar z))))
(define (imag-part-polar z)
  (* (magnitude-polar z) (sin (angle-polar z))))
(define (magnitude-polar z)
  (car z))
(define (angle-polar z)
  (cdr z))
(define (make-from-real-imag-polar x y)
  (attach-tag 'polar
              (cons (sqrt (+ (square x) (square y)))
                    (atan y x))))
(define (make-from-mag-ang-polar r a)
  (attach-tag 'polar (cons r a)))

;どちらのジェネリックセレクタも、引数のタグをチェックして、そのタイプのデータを扱う適切な手続きを
;呼ぶ手続きとして実装されています。
;例えば、複素数の実部を得る場合、real-part はタグを調べ、Ben の real-part-rectangular
;と Alyssa の real-part-polar のどちらを使うのかを決定します。
;どちらの場合でも、contents を使って生のタグなしデータを取り出し、それを必要に応じて
;直交形式または極形式の手続きに渡します。

(define (real-part z)
  (cond ((rectangular? z) (real-part-rectangular (contents z)))
        ((polar? z)       (real-part-polar (contents z)))
        (else (error "Unknown type: REAL-PART" z))))
(define (imag-part z)
  (cond ((rectangular? z) (imag-part-rectangular (contents z)))
        ((polar? z)       (imag-part-polar (contents z)))
        (else (error "Unknown type: IMAG-PART" z))))
(define (magnitude z)
  (cond ((rectangular? z) (magnitude-rectangular (contents z)))
        ((polar? z)       (magnitude-polar (contents z)))
        (else (error "Unknown type: MAGNITUDE" z))))
(define (angle z)
  (cond ((rectangular? z) (angle-rectangular (contents z)))
        ((polar? z)       (angle-polar (contents z)))
        (else (error "Unknown type: ANGLE" z))))

;複素数の算術演算を実装するのには、2.4.1 節の手続き add-complex, sub-
;complex, mul-complex, div-complex と同じものが使えます。
;それらが呼び出すセレクタはジェネリックなので、どちらの表現を使っても動くからです。
;例えば、手続き add-complex は相変わらずそのままで、以下のようになります。

(define (add-complex z1 z2)
  (make-from-real-imag (+ (real-part z1) (real-part z2))
                       (+ (imag-part z1) (imag-part z2))))
