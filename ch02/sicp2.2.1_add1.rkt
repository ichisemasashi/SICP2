; SICP 2.2.1 列の表現 ペアを使って構築できる便利な構造/リストに対するマップ
;リストのそれぞれの要素に何らかの変換を適用し、結果のリストを返す演算

;例えば、次の手続きは与えられた係数をリストのそれぞれの数値にかけます。
(define (scale-list seq factor)
  (if (null? seq) nil
     (cons (* factor (car seq))
            (scale-list (cdr seq) factor))))
;> (scale-list (list 1 2 3 4 5) 10)
;(mcons 10 (mcons 20 (mcons 30 (mcons 40 (mcons 50 '())))))
;>

;この一般的な考え方を抽象化し、
;1 引数の手続きとリストを引数として取り、リストのそれぞれの要素に手続きを適用した結果のリストを返す
(define (map proc seq)
  (if (null? seq) nil
     (cons (proc (car seq))
            (map proc (cdr seq)))))
;> (map abs (list -10 2.5 -11.6 17))
;(mcons 10 (mcons 2.5 (mcons 11.6 (mcons 17 '()))))
;> (map (lambda (x) (* x x)) (list 1 2 3 4))
;(mcons 1 (mcons 4 (mcons 9 (mcons 16 '()))))
;>
;map を使って scale-list の新しい定義を書く
(define (scale-list seq factor)
  (map (lambda (x) (* x factor)) seq))
;map は共通パターンを捉えている
;map はリストを扱ううえでのより高いレベルの抽象化を達成する
;元の scale-list の定義では、プログラムは再帰構造になっていて、リストの要素ごとの処理に注意が向くが
;map によって scale-list を定義すると、そのレベルの細かいことは隠されて、
;係数倍というものが要素のリストを結果のリストに変換するものであるというところが強調されます。
;二つの定義の違いは、コンピュータが実行するプロセスの違いではなく (プロセスは同じものです)、
;私たちがプロセスをどう捉えるかという違いです。

;map は、リストを変形する手続きの実装を、リストの要素をどうやって取り出して結合していくか
;という細かいところから切り離す抽象化の壁を作ることを助けてくれます。
;この抽象化を使うことで、列を列に変形するという概念的な演算の枠組みを保ったままで、
;列の実装方法という低レベルな詳細を変更できる柔軟性が得られます。
