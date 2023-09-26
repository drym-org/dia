#lang racket

;; Run with `racket compare-anonymous-appraisal.rkt`
;; or `racket -l- abe/compare-anonymous-appraisal`

(require "tree-parser.rkt")

(define (get-tree ip)
  (when (regexp-match-peek #rx"#lang" ip)
    (read-line ip 'any))
  (read-anonymous-attribution-tree2 ip))

(define (make-rows trees)
  (let ([trees (map flatten trees)])
    (reverse
     (let loop ([result '()]
                [trees trees])
       (match trees
         [(list '() ...) result]
         [(list (cons (? string? x) rest) ...)
          #:when (apply equal? x)
          (loop (cons (list (car x)) result)
                rest)]
         [(list (cons (? number? n) rest) ...)
          (loop (cons (append (car result) n)
                      (cdr result))
                rest)])))))

(define (make-table headers trees)
  (cons headers (make-rows trees)))

(module+ main
  (require csv-writing)
  (command-line
   #:usage-help
   ""
   "Compares anonymous appraisals in <files>."
   "Outputs CSV, one row per appraisal item."
   ""
   "All <files> should be in either #lang abe/attribution2"
   "or #lang abe/ideas2 format and should have the same items"
   "in the same order."
   ""
   "Example:"
   "    compare-anonymous-appraisal /path/to/appraisals/*/capital.md"
   #:args files
   (display-table
    (make-table (cons "Item" files)
                (map (λ (f) (call-with-input-file f get-tree))
                     files)))))
