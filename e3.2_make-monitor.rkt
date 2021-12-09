#lang sicp

(define (make-monitor proc)
  (let ((calls 0))
    (define (dispatch . args)
      (cond
        ((eq? (car args) 'how-many-calls)
         (set! calls (+ calls 1))
         calls)
        (else (apply proc args))))
    dispatch))

(define mf (make-monitor sqrt))
(display (mf 100))
(newline)
(display (mf 'how-many-calls))
(newline)
(display (mf 144))
(newline)
(display (mf 'how-many-calls))
(newline)