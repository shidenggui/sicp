#lang sicp

(define (fib n)
  (define (fib-iter n cur nxt)
    (if (= n 0)
        cur
        (fib-iter (- n 1) nxt (+ cur nxt))
        ))
  (fib-iter n 0 1))

(define (fib2 n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib2 (- n 1)) (fib2 (- n 2))))))

(fib 10)

