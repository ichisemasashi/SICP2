;;
;; FILE NAME: metacircular.scm
;;
;; from SICP2

;;;;;;;;;;;;;;;;; 4.1.1 評価器のコア

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eval
;; 引数として式と環境を取り、式を分類して評価を振り分けます。
;;
;; 基本式
;;  • 数値のような自己評価式については、evalは式そのものを返します。
;;  • evalは、環境内で変数を検索して、変数の値を調べる必要があります。
;; 特殊形式
;;  • クォート式については、evalはクォートの中にある式を返します。
;;  • 変数への代入(あるいは変数の定義)は、再帰的にevalを呼び出し、変 数に関連づける新しい値を計算する必要があります。さらに、環境を修 正して、変数束縛を変更 (または作成) する必要があります。
;;  • if式の部品は特殊な処理をする必要があります。述語が真であれば結果 式を評価し、偽であれば代替式を評価するようにするためです。
;;  • ラムダ式は、ラムダ式の規定する引数と本体、それと評価環境をまとめ てパッケージ化し、適用可能な手続きに変形する必要があります。
;;  • begin式は、一連の式を出現順に評価する必要があります。
;;  • 場合分け(cond)は、入れ子のif式に変形し、それから評価します。
;; 組み合わせ
;; • 手続きを適用するためには、evalは組み合わせ中の演算子部分と被演算 子部分を再帰的に評価する必要があります。その結果得られる手続きと 引数は apply に渡し、apply が実際の手続き適用を扱います。
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp) (make-procedure (lambda-parameters exp)
                                       (lambda-body exp)
                                       env))
        ((begin? exp)
          (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
          (apply (eval (operator exp) env) (list-of-values (operands exp) env)))
        (else
          (error "Unknown expression type: EVAL" exp))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; apply
;; apply は二つの引数を取ります。手続きと、その手続きを適用する引数のリストです。apply は手続きを二種類に分類します。基本演算の場合は、apply-primitive-procedure を呼んで適用します。複合手続きの場合は、手続きの本 体を構成する式を順番に評価していくことによって適用を行います。
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
          (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
          (eval-sequence
            (procedure-body procedure)
            (extend-environment
              (procedure-parameters procedure)
              arguments
              (procedure-environment procedure))))
        (else (error
                "Unknown procedure type: APPLY" procedure))))

;;;;;;;;;;;;;;;;; 手続きの引数
;; ist-of-values
;; 組み合わせの被演算子を引数に取り、各被演算子を評価し、対応する値のリストを返します。
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

;;;;;;;;;;;;;;;;; 条件文
;; eval-if 
;; 与えられた環境の中で if 式の述語部分を評価します。もし結果が 真であれば、eval-if は結果式 (consequent) を評価し、そうでなければ代替式 (alternative) を評価します。
(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

;;;;;;;;;;;;;;;;; 列
;; eval-sequence
;; 引数として式の列と環境を 取り、出現順に式を評価していきます。返り値は最後の式の値です。
(define (eval-sequence exps env)
  (cond ((last-exp? exps)
          (eval (first-exp exps) env))
        (else
          (eval (first-exp exps) env)
          (eval-sequence (rest-exps exps) env))))

;;;;;;;;;;;;;;;;; 代入と定義
;; 変数への代入: eval-assignment
;; eval を呼ぶことによって代入する 値を求め、変数とその値を set-variable-value! に渡すことによって指定さ れた環境に設定します。
(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) env)
                       env)
  'ok)
;; 変数の定義 eval-definition
(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
                    env)
  'ok)

;;;;;;;;;;;;;;;;; 4.1.2 式の表現
;; 自己評価式は数値と文字列しかありません。
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))
;; 変数は記号によって表現されます。
(define (variable? exp)
  (symbol? exp))
;; クォート式は(quote <text-of-quotation>)という形式です。
(define (quoted? exp)
  (tagged-list? exp 'quote))
(define (text-of-quotation exp)
  (cadr exp))
;; tagged-list?
;; リストが指定された記号から始まるかどうかを確認する
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))
;; 代入は(set! <var> <value>)という形式です。
(define (assignment? exp)
  (tagged-list? exp 'set!))
(define (assignment-variable exp)
  (cadr exp))
(define (assignment-value exp)
  (caddr exp))
;; 定義は以下の形式か、(define ⟨var⟩ ⟨value⟩)
;;  以下の形式です。 (define (⟨var⟩ ⟨parameter1⟩ ... ⟨parametern⟩) ⟨body⟩)
;;  後者の形式 (標準手続き定義) は、以下のシンタックスシュガーです。
;;  (define ⟨var⟩
;;    (lambda(⟨parameter1⟩ ... ⟨parametern⟩)
;;      ⟨body⟩))
(define (definition? exp)
  (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)    ; 仮引数 
                   (cddr exp))))  ; 本体
;; lambda式は、記号lambdaから始まるリストです。
(define (lambda? exp)
  (tagged-list? exp 'lambda))
(define (lambda-parameters exp)
  (cadr exp))
(define (lambda-body exp)
  (cddr exp))
;; lambda 式のコンストラクタ
(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))
;; 条件式はifで始まり、述語・結果式・(オプションで)代替式を持ちま す。式が代替式部分を持たない場合は、代替式として false を使います。
(define (if? exp)
  (tagged-list? exp 'if))
(define (if-predicate exp)
  (cadr exp))
(define (if-consequent exp)
  (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))
;; if 式に対するコンストラクタ
(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))
;; begin は、式の列を単独の式にパッケージ化します。
(define (begin? exp)
  (tagged-list? exp 'begin))
;; begin 式から実際の列を取り出す演算
(define (begin-actions exp)
  (cdr exp))
(define (last-exp? seq)
  (null? (cdr seq)))
;; 列の最初の式と残りの式を返すセレクタ
(define (first-exp seq)
  (car seq))
(define (rest-exps seq)
  (cdr seq))
;; 列を単一の式に変形する
(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))
;; 手続き適用は、ここまで挙げた式の型に含まれない任意の複合式です。
(define (application? exp)
  (pair? exp))
(define (operator exp)
  (car exp))
(define (operands exp)
  (cdr exp))
(define (no-operands? ops)
  (null? ops))
(define (first-operand ops)
  (car ops))
(define (rest-operands ops)
  (cdr ops))

;;;;;;;;;;;;;;;;; 派生式
;; 特殊形式の中には、直接実装するのではなく、ほかの特殊形式を使った式によって定義できるものもあります。
(define (cond? exp)
  (tagged-list? exp 'cond))
(define (cond-clauses exp)
  (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause)
  (car clause))
(define (cond-actions clause)
  (cdr clause))
(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
      'false ; else 節はない
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last: COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))

;;;;;;;;;;;;;;;;; 4.1.3 評価器のデータ構造

;;;;;;;;;;;;;;;;; 述語のテスト
;; 明示的な false オブジェクト以外はすべて true として受け入れます。
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

;;;;;;;;;;;;;;;;; 手続きの表現
;; (apply-primitive-procedure <proc> <args>)
;; 与えられた基本手続きをリスト ⟨args⟩ 中の引数の値に適用し、 その結果を返します。
;; (primitive-procedure? <proc>)
;; ⟨proc⟩ が基本手続きかどうかテストします。
;; 複合手続きは、コンストラクタ make-procedure を使って、仮引数・手続き 本体・環境によって構築します。
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p)
  (cadr p))
(define (procedure-body p)
  (caddr p))
(define (procedure-environment p)
  (cadddr p))

;;;;;;;;;;;;;;;;; 環境に対する演算
;; (lookup-variable-value <var> <env>)
;; 環境 ⟨env⟩ 内で記号 ⟨var⟩ に束縛されている値を返します。変数が束縛されていない場合、エラーを発生させます。
;; (extend-environment <variables> <values> <base-env>)
;; リスト ⟨variables⟩ の記号がリスト ⟨values⟩ の対応する要素に束 縛されている新しいフレームひとつからなる新しい環境を返します。環 境 ⟨base-env ⟩ が外側の環境となります。
;; (define-variable! <var> <value> <env>)
;; 環境 ⟨env ⟩ の一つ目のフレームに、変数 ⟨var ⟩ と値 ⟨value ⟩ を関 連づける新たな束縛を追加します。
;; (set-variable-value! <var> <value> <env>)
;; 環境 ⟨env⟩ 中の変数 ⟨var⟩ の束縛を変更して、変数を値 ⟨value⟩ に束縛し直します。変数が未束縛であればエラーを発生させます。

;; 環境はフレームのリストとして表現する。リストの cdr が外側の環境となります。空の環境は、単純に空リス トです。
(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

;; 環境のそれぞれのフレームはリストのペアとして表現します。ひとつはそのフレームで束縛される変数のリストで、もうひとつは関連づけられる値のリストです。
(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

;; 変数を値に関連づける新しいフレームによって環境を拡張する
(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

;; 環境内の変数を探すには、一つ目のフレームの変数リストを走査します。求め る変数が見つかれば、値リスト内の対応する要素を返します。現在のフレーム で変数が見つからなければ、外側の環境、さらにその外側の環境と検索してい きます。空の環境に達したら、“未束縛変数” エラーを発生させます。
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars)) (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

;; 指定した環境の中で変数を新しい値に設定する
(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars)) (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable: SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

;; 変数を定義する
(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
              (add-binding-to-frame! var val frame))
            ((eq? var (car vars)) (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame) (frame-values frame))))

;;;;;;;;;;;;;;;;; 4.1.4 評価器をプログラムとして実行する
(define (setup-environment)
  (let ((initial-env
    (extend-environment
      (primitive-procedure-names)
      (primitive-procedure-objects)
      the-empty-environment)))
  (define-variable! 'true true initial-env)
  (define-variable! 'false false initial-env)
  initial-env))
(define the-global-environment (setup-environment))
;; 基本手続きを表現する方法
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))
;; setup-environment
;; 基本手続きの名前と実装手続きをリストから取ります。
(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        ⟨more primitives⟩ ))
(define (primitive-procedure-names)
  (map car primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

;; 基本手続きを適用する
(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
    (primitive-implementation proc) args))
;; 対話型評価環境 (REPL) をモデル化したドライバループ 
(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
       (announce-output output-prompt)
       (user-print output)))
  (driver-loop))
(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))

;; 特別な表示手続きを使い、複合手続きの環境部分を表示しないようにしています
(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

;; 後はグローバル環境を初期化してドライバループを開始するだけで、 評価器を実行できます。
;; (define the-global-environment (setup-environment))
;; (driver-loop)


