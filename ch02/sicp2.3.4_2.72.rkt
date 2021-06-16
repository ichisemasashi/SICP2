; 練習問題 2.72

;練習問題 2.68で設計した符号化手続きについて考える。
;ひとつの記号を符号化するのに必要なステップ数の増加オーダーはどのようになるだろうか。
;各ノードに着くたびに記号リストを検索するのに必要なステップ数を含めることを忘れないように。
;この問題の一般の場合について答えることは難しい。
;ここでは、n 記号の相対頻度が 練習問題 2.71のようになっている特別な場合について考えよう。
;アルファベット中で頻度が最大の記号と最小の記号を符号化するのにかかるステップ数の増加オーダーを (n の関数として) 答えよ。

;ひとつの記号を符号化するのは 練習問題2.68の encode-symbol.
;(define (encode-symbol symbol tree)
;  (define (search symbol tree)
;    (cond ((leaf? tree) '())
;          ((element-of-set? symbol (symbols (left-branch tree)))
;           (cons 0 (encode-symbol symbol (left-branch tree))))
;          (else
;           (cons 1 (encode-symbol symbol (right-branch tree))))))
;  (if (element-of-set? symbol (symbols tree))
;      (search symbol tree)
;      (error "try to encode NO exist symbol -- ENCODE-SYMBOL" symbol)))

;頻度が最大の記号を符号化する場合
;   - シンボルリストを検索する: O(n)時間
;   - log_nブランチを取る
; 合計で O(n * log_n) 
;頻度が最小の記号を符号化する場合
;   - シンボルリストを検索する: O(n)時間
;   - 次の枝を取る、1つのノードを削除するだけなので、次のようになります。O(n - 1)
; 合計で O(n * (n - 1))、またはO(n^2)

