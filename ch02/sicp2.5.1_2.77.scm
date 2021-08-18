;; 練習問題 2.77
;;Louis Reasoner は、式 (magnitude z) を評価しようとした。ここで、z は 図 2.24に示したオブジェクトである。
;;驚いたことに、5 という答えが返ってくるのではなく、apply-generic からのエラーメッセージが返ってきて、
;;型 (complex) には magnitude という演算を行う手続きがないという。
;;彼がこの対話を Alyssa P. Hacker に見せると、Alyssa は “複素数セレクタが polar と rectangular の数値にだけしか定義されていなくて、
;;complex の数値に対して定義されていないのが問題なのよ。動くようにするには complex パッケージに以下の式を追加すれば大丈夫” と言う。

;; (put 'real-part '(complex) real-part)
;; (put 'imag-part '(complex) imag-part)
;; (put 'magnitude '(complex) magnitude)
;; (put 'angle '(complex) angle)

;;なぜこれが動くのか、詳しく説明せよ。

;;---これは、パススルーの役割を果たしています。複素数の演算システムを構築するだけならば、これは無意味な追加レベルです。しかし、この余分なスイッチがあるからこそ、複素数と常数や有理数を組み合わせることができるのです。


;;例として、z が図 2.24に示したオブジェクトであるとき、式 (magnitude z) を評価した際に呼ばれるすべての手続きをトレースせよ。

;;具体的には、apply-generic は何回起動されるだろうか。それぞれの場合について、ディスパッチ先の手続きは何になるだろうか。

;;---複素数の選択肢を complex パッケージに登録していない場合,complex パッケージには タイプタグ complex がついた magnitude 手続きは無いとエラーがでる。
;;   複素数の選択肢を complex パッケージに追加して式 (magnitude z) を評価した場合apply-generic は2回呼び出される.
;;   まず complex タグの付いた演算名 magnitude をデータオブジェクトに渡し、続いて rectangular タグの付いた演算名 magnitude をデータオブジェクトに渡す。
