;; 練習問題 2.78
;;scheme-number パッケージの内部手続きは、本質的に基本手続き +, - その他に対する呼び出しでしかない。
;;ここでのタイプタグシステムでは、各データオブジェクトに型がくっついていないといけないようになっていたので、
;;直接この言語の基本手続きを使うことはできなかった。しかし、実際のところ、Lisp の実装はすべて型システムを持っていて、内部で使用している。
;;symbol? や number? のような基本述語は、データオブジェクトが特定の型を持つか識別している。
;;2.4.2 節の type-tag, contents, attach-tag の定義を変更し、ここでのジェネリックシステムが Scheme の内部型システムを利用できるようにせよ。
;;つまり、システムの挙動はそのままで、普通の数値を car が scheme-number という記号であるペアとして表すのではなく、
;;単に Scheme の数値として表現されるようにせよ。

(define (attach-tag type-tag contents)
  (if (number? contents) contents
      (cons type-tag contents)))
(define (type-tag x)
  (cond ((number? x) 'scheme-number)
        ((pair? x) (car x))
        (else (error "Wrong datum --TYPE-TAG" x))))
(define (contents x)
  (cond ((number? x) x)
        ((pair? x) (cdr x))
        (else (error "Wrong datum -- CONTENTS" x))))
