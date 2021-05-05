; SICP 2.3.1 クォート
;記号を操作するためには、私たちの言語に新しい要素を入れる必要があります。
;それは、データオブジェクトをクォート (quote) する能力です。
;(a b) というリストを構築するという場合について考えてみましょう。
;これは、(list a b)と書いてもうまくいきません。
;この式は、a や b といった記号そのものではなく、その値 (value) を要素としたリストを作ってしまうからです。
;自然言語では、単語や文をそのまま文字の列として扱うということを示すのに、引用符を使うのが一般的です。
;リストや記号について、式として評価の対象にするのでなく、データオブジェクトとして扱いたいというときにも、
;これと同じような慣例に従うことができます。
(define a 1)
(define b 2)
;> (list 'a 'b)
;(mcons 'a (mcons 'b '()))
;> (list 'a b)
;(mcons 'a (mcons 2 '()))
;> (list a b)
;(mcons 1 (mcons 2 '()))
;> (car '(a b c))
;'a
;>

;'() を評価すると空リストが得られます。これによって、変数 nil は必要なくなります。
;記号の操作に使われるもうひとつの基本要素は eq? です。これは二つの記
;号を引数として取り、それらが同じであるかどうかをテストするものです。
(define (memq item x)
  (cond ((null? x) false)
         ((eq? item (car x)) x)
         (else (memq item (cdr x)))))
;> (memq 'apple '(pear banana prune))
;#f
;> (memq 'apple '(x (apple sauce) y apple pear))
;(mcons 'apple (mcons 'pear '()))
;> 