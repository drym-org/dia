#lang racket

(provide bump
         tally
         validate-attributions
         validate-appraisal
         incorporate-appraisal
         attribute-antecedents
         node-name
         node-weight)

(require relation
         qi)

(define-flow leaf?
  (~> rest empty?))

(define node-name car)

(define node-weight cdr)

(define (bump name delta-coefficients #:results results)
  (let ([current (hash-ref results name 0)]
        [delta (* 100 (apply * (map (☯ (/ 100)) delta-coefficients)))])
    (hash-set! results name (+ current delta))))

(define (tally t observe reduce #:results results)
  (let go ([t t]
           [work null])
    (let* ([n (first t)]
           [name (node-name n)]
           [work (cons (observe n) work)])
      (if (leaf? t)
          (reduce name work #:results results)
          (for-each (☯ (go work))
                    (rest t))))))

(define (validate-attributions attributions)
  (~> (attributions) hash-values △ + (= 100)))

(define (validate-appraisal tree)
  ;; check that everything totals to 1
  (let ([attributions (make-hash)])
    (tally tree
           node-weight
           bump
           #:results attributions)
    (validate-attributions attributions)))

(define (incorporate-appraisal appraisal wt result)
  (for-each (λ (i)
              (match-let ([(cons k v) i])
                (let ([cur (hash-ref result k 0)])
                  (hash-set! result k (+ cur (* v wt))))))
            (hash->list appraisal)))

(define (attribute-antecedents ideas-attributions antecedents result)
  (for ([(k v) (in-hash ideas-attributions)])
    (let* ([ants (hash-ref antecedents k)]
           [n (length ants)])
      (for ([ka ants])
        (let ([cur (hash-ref result ka 0)])
          (hash-set! result ka (+ cur (/ v n))))))))
