; SICP 2.2.1 列の表現 ペアを使って構築できる便利な構造
;列 (sequence)— データオブジェクトの順序つき集合

;1, 2, 3, 4 という列はペアのチェーンとして表されます。
;それぞれのペアの car はチェーン内の対応する項で、ペアの cdr はチェーン内の次のペアです。
;最後のペアの cdr は、ペアでない特別な値を指すことによって、列の終端であることを伝えます。
;その値は、箱-ポインタ図では斜線として表され、プログラムでは変数 nil という値として表されます。
;列全体は、入れ子の cons 演算によって構築されます。
(cons 1
     (cons 2
          (cons 3
               (cons 4 nil))))
;入れ子の cons によって作られるこのようなペアの列はリスト (list) と呼ばれます。
;Scheme は、リスト構築を便利にする list という基本手続きを提供しています。
;上の列は、(list 1 2 3 4) によって生成できます。
;一般的に、
;(list ⟨a1⟩ ⟨a2⟩ ... ⟨an⟩)
;= (cons ⟨a1⟩
;       (cons ⟨a2⟩
;            (cons ...
;                 (cons ⟨an⟩
;                      nil)...)))
;Lisp システムは、慣例的にリストを括弧でくくられた要素の列として表示します。
(define one-through-four
  (list 1 2 3 4))
;car はリストの最初の項を選択し、cdr は最初の項以外のすべてからなるサブリストを選択する
;> (car one-through-four)
;1
;> (cdr  one-through-four)
;(mcons 2 (mcons 3 (mcons 4 '())))
;> (car (cdr  one-through-four))
;2
;> (cons 10 one-through-four)
;(mcons 10 (mcons 1 (mcons 2 (mcons 3 (mcons 4 '())))))
;> (cons 5 one-through-four)
;(mcons 5 (mcons 1 (mcons 2 (mcons 3 (mcons 4 '())))))
;>
;nil という値はペアのチェーンを終了させるために使うものですが、
;これを要素のない列空リスト (empty list) と考えることもできます。
;nil という単語は、“無” を意味するラテン語の単語 nihil を短くしたものです。

;;;;;;;;;;
; リスト演算
; - リストを “cdr ダウン” していく
;例: 引数としてリストと数値 n を取り、リストのn 番目のものを返す手続きlist-ref
;リストの要素の番号は 0 から始めるのが慣例
;• n = 0 であれば、list-ref はリストの car を返す。
;• そうでなければ、list-ref はリストの cdr の (n − 1) 番目のものを返す。
(define (list-ref seq n)
  (if (= n 0)
     (car seq)
     (list-ref (cdr seq) (dec n))))
;> (define s (list 1 4 9 16 25))
;> (list-ref s 3)
;16
;>

; - リスト全体を cdr ダウンする
;引数が空リストかどうかテストする基本述語 null?
;例: リストの要素数を返す手続きlength
(define (length s)
  (if (null? s) 0
     (+ 1 (length (cdr s)))))
;> (define o (list 1 3 5 7 9))
;> (length o)
;5
;>
;手続き length は、単純な再帰計画を実装しています。
;簡約ステップは
;• 任意のリストの length は、リストの cdr の length に 1 を足した値である。
;これは、次の基本ケースに着くまで連続的に適用されます。
;• 空リストの length は 0 である。
;length は、反復スタイルで計算することもできます。
(define (length s)
  (define (iter l count)
    (if (null? l) count
       (iter (cdr l) (inc count))))
  (iter s 0))

; - リストを cdr ダウンしながら答えのリストを “cons アップ” する
;例: 二つのリストを引数として取り、要素を連結して新しいリストを作る append 手続き
;append も再帰計画を使って実装されています。
;リスト list1 と list2 を appendするには、
;• もし list1 が空リストであれば、結果は単に list2 である。
;• そうでなければ、list1 の cdr と list2 を append し、その結果に list1の car を cons する。
(define (append l1 l2)
  (if (null? l1) l2
     (cons (car l1) (append (cdr l1) l2))))
;> (define s (list 1 4 9 16 25))
;> (define o (list 1 3 5 7 9))
;> (append s o)
;(mcons 1 (mcons 4 (mcons 9 (mcons 16 (mcons 25 (mcons 1 (mcons 3 (mcons 5 (mcons 7 (mcons 9 '()))))))))))
;> (append o s)
;(mcons 1 (mcons 3 (mcons 5 (mcons 7 (mcons 9 (mcons 1 (mcons 4 (mcons 9 (mcons 16 (mcons 25 '()))))))))))
;> 