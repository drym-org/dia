#lang racket

(provide (rename-out [mb #%module-begin]) #%datum #%top #%top-interaction #%app)

#| (Unstable) Module language for attributions

Format:
  #lang abe/attribution2 exported-attributions-id

  - [contributors] Appraisal tree [N%]
  ...

Meaning:

- The body is an "appraisal" tree. Roughly, markdown bulleted list in tree form,
with bracketed percentags [N%] at the end of the line.
- Validate appraisals.
- Tally attributions.
- Validate attributions.
- Export (provide) the exported-attributions-id bound to the attributions.

To identify attributions, contributors are listed, comma-separated, in
[square-brackets] at the beginning of a bullet. This holds for labor, too, to
name the project but permit additional description.

|#

(require syntax/parse/define
         abe/dia)

(define-syntax-parse-rule
  (mb export:id {~datum <=} tree-data:expr)
  (#%module-begin
   (provide export)
   (define tree 'tree-data)
   (unless (validate-appraisal tree)
     (error 'validate-appraisal "bad appraisal: ~a" tree))
   (define export (make-hash))
   (tally tree node-weight bump #:results export)
   (unless (validate-attributions export)
     (error 'validate-attributions "bad attributions: ~a" export))))

(module reader syntax/module-reader abe/attribution2
  #:whole-body-readers? #t
  #:read reader
  #:read-syntax syntax-reader

  (require syntax/strip-context
           abe/tree-parser)

  (define (syntax-reader src in)
    (port-count-lines! in)
    (define name (read-syntax src in))
    (unless (symbol? (syntax-e name))
      (raise (exn:fail:read
              (format "expected identifier\n  read: ~s" name)
              (current-continuation-marks)
              (list (srcloc src (syntax-line name) (syntax-column name) (syntax-position name) (syntax-span name))))))
    (define tree (read-attribution-tree2 in))
    (strip-context #`(#,name <= #,tree)))
  (define (reader in)
    (syntax->datum (syntax-reader #f in))))
