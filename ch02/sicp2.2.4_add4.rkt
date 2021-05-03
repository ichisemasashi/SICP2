; SICP 2.2.4 add4 例: 図形言語/ペインタの変形と組み合わせ
;ペインタに対する演算 (flip-vert や beside のようなもの) は、引数として取
;った枠から導出した枠に対して元のペインタを呼び出すようなペインタを作る
;という仕組みで動いています。ですので、例えば flip-vert が画像をひっくり
;返す際に、ペインタがどのように動作しているかを知る必要はありません—枠
;をひっくり返す方法さえわかっていれば大丈夫です。

;ペインタ操作は、transform-painter という手続きに基づいています。
;この手続きは引数として、ペインタと、枠をどのように変形するかという情報を取り、新しいペインタを作ります。
;変形したペインタは、ある枠に対して呼ばれたとき、その枠を変形して、変形した枠に対して元のペインタを呼び出します。
;transform-painter の引数は (ベクトルとして表現した) 複数の点で、新しい枠の頂点を指定するものです。
;これらが枠に対してマップされるとき、一つ目の点は新しい枠の原点を指定し、残り二つの点は枠の辺ベクトルの終点を指定します。
(load "sicp2.2.4_add2.rkt")
(load "sicp2.2.4_add2_2.46.rkt")
(load "sicp2.2.4_add2_2.47.rkt")
(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter (make-frame
                    new-origin
                    (sub-vect  (m corner1) new-origin)
                    (sub-vect (m corner2) new-origin)))))))
;ペインタの画像を上下逆にするには次のようにします。
(define (flip-vert painter)
  (transform-painter painter
                    (make-vect 0.0 1.0)
                    (make-vect 1.0 1.0)
                    (make-vect 0.0 0.0)))
;右上 4 分の 1 のフレームは次のようにして与えられます。
(define (shrink-to-upper-right painter)
  (transform-painter painter
                    (make-vect 0.5 0.5)
                    (make-vect 1.0 0.5)
                    (make-vect 0.5 1.0)))
;画像を反時計回りに 90 度回転させる
(define (rotate90 painter)
  (transform-painter painter
                    (make-vect 1.0 0.0)
                    (make-vect 1.0 1.0)
                    (make-vect 0.0 0.0)))
;画像を枠の中心方向につぶすという変形
(define (squash-inwards painter)
  (transform-painter painter
                    (make-vect 0.0 0.0)
                    (make-vect 0.65 0.35)
                    (make-vect 0.35 0.65)))
;枠の変換は、二つ以上のペインタを組み合わせる手段を定義するためにキーとなるものでもあります。
;例えば、beside 手続きは二つのペインタを引数に取り、それらを引数の枠の左半分と右半分を描画するように変形し、新しい複合ペインタを作ります。
(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left (transform-painter painter1
                                        (make-vect 0.0 0.0)
                                        split-point
                                        (make-vect 0.0 1.0)))
           (paint-right (transform-painter painter2
                                          split-point
                                          (make-vect 1.0 0.0)
                                          (make-vect 0.5 1.0))))
      (lambda (frame)
        (paint-left frame)
        (paint-right frame)))))
;部品となるペインタについて beside が知っておくべきことは、それぞれのペインタ
;が指定した枠に何かを描画するということだけで、そのほかには何も知る必要がありません。