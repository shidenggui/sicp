#lang sicp
; The operations of the Connector
; • (has-value? ⟨connector⟩) tells whether the connector has a value.
; • (get-value ⟨connector⟩) returns the connector’s current value.
; • (set-value! ⟨connector⟩ ⟨new-value⟩ ⟨informant⟩) indicates that the informant is requesting the connector to set its value to the new value.
; • (forget-value! ⟨connector⟩ ⟨retractor⟩) tells the connector that the retractor is requesting it to forget its value.
; • (connect ⟨connector⟩ ⟨new-constraint⟩) tells the connector to participate in the new constraint
(define (for-each-except exception procedure list)
  (define (loop items)
    (cond ((null? items) 'done)
          ((eq? (car items) exception) (loop (cdr items)))
          (else (procedure (car items)) (loop (cdr items)))))
  (loop list))

(define (has-value? connector)
  (connector 'has-value?))
(define (get-value connector)
  (connector 'value))
(define (set-value! connector new-value informant)
  ((connector 'set-value!) new-value informant))
(define (forget-value! connector retractor)
  ((connector 'forget) retractor))
(define (connect connector new-constraint)
  ((connector 'connect) new-constraint))

(define (inform-about-value constraint)
  (constraint 'I-have-a-value))
(define (inform-about-no-value constraint)
  (constraint 'I-lost-my-value))

(define (make-connector)
  (let ((value false) (informant false) (constraints '()))
    (define (set-my-value newval setter)
      (cond ((not (has-value? me))
             (set! value newval)
             (set! informant setter)
             (for-each-except setter
                              inform-about-value
                              constraints))

            ((not (= value newval))
             (error "Contradiction" (list value newval)))
            (else 'ignored)))
    (define (forget-my-value retractor)
      (if (eq? retractor informant)
          (begin (set! informant false)
                 (for-each-except retractor
                                  inform-about-no-value
                                  constraints))
          'ignored))
    (define (connect new-constraint)
      (if (not (memq new-constraint constraints))
          (set! constraints
                (cons new-constraint constraints)))
      (if (has-value? me)
          (inform-about-value new-constraint))
      'done)
    (define (me request)
      (cond
        ((eq? request 'has-value?)
         (if informant true false))
        ((eq? request 'value) value)
        ((eq? request 'set-value!) set-my-value)
        ((eq? request 'forget) forget-my-value)
        ((eq? request 'connect) connect)
        (else (error "Unknown operation: CONNECTOR" request))))
    me))

(define (averager a1 a2 avg)
  (define (process-new-value)
    (cond
      ((and (has-value? a1) (has-value? a2))
       (set-value! avg
                   ( /
                     (+ (get-value a1) (get-value a2))
                     2)
                   me))
      ((and (has-value? a1) (has-value? avg))
       (set-value! a2
                   (- (* (get-value avg) 2) (get-value a1))
                   me))
      ((and (has-value? a2) (has-value? avg))
       (set-value! a1
                   (- (* (get-value avg) 2) (get-value a2))
                   me))))
  (define (process-forget-value)
    (forget-value! avg me)
    (forget-value! a1 me)
    (forget-value! a2 me)
    (process-new-value))
  (define (me request)
    (cond ((eq? request 'I-have-a-value) (process-new-value))
          ((eq? request 'I-lost-my-value) (process-forget-value))
          (else (error "Unkonwn request: AVERAGER" request))))
  (connect a1 me)
  (connect a2 me)
  (connect avg me)
  me)
(define (constant value connector)
  (define (me request)
    (error "Unknown request: CONSTANT" request))
  (connect connector me)
  (set-value! connector value me)
  me)

(define (probe name connector)
  (define (print-probe value)
    (display "Probe: ") (display name)
    (display " = ") (display value) (newline))
  (define (process-new-value)
    (print-probe (get-value connector)))
  (define (process-forget-value) (print-probe "?"))
  (define (me request) (cond ((eq? request 'I-have-a-value) (process-new-value))
                             ((eq? request 'I-lost-my-value) (process-forget-value)) (else (error "Unknown request: PROBE" request))))
  (connect connector me)
  me)



(define a (make-connector))
(define b (make-connector))
(define avg (make-connector))
(averager a b avg)
(set-value! a 4 "user")
(set-value! b 8 "user")
(display (get-value avg))
(newline)
(forget-value! a "user")
(set-value! avg 20 "user")
(display (get-value a))
(newline)