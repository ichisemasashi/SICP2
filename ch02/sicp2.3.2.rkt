; SICP 2.3.2 例: 記号微分
;記号操作の例として、またデータ抽象化の別の例として、代数式の記号微分を
;行う手続きの設計について考えてみましょう。
;手続きは、引数として代数式と変数を取り、その変数に関するその式の導関数を返すようにします。

;;;;;;;;;;
; 抽象データによる微分プログラム
;問題を簡単にするために、二引数の足し算・かけ算という演算だけから構成さ
;れる式だけを扱う、とても単純な記号微分プログラムについて考えることにし
;ます。任意のそのような式の微分は、以下の簡約規則を適用することによって
;行うことができます。
; dc/dx = 0、cが定数またはxと異なる変数のとき、
; dx/dx = 1、
; d(u + v)/dx = du/dx + dv/dx,
; d(uv)/dx = u・dv/dx + v・du/dx
;後ろの二つの規則は本質的に再帰的であるということがわかるでしょうか。
;というのは、和の導関数を求める際には、まずそれぞれの項の導関数を求め、そ
;れらを足すことになるからです。
;これらの規則を手続きという形にするために、有理数の実装を設計したと
;きと同じように、ちょっとした希望的思考をすることにします。
;ここでは、次のようなセレクタ、コンストラクタ、述語を
;実装する手続きがもうできているとします。
;(variable? e)  ;eは変数か？
;(same-variable? v1 v2)  ; v1とv2は同じ変数か？
;(sum? e)  ; eは和か？
;(addend e)  ;和eの加数
;(augend e)  ;和eの被加数
;(make-sum a1 a2)  ;a1とa2の和を構築する
;(product? e)  ;eは積か？
;(multiplier e)  ;積eの乗数
;(multiplicand e)  ;積eの被乗数
;(make-product m1 m2)  ;m1とm2の積を構築する
;これらの手続きと、数値かどうかを判断する基本述語の number? を使って、微
;分の規則を次の手続きのように表現できます。
(define (deriv exp var)
  (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         ((sum? exp) (make-sum (deriv (addend exp) var)
                                  (deriv (augend exp) var)))
         ((product? exp)
          (make-sum (make-product (multiplier exp) (deriv (multiplicand exp) var))
                      (make-product (deriv (multiplier exp) var) (multiplicand exp))))
         (else (error "unknown expression type: DERIV" exp))))

;;;;;;;;;;
; 代数式を表現する
;リスト構造を使って代数式を表現するやり方はいろいろ考えられます。
;ですが、とりわけ素直なやり方は、Lisp が複合式に使うのと同じ、括弧でくくった前置記法を使うというものです。
;つまり、ax + b は (+ (* a x) b) と表現することになります。
;変数は記号である。基本述語 symbol? で識別する。
(define (variable? x)
  (symbol? x))
;二つの変数は、それらを表現する記号が eq? であれば等しい。
(define (same-variable? v1 v2)
  (and (variable? v1)
        (variable? v2)
        (eq? v1 v2)))
;和と積は、リストとして構築する。
(define (make-sum a1 a2)
  (list '+ a1 a2))
(define (make-product m1 m2)
  (list '* m1 m2))
;和は、最初の要素が記号 + であるリストである。
(define (sum? x)
  (and (pair? x)
        (eq? (car x) '+)))
;加数は、和のリストの二つ目の項である。
(define (addend s)
  (cadr s))
;被加数は、和のリストの三つ目の項である。
(define (augend s)
  (caddr s))
;積は、最初の要素が記号 * であるリストである。
(define (product? x)
  (and (pair? x)
        (eq? (car x) '*)))
;乗数は、積のリストの二つ目の項である。
(define (multiplier p)
  (cadr p))
;被乗数は、積のリストの三つ目の項である。
(define (multiplicand p)
  (caddr p))
;> (deriv '(+ x 3) 'x)
;(mcons '+ (mcons 1 (mcons 0 '())))
;> (deriv '(* x y) 'x)
;(mcons '+ (mcons (mcons '* (mcons 'x (mcons 0 '()))) (mcons (mcons '* (mcons 1 (mcons 'y '()))) '())))
;> (deriv '(* (* x y) (+ x 3)) 'x)
;(mcons
; '+
; (mcons
;  (mcons '* (mcons (mcons '* (mcons 'x (mcons 'y '()))) (mcons (mcons '+ (mcons 1 (mcons 0 '()))) '())))
;  (mcons
;   (mcons
;    '*
;    (mcons
;     (mcons '+ (mcons (mcons '* (mcons 'x (mcons 0 '()))) (mcons (mcons '* (mcons 1 (mcons 'y '()))) '())))
;     (mcons (mcons '+ (mcons 'x (mcons 3 '()))) '())))
;   '())))
;>
;プログラムは正しい答えを返します。しかし、答えは簡約されていません。
;しかし、プログラムには x · 0 = 0, 1 · y = y, 0 + y = y だということをわかっていてほしいものです。
;make-sum に変更を加え、もし両方の加数が
;数値であれば、それらを足し合わせて和を返すようにします。また、加数のひ
;とつが 0 であれば、もうひとつの加数のみを返すようにします。
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
         ((=number? a2 0) a1)
         ((and (number? a1) (number? a2)) (+ a1 a2))
         (else (list '+ a1 a2))))
(define (=number? exp num)
  (and (number? exp)
        (= exp num)))
;同じように、make-product に変更を加えて、0 には何をかけても 0 で、1 に何
;かをかけるとその何か自身になるという規則を組み込みます。
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
         ((=number? m1 1) m2)
         ((=number? m2 1) m1)
         ((and (number? m1) (number? m2)) (* m1 m2))
         (else (list '* m1 m2))))
;> (deriv '(+ x 3) 'x)
;1
;> (deriv '(* x y) 'x)
;'y
;> (deriv '(* (* x y) (+ x 3)) 'x)
;(mcons
; '+
; (mcons
;  (mcons '* (mcons 'x (mcons 'y '())))
;  (mcons (mcons '* (mcons 'y (mcons (mcons '+ (mcons 'x (mcons 3 '()))) '()))) '())))
;> 
