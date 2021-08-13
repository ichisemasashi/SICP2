; 練習問題 2.74
;Insatiable Enterprises, Inc.(貪欲エンタープライズ 社) は、
;世界中に散らばった多数の独立事業所からなる分散型複合企業である。
;この会社のコンピュータ設備は、どのユーザから見ても
;ネットワーク全体がひとつのコンピュータのように見えるような
;巧妙なネットワークインターフェイス方式によって相互接続されたところだ。
;貪欲社の社長は、初めてネットワークの機能を使って事業所ファイルから
;管理情報を取り出そうとして愕然とした。
;事務所ファイルはすべて Scheme のデータ構造として実装されているのに、
;使われている個々のデータ構造は事業所ごとに違うのだ。
;事業所長会議が急遽開かれ、事業所の独立性をこれまで通りに保ったままで、
;本部の要求を満たせるようにファイルを統合する戦略を探ることになった。

;そのような戦略をデータ主導プログラミングによって実装する方法を示せ。
;例として、各事業所の人事記録は単独のファイルからなり、
;従業員の名前をキーとしたレコードの集合を持っているとする。
;集合の構造は事業所ごとに異なる。さらに、各従業員のレコードは
;それ自身が (事業所ごとに異なる構造を持つ) 集合で、address と salary のような
;識別子をキーとした情報を含んでいるとする。 具体的には、

;;;;;;;;;;
; a.
;指定した人事ファイルから指定した従業員のレコードを取得する
; get-record 手続きを本部向けに実装せよ。
;この手続きは、任意の事業所のファイルに適用できる必要がある。
;個々の事業所のファイルはどのように構造化しなければならないか説明せよ。
;具体的には、どのような型情報を提供する必要があるだろうか。

;; foo x division table に基づいて get-record を実装する。
;; 各分割ファイルは、'type'を除外する分割(division)関数を持ち、特定の get-record を含む instalation パッケージを提供しなければなりません。出力はタグ付きレコードです。Get-recordは、従業員のレコードが見つからない場合には、falseを返さなければなりません(c)。
(define (attach-tag type-tag content) (cons type-tag content))
(define (get-record employee-id file)
  (attach-tag (division file)
              ((get 'get-record (division file)) employee-id file)))

;;;;;;;;;;
;; b.
;;任意の事業所の人事ファイル内の与えられた職員のレコードから給与情報を返す
;get-salary 手続きを本部向けに実装せよ。
;この演算が動くようにするには、レコードはどのように構造化しなければならないだろうか。
(define (get-salary record)
  (let ((record-type (car record))
        (record-content (cdr record)))
    ((get 'get-salary record-type) record-content)))

;;;;;;;;;;
;; c.
;; 本部向けに、find-employee-record手続きを実装せよ。
;この手続きは、全事業所のファイルから与えられた従業員を検索し、該当レコードを返す。
;引数として、従業員名と全事業 所のファイルのリストを取るとせよ。

(define (find-employee-record employee-id file-list)
  (if (null? file-list) false
      (let ((current-file (car file-list)))
        (if (get-record employee-id current-file)
            (get-record employee-id current-file)
            (find-employee-record employee-id (cdr file-list))))))

;;;;;;;;;;
;; d.
;;貪欲社が新しい会社を吸収した場合、新しい人事情報を中央システムに
;組み入れるためにはどのような変更が必要になるだろうか。

;; 新会社は、新部門としてのrecord-fileのインストールパッケージを提供しなければなりません。このインストールパッケージには、新部門のget-recordおよびget-salaryの実装が含まれていなければならない。
