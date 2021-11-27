#lang sicp
(define (avg x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (/ (+
      (/ x guess)
      guess) 2)
  )

(define (square x) (* x x))

(define (abs x)
  (if (> x 0) x (- x))
  )

(define (good-enough? guess x)
  (= (improve guess x) guess)
  )

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause))
  )

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)
      ))

(define (sqrt x) (sqrt-iter 1.0 x))

(sqrt 9.0)