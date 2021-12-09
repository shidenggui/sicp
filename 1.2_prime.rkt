#lang sicp

; (define (prime? n)
;   (define (iter d)
;     (cond ((> (* d d) n) #t)
;           ((= 0 (remainder n d)) #f)
;           (else (iter (+ d 1)))))
;   (iter 2))

(define (square x) (* x x))
(define (even? x) (= (remainder x 2) 0))

; (xy) % m = (x % m)(y % m) % m
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp) (remainder
                      (square (expmod base (/ exp 2) m))
                      m))
        (else (remainder
               (* base (expmod base (- exp 1) m))
               m))))

(define (fast-prime? n times)
  (define (random-choice)
    (+ (random (- n 1)) 1))
  (define (fermat-test a)
    (= a (expmod a n n)))
  (cond ((= 0 times) #t)
        ((not (fermat-test (random-choice))) #f)
        (else (fast-prime? n (- times 1)))))

; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))

(pass (fast-prime? 2 5))
(pass (fast-prime? 3 5))
(pass (fast-prime? 4 5))
(pass (fast-prime? 5 5))
(pass (fast-prime? 6 5))
(pass (fast-prime? 7 5))
(pass (fast-prime? 8 5))
(pass (fast-prime? 561 5))