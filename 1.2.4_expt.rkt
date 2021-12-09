#lang sicp

; The Recursion Process
; (define (expt b n)
;     (if (= n 0)
;         1
;         (* b (expt b (- n 1)))))

; The Iterative Process
; (define (expt b n)
;     (define (iter prod cnt)
;         (if (= 0 cnt)
;             prod
;             (iter (* prod b) (- cnt 1))))
;     (iter 1 n))

; The Improved Recursion Process
; (define (expt b n)
;   (cond ((= n 0) 1)
;         ((= (remainder n 2) 0) (expt (* b b) (/ n 2)))
;         (else (* b (expt b (- n 1))))))

; The Improved Iterative Process
(define (expt b n)
    (define (iter B N A)
        (cond ((= 0 N) A)
            ((= (remainder N 2) 0) (iter (* B B) (/ N 2) A))
            (else (iter B (- N 1) (* B A)))))
    (iter b n 1))


; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))

(pass (= 1 (expt 0 0)))
(pass (= 1 (expt 1 0)))
(pass (= 0 (expt 0 1)))
(pass (= 8 (expt 2 3)))
(pass (= 9 (expt 3 2)))
(pass (= 81 (expt 3 4)))
