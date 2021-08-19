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
