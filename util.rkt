#lang r5rs

(define (square x)
  (* x x))

(define false #f)
(define true #t)

(define (runtime)
  (current-milliseconds))
