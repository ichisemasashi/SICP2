; SICP 2.4.3 データ主導プログラミングと加法性
;データの型をチェックし適切な手続きを呼ぶ一般的な戦略は型によるディスパッチ (dispatching on type) と呼ばれるものです。
;これは、システム設計でモジュール性を達成するための強力な戦略です。
;一方で、2.4.2 節のようにディスパッチを実装することには二つの大きな弱点があります。
;弱点のひとつは、ジェネリックインターフェイス手続き (real-part, imag-part, magnitude, angle)
;がすべての異なる表現について知っていなければいけないということです。
;例えば、複素数の新しい表現をこの複素数システムに組み込みたいとします。
;そのためには、この新しい表現を型で識別できるようにして、それから各ジェネリックインターフェイス手続きに
;その新しい型をチェックする節を追加し、そしてその表現に対する適切なセレクタを適用することが必要になるでしょう。

;このテクニックのもうひとつの弱点は、個々の表現は別々に設計できるものの、
;システム全体で二つの手続きが同じ名前を持つということがないように保証しなければならないということです。
;このために、Ben と Alyssa は2.4.1節の元の手続きの名前を変える必要があったのでした。

;この二つの弱点の元となっているのは、ジェネリックインターフェイスを実装するテクニックが
;加法的 (additive) でないということです。
;ジェネリックセレクタ手続きを実装する人は、新しい表現が組み込まれるたびにそれらの手続きを変更しなければならず、
;また個々の表現のインターフェイスを作る人は、名前の衝突を避けるためにコードを変更しなければなりません。
;どちらの場合でも、コードに加えるべき変更は単純なものですが、それでもやはり行わなければならず、
;このことが不便さとエラーの原因になります。
;これは複素数システムに関しては現時点ではあまり大きな問題ではありませんが、
;仮に複素数の表現が二つではなく数百個あったとしたらどうでしょうか。
;また、抽象データインターフェイスにはメンテナンスするべきジェネリックセレクタが数多くあるとしたらどうでしょうか。
;また、すべてのインターフェイス手続きやすべての表現について知っているプログラマが誰もいないとしたらどうでしょうか。
;この問題は現実的なもので、大規模データベース管理システムのようなプログラムではこの問題に取り組む必要があります。

;ここで、システム設計をさらにモジュール化するための手段が必要になります。
;データ主導プログラミング (data-directed programming) として知られるプログラミングテクニックはその手段を提供してくれます。
;データ主導プログラミングがどうやって動くのかを理解するために、まず次のことに注目します。
;いろいろな型の集合に対して共通のものとなるジェネリック演算を扱う際にはいつも、実質的には、
;ひとつの軸が可能な演算で、もうひとつの軸が可能な型であるような二次元のテーブルを扱っていることになります。
;テーブルの項目は、それぞれの引数の型に対するそれぞれの演算を実装する手続きです。
;前の節で開発した複素数システムでは、演算の名前、データタイプ、実際の手続きの間の対応関係は、
;ジェネリックインターフェイス手続きのいろいろな条件節の中に広がっていました。
;しかし、それと同じ情報を図 2.22に示すようにテーブルの中に構造化することもできたところです。

;データ主導プログラミングは、そのようなテーブルを直接扱うようにプログラムを設計するテクニックです。
;前のほうで、複素数算術演算のコードと、それぞれ型によって明示的なディスパッチを行う手続きの集合となっている
;二つの表現パッケージとの間の橋渡しをするメカニズムを実装しました。
;ここでは、そのインターフェイス部分を、演算の名前と引数の型の組み合わせをテーブルから検索して適用するべき
;正しい手続きを見つけ、それを引数の中身に適用するということを行う、単一の手続きとして実装します。
;こうすると、新しい表現パッケージをシステムに追加する際に、既存の手続きには何の変更も加えなくても大丈夫です。
;テーブルに新しい項目を追加するだけで十分です。

;この計画を実装するために、演算-型テーブルを操作する put と get という二つの手続きがあるということにします。
; • (put ⟨op⟩ ⟨type⟩ ⟨item⟩) は、テーブルの ⟨op⟩ と ⟨type⟩ が指すところに⟨item⟩ を入れる。
; • (get ⟨op ⟩ ⟨type ⟩) は、テーブルから ⟨op ⟩, ⟨type ⟩ の項目を検索し、そこ
;    で見つかった項目を返す。見つからなければ、get は false を返す。

;今のところは、put と get は言語に含まれているということにします。
;第 3 章(3.3.3 節) では、これらを含め、テーブル操作演算の実装方法について学びます。

;それでは、複素数システムでデータ主導プログラミングをどう使うかについて見ていきましょう。
;直交形式表現を開発した Ben は、元のものと同じようにコードを実装します。
;それから手続きの集合、つまりパッケージ (package)を定義し、システムに直交形式の数値の扱い方を
;知らせるテーブルに項目を追加することで、これらの手続きをシステムのほかの部分と接続します。
;これは、次の手続きを呼ぶことで行えます。
(load "util.rkt")

(define (install-rectangular-package)
  ;; 内部手続き
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))

  ;; システムのほかの部分とのインターフェイス
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

;ここでの内部手続きが、 2.4.1 節で Ben が単独で書いたものと同じ手続きであることに注目してください。
;これらをシステムのほかの部分と接続するのに、変更を加える必要はありません。
;それに、これらの手続きの定義は組み込み手続きの内部にあるので、
;直交形式パッケージの外のほかの手続きと名前が衝突する心配もありません。
;これらの手続きをシステムのほかの部分と接続するために、Ben は自分の real-part 手続きを、
;演算名 real-part と型 (rectangular)のところに入れます。ほかのセレクタも同じようにします。
;このインターフェイスは、システムのほかの部分から使うためのコンストラクタも定義しています。
;コンストラクタは Ben が内部で定義していたものと同じですが、タグをつけるというところが違います。

;Alyassa の極形式パッケージも似たようなものになります。

(define (install-polar-package)
  ;; 内部手続き
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z) (* magnitude z) (cos (angle z)))
  (define (imag-part z) (* magnitude z) (sin (angle z)))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))
  ;; システムのほかの部分とのインターフェイス
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

;Ben と Alyssa は、相手のものと同じ名前 (例えば、 real-part など) によって定義された元々の手続きをまだ使っていますが、
;これらの定義は今では別々の手続きの内部定義 (1.1.8 節参照) になっているので、名前の衝突は起こりません。

;複素数算術演算セレクタは、apply-generic というジェネリック “演算” 手続きを使ってテーブルにアクセスします。
;これは、ジェネリック演算を引数に適用するものです。apply-generic は、テーブルから演算の名前と引数の型に
;対応する箇所を検索し、手続きがあればそれを適用します。

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error "No method for these types: APPLY-GENERIC"
                 (list op type-tags))))))

;apply-generic を使うと、複素数演算のジェネリックセレクタは以下のように定義できます。

(define (real-part z)
  (apply-generic 'real-part z))
(define (imag-part z)
  (apply-generic 'imag-part z))
(define (magnitude z)
  (apply-generic 'magnitude z))
(define (angle z)
  (apply-generic 'angle z))

;新しい表現がシステムに追加されてもこれらはまったく変わらないということに注意してください。

;また、このパッケージの外部のプログラムが、実部と虚部や絶対値と偏角から複素数を作る際に使うコンストラクタを
;抽出することもできます。2.4.2節と同じように、実部と虚部がある場合は直交形式の複素数を構築し、
;絶対値と偏角がある場合は極形式の複素数を構築します。

(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rectangular) x y))
(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'polar) r a))

