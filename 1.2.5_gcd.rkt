#lang sicp

(define (gcd m n)
    (if (= 0 n)
        m
        (gcd n (remainder m n))))

; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))

(pass (= 5 (gcd 5 0)))
(pass (= 7 (gcd 21 14)))