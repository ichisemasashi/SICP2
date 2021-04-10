; SICP 1.3.3 汎用手法としての手続き
; 関数の零点と不動点を見つける汎用手法について検討し、これらが手続きとして直接表現で
; きるということを示します。

;;; 区間二分法(half-interval method)によって方程式の根を求める
; f (a) < 0 < f (b) となる点 a と b があるとき、f は a と b の間に少なくともひとつの零点を持つ
; 零点を特定するためには、a と b の平均を xとして f (x) を計算します。
; もし f (x) > 0 なら、f は a と x の間に零点を持つことになります。
; もし f (x) < 0 なら、f は x と b の間に零点を持ちます。この方法を続けると、
; f が零点を持つ区間をどんどん狭めていくことができます。区間が十分狭くなったら、処理は停止します。
;必要なステップ数の増加オーダーは、元の区間の⻑さを L、許容誤差を T として、
;Θ(log(L/T )) になります。
(load "util.rkt")
(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point) midpoint
       (let ((test-value (f midpoint)))
         (cond ((positive? test-value) (search f neg-point midpoint))
                ((negative? test-value) (search f midpoint pos-point))
                (else midpoint))))))
(define (close-enough? x y)
  (< (abs (- x y)) 0.001))
; search を直接使うと、ちょっと面倒なことがあります。うっかり f の値が符号
; の条件を満たさないような点を与えてしまうかもしれないということです。
; そうする代わりに、以下に示す手続きを経由して search を使う
(define (half-interval-method f a b)
  (let ((a-value (f a)) (b-value (f b)))
    (cond ((and (negative? a-value) (positive? b-value))
            (search f a b))
           ((and (negative? b-value) (positive? a-value))
            (search f b a))
           (else (error "Values are not of opposite sign" a b)))))

;;;;;;;;;
;; 関数の不動点を求める
; 数値 x が方程式 f (x) = x を満たすとき、x は関数 f の 不動点 (fixed point) と
; 呼ばれます。関数 f によっては、最初の推定値から始めて、値があまり変わら
; なくなるまで f を繰り返し適用していくというやり方で不動点を求めることができます。
(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
           next
           (try next))))
  (try first-guess))
; 不動点処理は、1.1.7 節で平方根を求めるのに使った処理と似たところがあります。
;どちらも、解が何らかの基準を満たすようになるまで繰り返し改善していくという考えに基づいています。
; ある数値 x の平方根を求めるには、y^2 = x となるような y を探す必要があります。
; この方程式を等価な形である y = x/y に変えると、求めるものが y → x/y の不動点であることがわかります。
(define (sqrt x)
  (fixed-point (lambda (y) (/ x y)) 1.0))
; ↑ この不動点探索は収束しません。最初の推測値を y1 とします。次の推測値は
; y2 = x/y1 となり、その次は y3 = x/y2 = x/(x/y1 ) = y1 です。
; 結果として、y 1 と y 2 という二つの推測値をずっと繰り返し、答えの両側で振動を続ける無限ループになります。
;このような振動をコントロールする方法のひとつとして、推測値の大きな変化を防ぐ
;ということがあります。答えは常に推測値 y と x/y の間にあるはずなので、
;y と x/y の平均を取ることで、新しい推測値を y からも x/y からもあまり遠くないものにできます。
(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y))) 1.0))
;解に対する連続した近似値の平均を取るというこのアプローチは、
;平均緩和法 (average damping) と呼ばれるテクニックで、不動点探索の収束に
;役に立つことがよくあります。