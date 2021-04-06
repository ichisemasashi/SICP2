; 練習問題 1.29
; 数値積分の方法 シンプソンの公式
; 関数 f の範囲 aから b の定積分は次のように近似される。
; h/3(y_0 + 4y_1 + 2y_2 + 4y_3 + 2y_4 + ... + 2y_{n-2} + 4y_{n-1} + y_n)
; ここで、n を適当な偶整数として h = (b − a)/n で、y_k = f (a + kh)
; である。(n を大きくすると近似の精度が上がる)。

; f , a, b, n を引数に取り、シンプソンの公式によって計算した定積分の値を返す手続き
(load "sicp1.3.1.rkt")
 (define (simpson-integral f a b n) 
   (define h (/ (- b a) n)) 
   (define (yk k) (f (+ a (* h k)))) 
   (define (simpson-term k) 
     (* (cond ((or (= k 0) (= k n)) 1) 
              ((odd? k) 4) 
              (else 2)) 
        (yk k))) 
   (* (/ h 3.0) (sum simpson-term 0 inc n))) 

  

 (define (round-to-next-even x) 
   (+ x (remainder x 2))) 
; (n = 100 と n = 1000 で)cube の範囲 0 から 1 の定積分を求め、上で示した integral 手続きと結果を比較せよ。
;
;> (simpson-integral cube 0 1 100) 
;0.25
;> (simpson-integral cube 0 1 1000) 
;0.25
;> 