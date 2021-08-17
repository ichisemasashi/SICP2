;; SICP 2.5.1 ジェネリック算術演算

;;ジェネリック算術演算を設計するというタスクは、ジェネリック複素数演算を設計するのと似たようなものになります。
;;例えば、通常の数値に対しては基本手続きの足し算 + のようにふるまい、有理数に対しては add-rat のようにふるまい、
;;複素数に対しては add-complex のようにふるまうジェネリックな足し算手続き add がほしいところです。
;;add その他のジェネリック算術演算は、2.4.3 節で複素数のジェネリックなセレクタの実装に使ったのと同じ戦略によって実装できます。
;;それぞれの種類の数値にタイプタグをくっつけ、ジェネリック手続きが引数のデータ型によって適切なパッケージに
;;ディスパッチを行うようにします。

;;ジェネリック算術演算手続きは、次のように定義します。
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

;;まず、通常の (ordinary) 数値、つまり言語の基本数値を扱うパッケージを組み込みます。
;;通常の数値には scheme-number という記号のタグをつけることにします。このパッケージの算術演算は基本算術演算手続きです
;;(つまり、タグなし数値を扱うのに新たに手続きを定義する必要はありません)。
;;これらの演算はそれぞれ二つの引数を取るので、テーブルには (scheme-number scheme-number) というリストをキーとして組み込みます。
(load "util.rkt")

;;演算-型テーブルを操作する put と get という二つの手続きがあるということにします。
;; - (put ⟨op ⟩ ⟨type ⟩ ⟨item ⟩) は、テーブルの ⟨op ⟩ と ⟨type ⟩ が指すところに ⟨item⟩ を入れる。
;; - (get ⟨op ⟩ ⟨type ⟩) は、テーブルから ⟨op ⟩, ⟨type ⟩ の項目を検索し、そこで見つかった項目を返す。
;;   見つからなければ、get は false を返す

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number (lambda (x) (tag x)))
  'done)

;;scheme-number パッケージのユーザは、次の手続きによって (タグつきの) 通常の数値を作成します。
(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

;;ジェネリック算術演算システムの枠組みがもうできているので、新しい種類の数値を加えることは簡単にできます。
;;以下は、有理数算術演算を行うパッケージです。
;;加法性のおかげで、2.1.1 節の有理数のコードを修正なしでパッケージの内部手続きとして使えるというところに注目してください。
(define (install-rational-package)
  ;;内部手続き
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  ;;システムのほかの部分とのインターフェイス
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  'done)
(define (make-rational n d)
  ((get 'make 'rational) n d))

;;複素数を扱う同様のパッケージを、complex というタグを使って組み込みます。
;;このパッケージを作る際に、直交形式と極形式のパッケージで定義した演算 make-from-real-imag と make-from-mag-ang をテーブルから取り出しています。
;;加法性のおかげで、2.4.1 節の手続き add-complex, sub-complex, mul-complex, div-complex が内部手続きとして使えます。
(define (install-complex-package)
  ;;直交形式パッケージと極形式パッケージからインポートした手続き
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;;内部手続き
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))
  ;;システムのほかの部分とのインターフェイス
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

;;複素数パッケージの外部のプログラムは、複素数を構築するのに実部と虚部を使うこともできますし、
;;絶対値と偏角を使うこともできます。元の手続きは、本来は直交形式パッケージと極形式パッケージの中で
;;定義されたものですが、そこから複素数パッケージにエクスポートされ、さらにそこから外の世界へと
;;エクスポートされているというところに注目してください。
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

;;ここでは、二つのレベルのタグシステムができています。3 + 4i のような典型的な複素数は、
;;図 2.24に示すように表現されることになります。外側のタグ (complex) は、数値を複素数パッケージに送るために使われます。
;;複素数パッケージに入ると、次のタグ数値を直交形式パッケージに送るのに (rectangular) タグが使われます。
;;巨大で複雑なシステムでは、多くのレベルが、それぞれ次のレベルとジェネリック演算という手段によって接続されるという形で存在するということがありえます。
;;データオブジェクトが “下向きに” 渡されるにつれ、適切なパッケージに送るために使われた外側のタグは (contentsの適用によって) はがされ、
;;(もしあれば) 次のレベルのタグが見えるようになり、さらなるディスパッチに使われます。

;;上記のパッケージでは、add-rat, add-complex その他の算術演算手続きは、最初に書いたときそのままの状態で使いました。
;;しかし、これらの定義が異なるインストール手続きの内部に入ると、互いに識別できる名前である必要はなくなります。
;;両方のパッケージで、単に add, sub, mul, div という名前をつけていたとしても大丈夫です。
