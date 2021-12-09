#lang sicp

(define (fixed-point f)
  (define tolerance 0.0001)
  (define (iter guess)
    (let ((new-guess (f guess)))
      (if (< (abs (- guess new-guess)) tolerance)
          new-guess
          (iter new-guess))))
  (iter 1.0))

(define (average-damp f)
  (lambda (x) (/
               (+ x (f x))
               2)))

(define (sqrt x)
  (fixed-point
   (average-damp
    (lambda (y) (/ x y)))))

; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))
(display (fixed-point cos))
(display (sqrt 25))
