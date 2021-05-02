; SICP 2.2.4 例: 図形言語
;この節では、図形を描く簡単な言語を紹介し、それによって抽象と閉包の持つ力を示し、また高階手続きの本質的な部分を利用します。
;この言語では、組み合わされるデータオブジェクトは、リスト構造ではなく手続きとして表現されます。
;閉包性を満たす cons によってどんな複雑なリスト構造でも簡単に構築できるのと同じように、
;この言語の演算も閉包性を満たしていて、どんな複雑なパターンでも簡単に構築できます。
;---
;;;;;
; 図形言語
;言語を記述する際には言語の基本要素、組み合わせ方法、抽象化方法にフォーカスを当てることが重要だ
;この図形言語のエレガントさの一部は、ペインタ (painter) という一種類の要素しかないというところにあります。
;ペインタは、指定された平行四辺形型の枠にフィットするように画像をずらしたり拡大縮小したりしたものを描画します。
;例えば、wave(mark-of-zorro) という基本ペインタがあり、粗い線画を描きます。実際の線画の形は枠によって変わります
;もっと手の込んだペインタもあります。rogers(einstein) という基本ペインタ
;画像を結合するには、与えられたペインタから新しいペインタを構築するいろいろな演算を使います。
;例えば、beside 演算は二つのペインタを引数に取り、枠の左半分に一つ目のペインタの画像を描き右半分に二つ目のペインタの画像を描く新しい複合ペインタを作ります。
;同じように、below は二つのペインタを引数に取り、二つ目のペインタの画像の下に一つ目のペインタの画像を描く複合ペインタを作ります。
;単独のペインタを変形して別のペインタを作る演算もあります。
;例えば、flip-vert はひとつのペインタを引数に取り、その画像を上下逆に描くプリンタを作ります。
;また、flip-horiz は元のペインタの画像を左右逆に描くプリンタを作ります。

;wave から始めて、二段階を経て構築した wave4 というペインタの描く画像
(define wave mark-of-zorro)
(define wave2 (beside wave (flip-vert wave)))
(define wave4 (below wave2 wave2))
;複雑な画像をこの方法で構築する際に、ペインタがこの言語の結合手段について閉じているということを利用しています。
;二つのペインタの beside やbelow は、それ自身ペインタになります。
;そのため、より複雑なペインタを作るのに、それを要素として使うことができます。
;リスト構造を cons を使って構築する場合と同じように、データが結合手段について閉じているということは、
;少しの演算によって複雑な構造を作る能力を実現するうえで決定的に重要なことです。
;ここで、ペインタ演算を Scheme の手続きとして実装することにします。
;例えば、wave4 に出てくるパターンは次のように抽象化できます。
(define (flipped-pairs painter)
  (let ((painter2 (beside painter (flip-vert painter))))
    (below painter2 painter2)))
(define wave4 (flipped-pairs wave))
;また、再帰演算を定義することもできます。
;右方向に枝分かれしていくペインタを作る再帰演算
(define (right-split painter n)
  (if (= n 0) painter
     (let ((smaller (right-split painter (dec n))))
       (beside painter (below smaller smaller)))))
;上方向にも枝分かれさせることで、バランスの取れたパターンを作ることもできます
(define (corner-split painter n)
  (if (= n 0) painter
     (let ((up (up-split painter (dec n)))
            (right (right-split painter (dec n))))
       (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (dec n))))
         (beside (below painter top-left)
                   (below bottom-right corner))))))
;corner-split の四つのコピーを適切に配置することによって、square-limitというパターンを得ることができます。
(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))