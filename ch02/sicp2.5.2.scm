;; SICP 2.5.2 異なる型のデータを組み合わせる

;;ここまで、統合算術演算システムの定義の仕方について見てきました。
;;このシステムは、通常の数値、複素数、有理数を含み、またこのほかどんな数値のタイプでも
;;作って組み込むことができるものでした。しかし、無視してきた重要な問題がひとつあります。
;;ここまでで定義してきた演算は、異なるデータ型を完全に独立したものとして扱うようになっています。
;;つまり、例えば二つの通常の数字を足すのと二つの複素数を足すのに別々のパッケージがあるということです。
;;考えの対象外にしていたのは、型の境界を超えた演算、例えば複素数と通常の数値との足し算のようなものに
;;ついて考えることに意味があるという事実です。
;;私たちは、プログラムの部品同士の間に壁を作り、独立して開発したり理解したりできるようにすることに
;;多大な労力をつぎ込んできました。
;;ここでは、注意深くコントロールされたやり方でクロスタイプ (異なる型同士) の演算を導入し、
;;モジュール境界を大きく壊すことなくそれらの演算をサポートできるようにします。

;;クロスタイプ演算を扱う方法のひとつは、可能な型の組み合わせの中で、演算が有効であるものそれぞれに対して
;;別々の手続きを設計するというものです。
;;例えば、複素数パッケージを拡張し、複素数と実数の足し算を提供するようにして、
;;(complex scheme-number) というタグを使ってテーブルに組み込むということができます。

;; 複素数パッケージに含める
(define (add-complex-to-schemenum z x)
  (make-from-real-imag (+ (real-part z) x) (imag-part z)))
(put 'add '(complex scheme-number)
     (lambda (z x) (tag (add-complex-to-schemenum z x))))

;;このテクニックはうまくいくのですが、面倒です。このようなシステムでは、新しい型を導入するコストが、
;;その型を扱う手続きのパッケージの構築だけでは終わらず、
;;クロスタイプ演算を実装する手続きを構築して組み込む分まで必要になります。
;;これはあっという間に、その型自身の演算を定義するのに必要な分よりずっと多い量になってしまいます。
;;この手法はまた、別々のパッケージを加法的に組み合わせる能力を台無しにしてしまいます。
;;少なくとも、個々のパッケージを実装する人がほかのパッケージについてあまり考慮しないでいいようにするという
;;能力は台無しになってしまいます。
;;例えば、上の例では、複素数と通常の数値の混合演算を扱うのが複素数パッケージの責任だということは妥当に見えます。
;;しかし、有理数と複素数を組み合わせるのは、複素数パッケージでやってもいいし、
;;有理数パッケージでやってもいいし、これら二つのパッケージから演算を抽出する何らかの第三ののパッケージでやっても
;;いいかもしれません。複数のパッケージにわたる責任の分割について一貫したポリシーを策定するということは、
;;多くのパッケージと多くのクロスタイプ演算を伴うシステムを設計する際には、どうしようもないほど大変なタスクになって
;;しまうでしょう。

;;;;;;;;;;
;; 強制型変換

;;まったく関係のない型同士のまったく関連のない演算という一般的な状況では、たとえ面倒でも、
;;明示的なクロスタイプ演算を実装することぐらいしかできません。
;;幸い普通は、型システムに隠れているかもしれない積み上げ式の構造を利用して、もっとうまくやることができます。
;;別々のデータ型が完全に独立しているというわけではなく、
;;ある型のオブジェクトをほかの型と見なす方法があるということはよくあります。
;;このプロセスは、強制型変換 (coercion) と呼ばれます。
;;例えば、通常の数値と複素数を算術演算によって組み合わせることを求められたら、
;;通常の数値を虚部がゼロの複素数と見なすことができます。こうすると、
;;この問題を二つの複素数を組み合わせる問題に変換でき、
;;複素数パッケージによって普通のやり方で扱うことができるようになります。

;;一般に、ある型のオブジェクトを等価なほかの型のオブジェクトに変換する強制型変換手続きを設計することによって、
;;この考え方を実装できます。以下のものは典型的な強制型変換手続きで、与えられた通常の数値を、
;;実部がその数値で虚部がゼロの複素数に変換します。

(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))

;;これらの強制型変換手続きは、特別な強制型変換テーブルに組み込むことにします。二つの型の名前をキーとして使います。

(put-coercion 'scheme-number
              'complex
              scheme-number->complex)

;;(このテーブルを操作するための手続き put-coercion と get-coercion が存在すると仮定しています)
;;一般に、このテーブルにはいくつか空きができます。
;;すべての型の任意のデータオブジェクトをほかのすべての型に強制型変換するということは、
;;一般的には可能でないからです。例えば、任意の複素数を実数に強制型変換する方法というものはありません。
;;そのため、一般的な complex- >scheme-number 手続きがテーブルに含まれるということはありません。

;;強制型変換テーブルが準備できたら、2.4.3 節の apply-generic 手続きに変更を加えることによって、
;;強制型変換を統一的に扱うことができるようになります。
;;演算を適用することを求められたら、最初はこれまでと同じように引数の型に対して演算が定義されているかどうかチェックします。
;;定義されていれば、演算-型テーブルで見つかった手続きにディスパッチします。
;;定義されていなければ、強制型変換を試みます。
;;簡単にするために、ここでは引数が二つの場合だけを考えます。強制型変換テーブルを見て、一つ目の型のオブジェクトが
;;二つ目の型に強制型変換可能かどうか確認します。可能であれば、一つ目の引数を強制型変換し、もう一度演算を試みます。
;;もし一つ目の型のオブジェクトが二つ目の型に一般的に強制型変換できないのであれば、
;;逆に二つ目の引数を一つ目の引数の型に強制型変換できないか試してみます。
;;最後に、どちらの型についてももう一方の型に強制型変換する既知の方法がなければ、諦めます。
;;手続きは以下のようになります。

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2 (apply-generic op (t1->t2 a1) a2))
                        (t2->t1 (apply-generic op a1 (t2->t1 a2)))
                        (else (error "No method for these types"
                                     (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))

;;上でざっくり見たように、この強制型変換という構想は、明示的にクロスタイプ演算を定義するという手法に比べて
;;多くのメリットがあります。型同士を関連づけるために強制型変換手続きを書く
;;(n 個の型を持つシステムに対しては、最大で n^2 個の手続き)ということはやはり必要ですが、
;;書く必要があるのはそれぞれの型のペアに対して手続きひとつだけで、それぞれの型の集合と
;;それぞれのジェネリック演算に対して別々の手続きを書く必要はありません。
;;ここでは、型同士の適切な変換は型そのものによって決まり、適用する演算には依存しないという事実を利用しています。

;;一方、この強制型変換構想の持つ汎用性では十分でない応用もあるかもしれません。
;;組み合わせるオブジェクトのどちらももう一方の型に変換できないという場合でも、
;;両方のオブジェクトを第三の型に変換することで演算の実行が可能かもしれません。
;;そのような複雑な場合を扱いながらプログラムのモジュール性を維持するためには、
;;普通は型同士の関係のさらに深い構造を利用するシステムを構築することが必要になります。
;;これについては次節で検討します。

;;;;;;;;;;
;; 型の階層

;;上で紹介した強制型変換構想は、型のペアの間に自然な関係があるということを頼りにしていました。
;;しかし、異なる型の間の関係には、より “グローバルな” 構造があるということがよくあります。
;;例えば、整数、有理数、実数、複素数を扱うジェネリック算術演算システムを構築しているとしましょう。
;;そのようなシステムでは、整数を特別な種類の有理数と見なし、有理数を特別な種類の実数と見なし、
;;実数を特別な種類の複素数と見なすというのはとても自然です。ここで実際に扱っているのはいわゆる
;;型の階層 (hierarchy of types) というもので、その中では、例えば整数は有理数のサブタイプ (subtype)
;;(つまり、有理数に適用できる任意の演算は自動的に整数に適用できる)ということになります。
;;逆に、有理数は整数のスーパータイプ (supertype) と呼びます。ここで扱っている特定の階層はとても単純なもので、
;;それぞれの型は高々ひとつのスーパータイプと高々ひとつのサブタイプを持ちます。
;;このような構造はタワー (tower) と呼ばれます。図2.25にこの構造を示します。

;;もし扱っているのがタワー構造であれば、階層に新しい型を追加するという問題はとても簡単にできます。
;;新しい型をすぐ上のスーパータイプに組み入れる方法と、新しい型がすぐ下の型のどのようなスーパータイプであるかを
;;記述するだけで十分だからです。例えば、複素数と整数の足し算をしたい場合、明示的に integer->complex という
;;特別な強制型変換手続きを定義する必要はありません。その代わりに、整数の有理数への変換方法、有理数の実数への変換方法、
;;実数の複素数への変換方法を定義します。次に、システムがこれらのステップを通して整数を複素数に変換できるようにして、
;;それから二つの複素数を足し合わせます。

;;apply-generic 手続きは、次のように設計し直すことができます。それぞれの型に対して、その型のオブジェクトを
;;タワーの一階上に“上げる”raise という手続きを用意します。こうすると、システムが異なる型のオブジェクトの演算
;;を行うよう求められたとき、すべてのオブジェクトが塔の同じ階に揃うようになるまで低い型を連続して上げていく
;;ということができるようになります (練習問題 2.83と練習問題 2.84は、そのような戦略の実装の詳細に関係するものです)。

;;タワーの別の利点として、すべての型がスーパータイプに定義されたすべての演算を “継承する” という概念を簡単に
;;実装できるということがあります。例えば、整数に対して実部を求める特別な手続きを提供していないとしても、
;;整数は複素数のサブタイプなので、整数に対しても real-part が定義されていることが期待されます。
;;タワーであれば、apply-generic を修正して、統一的な方法でこれを実現できます。もし必要な演算が与えられたオブジェクトの型に
;;対して直接定義されていなければ、オブジェクトをそのスーパータイプに上げて再試行します。こうやって、
;;望む演算が実行可能になる階にたどり着くか、てっぺんに当たるか (その場合はあきらめることになります) するまで、
;;引数を変換しながらタワーを登っていきます。

;;より一般的な階層に対してのタワーのもう一つの利点は、データオブジェクトを最も単純な表現に “下げる” ことが簡単にできる
;;ということがあります。例えば、2 + 3i と 4 − 3i を足す場合、複素数 6 + 0i という形で答えを得るよりも、
;;整数の 6 という答えを得るほうがいいでしょう。練習問題 2.85では、そのようなレベル下げ演算について検討します
;;(注意すべきところは、レベル下げが可能な 6 + 0i のようなオブジェクトと、レベル下げが不可能な 6 + 2i のような
;;オブジェクトを見分ける一般的な方法が必要だというところです)。

;;;;;;;;;;
;; 階層の不適切さ

;;システムのデータ型が自然にタワーとして配置できる場合、ここまで見てきたように、異なる型同士のジェネリック演算の問題はとても単純になります。
;;残念ながら、普通はそうはいきません。図 2.26 はいろいろな型のより複雑な関係を図示したものです。
;;この例では、さまざまな型の幾何学図形同士の関係を示しています。この図から、一般的にはひとつの型が二つ以上のサブタイプを持つ
;;ということが見て取れます。例えば、三角形と四角形はどちらも多角形のサブタイプです。それに加えて、ひとつの型が二つ以上の
;;スーパータイプを持つこともあります。例えば、直角二等辺三角形は二等辺三角形と見なすこともできますし、直角三角形と見なすこともできます。
;;この複数スーパータイプ問題は特に厄介です。ある型を階層の中で “上げる” ための唯一の方法というものがないということになるからです。
;;あるオブジェクトにある演算を適用する際に、“正しい” スーパータイプを見つけるために、apply-generic のような手続きが
;;型ネットワーク全体の中をかなり検索しないといけないことになるかもしれません。一般的に、ひとつの型には複数のサブタイプがあるので、
;;値を型階層の中で “下げる” 強制型変換にも同じような問題があります。巨大システムを設計する際に、モジュール性を保ちながら相互に
;;関連する多くの型を取り扱うということは非常に難しく、現在多くの研究がなされている領域です。
