#lang sicp

(define (make-withdraw balance)
  (lambda (amount)
    (if (> balance amount)
        (begin
          (set! balance (- balance amount))
          balance)
        "Insufficient funds")))

(define (make-account balance)
  (define (withdraw amount)
    (if (> balance amount)
        (begin
          (set! balance (- balance amount))
          balance)
        "Insufficient funds"))
  (define (deposit amount)
    (begin
      (set! balance (+ balance amount))
      balance))
  (define (dispatch op)
    (cond ((eq? op 'withdraw) withdraw)
          ((eq? op 'deposit) deposit)
          (else (error "UNKONW OP: MAKE-ACCOUNT"))))
  dispatch)
(display "Open a new account")
(newline)
(define withdraw (make-withdraw 100))
(display (withdraw 5))
(newline)
(display (withdraw 100))
(newline)

(define w1 (make-account 100))
(display ((w1 'withdraw) 10))
(newline)
(display ((w1 'deposit) 1000))
(newline)