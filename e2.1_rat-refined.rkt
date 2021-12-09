#lang sicp

(define (gcd m n)
  (cond ((> n m) (gcd n m))
        ((= n 0) m)
        (else (gcd n (remainder m n)))))
(define (abs x)
  (if (< x 0)
      (* x -1)
      x))

(define (make-rat n d)
  (cond ((and (< n 0) (< d 0)) (make-rat (* -1 n) (* -1 d)))
        ((< d 0) (make-rat (* -1 n) (* -1 d)))
        (else (let ((g (gcd (abs n) d)))
                (cons (/ n g) (/ d g)))))
  )
(define (numer x) (car x))
(define (denom x) (cdr x))

(define (print-rat x)
  (display (numer x))
  (display "/")
  (display (denom x))
  (newline)
  )
(define (add-rat x y) (make-rat (+ (* (numer x) (denom y)) (* (numer y) (denom x))) (* (denom x) (denom y))))
(define (sub-rat x y) (make-rat (- (* (numer x) (denom y)) (* (numer y) (denom x))) (* (denom x) (denom y))))
(define (mul-rat x y) (make-rat (* (numer x) (numer y)) (* (denom x) (denom y))))
(define (div-rat x y) (make-rat (* (numer x) (denom y)) (* (denom x) (numer y))))
(define (equal-rat? x y) (= (* (numer x) (denom y)) (* (numer y) (denom x))))

(define one-half (make-rat 1 2))
(define one-third (make-rat 1 3))

(print-rat (make-rat -1 -2))
(print-rat (make-rat -1 2))
(print-rat (make-rat 1 -2))

(print-rat (add-rat one-half one-half))
(print-rat (add-rat one-half one-third))
(print-rat (mul-rat one-half one-third))
(print-rat (div-rat one-half one-third))
(print-rat (sub-rat one-half one-third))
(display (equal-rat? one-half one-third))


; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))
