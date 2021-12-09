#lang sicp

(define (coin-change amount)
  (define (value coin-type)
    (cond ((= 1 coin-type) 1)
          ((= 2 coin-type) 5)
          ((= 3 coin-type) 10)
          ((= 4 coin-type) 25)
          ((= 5 coin-type) 50)))

  (define (cc amount coin-types)
    (cond ((= 0 amount) 1)
          ((or (< amount 0) (= 0 coin-types)) 0)
          (else (+
                 (cc (- amount (value coin-types)) coin-types)
                     (cc amount (- coin-types 1))))))

  (cc amount 5))

  (coin-change 100)
