#lang sicp

(define (list-ref items n)
    (if (= n 0)
        (car items)
        (list-ref (cdr items) (- n 1))))

(define (length items)
    (if (null? items)
        0
        (+ 1 (length (cdr items)))))

(define (length-iter items)
    (define (iter items count)
        (if (null? items)
            count
            (iter (cdr items) (+ count 1))))
    (iter items 0))

(define (append list1 list2)
    (if (null? list1)
        list2
        (cons (car list1) (append (cdr list1) list2))))

(define (last-pair items)
    (if (null? (cdr items))
        items
        (last-pair (cdr items))))
; test cases
(define (pass f)
  (if f
      (display "Pass\n")
      (display "Failed\n")))

(define items (list 0 1 2 3))
(pass (= 0 (list-ref items 0)))
(pass (= 1 (list-ref items 1)))
(pass (= 2 (list-ref items 2)))
(pass (= 3 (list-ref items 3)))
(pass (= 4 (length items )))
(pass (= 4 (length-iter items )))
(define merged (append (list 1 2 3) (list 4 5 6)))
(last-pair items)
