#lang sicp

; The Recursion Process
; (define (f n)
;   (if (< n 3)
;       n
;       (+
;        (f (- n 1))
;        (* 2 (f (- n 2)))
;        (* 3 (f (- n 3))))))

; The Iterative Process
(define (f n)
  (define (iter a0 a1 a2 n)
    (if (= n 0)
        a0
        (iter (+ a0
               (* 2 a1)
               (* 3 a2))
               a0
               a1
              (- n 1))))

  (if (< n 3)
      n
      (iter 2 1 0 (- n 2))))

