; SICP 2.2.3 標準インターフェイスとしての列
;データ抽象化のおかげでデータ表現の細かいところに煩わされることなくプログラムが設計できる
;また抽象化によってほかの表現を実験する柔軟性を確保できる

;データ構造を扱ううえでのもうひとつの強力な設計原則
;標準インターフェイス (conventional interface) の使用

;1.3 節では、数値を扱うプログラムについて、プログラムの抽象化を高階手続きとして実装することによって
;共通のパターンを捉えることができるということを見てきました。
;複合データについて同じような演算を定式化する能力は、私たちがデータ構造を操作するスタイルに決定的に依存します。
;例えば、2.2.2 節の count-leaves と同じような仕組みで、木を引数に取り、奇数の葉の二乗の合計を計算するというもの
(load "util.rkt")
(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
         ((atom? tree) (if (odd? tree) (square tree) 0))
         (else (+ (sum-odd-squares (car tree))
                   (sum-odd-squares (cdr tree))))))
; 表面的には、この手続きは以下に示す手続きとまったく違うように見えます。
;与えられた整数 n 以下の k について、フィボナッチ数 Fib(k)のうち偶数のもののリストを構築する手続き
(define (even-fibs n)
  (define (next k)
    (if (< n k) nil
       (let ((f (fib k)))
         (if (even? f) (cons f (next (inc k)))
            (next (inc k))))))
  (next 0))
;これら二つの手続きはとても似通っている
;sum-odd-squares がしていることは、
;• 木の葉を列挙し、
;• フィルタによって奇数を選び、
;• 選ばれた数の二乗を求め、
;• + を使って、0 から始めて結果を集積する。
;even-fibs は、
;• 0 から n までの数値を列挙し、
;• それぞれの整数に対するフィボナッチ数を求め、
;• フィルタによって偶数を選び、
;• cons を使って、空リストから始めて結果を集積する。
;sum-odd-squares は 列挙 (enumerator) から始まります。この列挙は、与えられた木が持つ葉からなる “信号” を生成します。
;この信号は フィルタ (filter) に渡され、奇数要素以外がすべて取り除かれます。
;その結果となる信号は、今度はマップ (map) に渡されます。このマップは、それぞれの要素に square を適用する “変換器” です。
;マップの出力は、それから集積器 (accumulator) に与えられ、集積器は 0 から始めて要素を + によって組み合わせます。
;even-fibs の図式も、同じような仕組みです。

;残念ながら、上に示した二つの手続きの定義は、この信号の流れという構造を見せることができていません。
;全体的に、どちらの手続きにも、信号の流れという描写の中の要素に対応するはっきりとした部分というものはありません。
;この二つの手続きでは、計算過程を違う方法で分解しています。
;列挙処理をプログラム全体に広げ、それをマップ、フィルタ、集積の処理と混ぜ合わせているのです。
;信号の流れという構造が手続きの中で明確に見て取れるようにプログラムを構成できれば、
;結果となるコードの概念的な明確さを高めることができるでしょう。

;;;;;;;;;;
; 列の演算
;信号の流れという構造をより明確に反映するようにプログラムを構成するうえでのポイントは、
;処理の中で各段階の間を流れる “信号” に集中するということです。
;これらの信号をリストとして表現するなら、各段階の処理を実装するのにリスト演算を使うことができます。
;例えば、信号の流れ図の中でのマップ段階は、2.2.1 節の map 手続きを使って実装できます。
;> (map square (list 1 2 3 4 5))
;(mcons 1 (mcons 4 (mcons 9 (mcons 16 (mcons 25 '())))))
;>
;列をフィルタリングして、与えられた述語を満足する要素だけを選択するのは、次のようにすればできます。
(define (filter predicate seq)
  (cond ((null? seq) nil)
         ((predicate (car seq))
          (cons (car seq) (filter predicate (cdr seq))))
         (else (filter predicate (cdr seq)))))
;> (filter odd? (list 1 2 3 4 5))
;(mcons 1 (mcons 3 (mcons 5 '())))
;>
;集積は、次のように実装できます。
(define (accumulate op init seq)
  (if (null? seq) init
     (op (car seq)
          (accumulate op init (cdr seq)))))
;> (accumulate + 0 (list 1 2 3 4 5))
;15
;> (accumulate * 1 (list 1 2 3 4 5))
;120
;> (accumulate cons nil (list 1 2 3 4 5))
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 (mcons 5 '())))))
;>

;後は、処理する要素の列を列挙するだけです。
(define (enumerate-interval low high)
  (if (< high low) nil
     (cons low (enumerate-interval (inc low) high))))
;> ( enumerate-interval 2 7)
;(mcons 2 (mcons 3 (mcons 4 (mcons 5 (mcons 6 (mcons 7 '()))))))
;> 
;木の葉の列挙は、
(define (enumerate-tree tree)
  (cond ((null? tree) nil)
         ((atom? tree) (list tree))
         (else (append (enumerate-tree (car tree))
                          (enumerate-tree (cdr tree))))))
;> ( enumerate-tree (list 1 (list 2 (list 3 4)) 5))
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 (mcons 5 '())))))
;>
;これで、sum-odd-squares と even-fibs を、信号の流れ図として示したような形で定式化し直すことができます。
;sum-odd-squares のほうは、木の葉の列を列挙し、これをフィルタにかけて列の奇数だけが残るようにし、それぞれの要素を二乗し、結果を合計します。
(define (sum-odd-squares tree)
  (accumulate + 0
             (map square (filter odd? (enumerate-tree tree)))))
;even-fibs のほうでは、0 から n までの整数を列挙し、これらの整数のそれぞれに対するフィボナッチ数を生成し、
;結果の列をフィルタにかけて偶数の要素だけが残るようにし、結果をリストに集積します。
(define (even-fibs n)
  (accumulate cons nil
             (filter even? (map fib (enumerate-interval 0 n)))))

;プログラムを列の演算として表すことの利点は、モジュール化された形でのプログラムの設計がやりやすくなるということにあります。
;モジュール化とは、比較的独立した部品を組み立ててプログラムを構築する設計のことです。
;標準コンポーネントのライブラリとともに、コンポーネントを柔軟に接続できる標準インターフェイスを提供することで、
;モジュール化された設計を促すことができます。

;例 最初の n + 1 個のフィボナッチ数の二乗のリストを構築する手続き
(define (list-fib-squares n)
  (accumulate cons nil
             (map square (map fib (enumerate-interval 0 n)))))
;> ( list-fib-squares 10)
;(mcons 0 (mcons 1 (mcons 1 (mcons 4 (mcons 9 (mcons 25 (mcons 64 (mcons 169 (mcons 441 (mcons 1156 (mcons 3025 '())))))))))))
;>

;整数列の中の奇数のものの二乗の積を計算する手続き
(define (product-of-squares-of-odd-elements seq)
  (accumulate * 1
             (map square (filter odd? seq))))
;> ( product-of-squares-of-odd-elements (list 1 2 3 4 5))
;225
;>

;一般的なデータ処理アプリケーションを列の演算として定式化することもできます。
;人事記録の列があるとして、最も給料の高いプログラマの給料を見つけたいとします。
;ある人事記録に含まれる給料を返す salary というセレクタと、
;ある人事記録がプログラマのものであるかをチェックする programmer? というセレクタが用意されているとします。
;すると、次のように書くことができます。
(define (salary-of-highest-paid-programmer records)
  (accumulate max 0 (map salary (filter programmer? records))))

;ここでリストとして実装した列というものは、処理モジュールを接続できるようにする標準インターフェイスとして使うことができます。
;また、構造を列として統一的に表現するときに、プログラム中でのデータ構造の依存関係が少ない数の列の演算に局所化されるようにしています。
;これらを変えることで、プログラムの全体的な設計に手を加えずに、列の表現方法をいろいろ試してみることができます。
