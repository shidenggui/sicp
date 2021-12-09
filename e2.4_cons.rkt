#lang sicp
(define (cons x y)
    (lambda (f) (f x y)))

(define (car z)
    (z (lambda (x y) x)))
(define (cdr z)
    (z (lambda (x y) y)))

; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))

(define z (cons 0 1))
(pass (= (car z) 0))
(pass (= (cdr z) 1))