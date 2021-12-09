#lang sicp


(define (variable? exp)
  (symbol? exp))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))
(define (=number? v1 v2)
  (if (and (number? v1) (number? v2))
      (= v1 v2)
      #f))
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m2 1) m1)
        ((=number? m1 1) m2)
        ((and (number? m1)  (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))
(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        (list '** base exponent)))

(define (sum? exp)
  (and (pair? exp) (eq? (car exp) '+)))
(define (addend exp)
  (cadr exp))
(define (augend exp)
  (caddr exp))

(define (product? exp)
  (and (pair? exp) (eq? (car exp) '*)))
(define (multiplier exp)
  (cadr exp))
(define (multiplicand exp)
  (caddr exp))

(define (exponentiation? exp)
  (and (pair? exp) (eq? (car exp) '**)))
(define (base exp)
  (cadr exp))
(define (exponent exp)
  (caddr exp))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp) (make-sum
                     (deriv (addend exp) var)
                     (deriv (augend exp) var)))
        ((exponentiation? exp) (make-product
                                (make-product
                                 (base exp)
                                 (make-exponentiation (base exp) (- (exponent exp) 1)))
                                (deriv (base exp) var)))
        ((product? exp) (make-sum
                         (make-product (multiplier exp) (deriv (multiplicand exp) var))
                         (make-product (deriv (multiplier exp) var) (multiplicand exp))))
        (else (error "unknown expression type: DERIV" exp))))


; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))

(deriv '(+ x 3) 'x)
(deriv '(+ (* 2 x) 3) 'x)
(deriv '(+ (* (* x x) (* 2 y)) 3) 'x)
(deriv '(** x 3) 'x)