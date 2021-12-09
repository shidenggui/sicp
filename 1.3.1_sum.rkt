#lang sicp

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a) (sum term (next a) next b))))

(define (sum-iter term a next b)
    (define (iter a result)
        (if (> a b) 
            result
            (iter (next a) (+ result (term a)))))
            
    (iter a 0))

; (define (sum-add a b)
;     (sum (lambda (x) x) a (lambda (x) (inc x)) b))
(define (sum-add a b)
    (sum-iter (lambda (x) x) a (lambda (x) (inc x)) b))

; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))

(pass (= 3 (sum-add 1 2)))
(pass (= 6 (sum-add 1 3)))