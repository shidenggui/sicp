#lang sicp


; The Recursion Process
; (define (factorial n)
;   (if (= n 1)
;       n
;       (* n (factorial (- n 1)))))

; The Iterative Process
(define (factorial n)
    (define (iter prod cnt)
        (if (> cnt n)
            prod
            (iter (* prod cnt) (+ cnt 1))))
    (iter 1 1))

(factorial 3)

