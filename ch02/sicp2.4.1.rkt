; SICP 2.4.1 複素数の表現

;ここでは、ジェネリック演算を使うプログラムの単純で非現実的な例として、複素数に対する算術演算を
;行うシステムを開発していきます。
;まず、複素数を順序つきペアとして表すときに考えられる二つの表現方法、直交形式 (実部と
;虚部) と極形式 (絶対値と偏角) について検討します。 2.4.2 節では、タイプタグとジェネリック演算を使う
;ことによって両方の表現を共存させるやり方を示します。

;有理数と同じように、複素数は順序つきペアとして自然に表現できます。
;複素数の集合は、“実” 軸と “虚” 軸という二つの直交する軸を持つ二次元空間と考えることができます (図 2.20参照)。
;この見方をすると、z = x + iy (i^2 = −1)という複素数は、実座標が x で虚座標が y の平面上の点として考えることが
;できます。複素数の和は、この表現では、座標の和になります。
;   実部(z_1 + z_2 ) = 実部(z_1 ) + 実部(z_2 ),
;   虚部(z_1 + z_2 ) = 虚部(z_1 ) + 虚部(z_2 ).

;複素数をかけ算するときには、複素数を極形式で、つまり大きさと角度 (図 2.20内の r と A) を使って
;考えるほうが自然です。二つの複素数の積は、ひとつの複素数をもう一方の⻑さをかけて伸縮させ、
;もう一方の角度だけ回転させて得られるベクトルになります。
;   大きさ(z_1 · z_2 ) = 大きさ(z_1 ) · 大きさ(z_2 ),
;   角度(z_1 · z_2 )  = 角度(z_1 ) + 角度(z_2 ).
;つまり、複素数には二つの異なる表現があり、それぞれ異なる演算に適しているということです。
;しかし、複素数を使うプログラムを書いている人の視点からは、データ抽象化の原則により、
;コンピュータがどちらの表現を使っていても、複素数の演算すべてが使えるようになって
;いなければいけません。
;例えば、直交形式によって指定された複素数の絶対値が求められると便利なことがよくあります。
;同じように、極形式によって指定された複素数の実部を求められると便利なことがよくあります。

;そのようなシステムを設計するにあたっては、2.1.1 節で有理数パッケージを設計する際に使ったのと
;同じデータ抽象化戦略が使えます。複素数演算は、 real-part, imag-part, magnitude, angle という
;四つのセレクタによって実装されているとします。また、複素数の構築には二つの手続きがあるとします。
; make-from-real-imag は、指定された実部と虚部を持つ複素数を返し、
; make-from-mag-ang は、指定された絶対値と偏角を持つ複素数を返します。
;これらの手続きは、任意の複素数に対して
;( make-from-real-imag ( real-part z) ( imag-part z))
;と
;( make-from-mag-ang ( magnitude z) ( angle z))
;の両方とも z に等しい複素数を返すという性質を持っています。

;これらのコンストラクタとセレクタを使うことで、2.1.1 節で有理数について行ったように、
;コンストラクタとセレクタによって規定される “抽象データ”を使って複素数の算術演算を実装できます。
;上の式に示したように、足し算と引き算は実部と虚部を使って、またかけ算と割り算は絶対値と偏角を使って行えます。
(load "util.rkt")

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

;複素数パッケージを完成させるには、複素数の表現を選び、コンストラクタとセレクタを
;基本数値と基本リストを使って実装しなければいけません。すぐわかるように、この方法は二通りあります。
;“直交形式” のペア (実部、虚部) として表現するか、“極形式” のペア (絶対値、偏角) として表現するかです。
;どちらを選ぶべきでしょうか。

;この二つの選択の具体的な例として、Ben Bitdiddle と Alyssa P. Hacker という、独立に複素数システムの表現を
;設計している二人のプログラマがいると想像してください。
;Ben は複素数を直交形式で表現することにします。この場合、複素数の実部と虚部を選択することや、
;複素数を与えられた実部と虚部から構築することは、素直に実現できます。
;絶対値と偏角を求めたり、複素数を与えられた絶対値と偏角から構築するのは、次のような三角法の関係を使います。
;   x = r cos(A), y = r sin(A),
;   r = sqrt(x^2 + y^2), A = arctan(y, x),
;これは、実部と虚部 (x, y) と絶対値と偏角 (r, A) の関係を表しています。このため、Ben の表現は
;以下のようなセレクタとコンストラクタによって書くことができます。

(define (real-part z)
  (car z))
(define (imag-part z)
  (cdr z))
(define (magnitude z)
  (sqrt (+ (square (real-part z))
           (square (imag-part z)))))
(define (angle z)
  (atan (imag-part z) (real-part z)))
(define (make-from-real-imag x y)
  (cons x y))
(define (make-from-mag-ang r a)
  (cons (* r (cons a)) (* r (sin a))))

;一方、Alyssa は複素数を極形式で表現することにしました。彼女の方法では、絶対値と偏角のセレクトは素直にできます。
;しかし、実部と虚部を求めるには、三角法の関係を使う必要があります。Alyssa の表現は次のようになります。

(define (real-part z)
  (* (magnitude z) (cos (angle z))))
(define (imag-part z)
  (* (magnitude z) (sin (angle z))))
(define (magnitude z)
  (car z))
(define (angle z)
  (cdr z))
(define (make-from-real-imag x y)
  (cons (sqrt (+ (square x) (square y)))
        (atan y x)))
(define (make-from-mag-ang r a)
  (cons r a))

;データ抽象化の規律に従っているため、 add-complex, sub-complex, mul-complex, div-complex の同じ実装が、
;Ben の表現と Alyssa の表現のどちらに対してもうまく動くということが保証されます。

