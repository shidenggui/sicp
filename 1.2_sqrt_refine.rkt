#lang sicp


; (define (sqrt x)
;   (define (improve guess x)
;     (/
;      (+
;       (/ x guess)
;       guess) 2))
;   (define (good-enough? guess x)
;     (= (improve guess x) guess))
;   (define (sqrt-iter guess x)
;     (if (good-enough? guess x)
;         guess
;         (sqrt-iter (improve guess x) x)))
;   (sqrt-iter 1.0 x))
(define (sqrt x)
  (define (improve guess)
    (/
     (+
      (/ x guess)
      guess) 2))
  (define (good-enough? guess)
    (= (improve guess) guess))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))


(sqrt 16)