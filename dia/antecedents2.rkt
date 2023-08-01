#lang racket

(provide (rename-out [mb #%module-begin]) #%datum #%top #%top-interaction #%app)

#| (Unstable) Module language for antecedents

Format:
  #lang abe/antecedents2 exported-antecedents-id [ideas-module imported-ideas-id]

  - antecedents tree [antecedents]

Meaning:

- The body is an "antecedents" tree of roughly the same shape where the leaves
have comma-separated antecedents in place of percentages.
- Attribute antecedents by combining them with imported-ideas-id from
ideas-module, which records the idea appraisals (see #lang abe/ideas2).
- Export (provide) the exported-antecedents-id bound to the final attributions.

|#

(require syntax/parse/define
         abe/dia)

(define-syntax-parse-rule
  (mb export:id {~datum <=} [ideas-mod:expr imported-ideas:id] {~datum <=} tree-data:expr)
  (#%module-begin
   (provide export)
   (require (only-in ideas-mod imported-ideas))
   (define antes 'tree-data)
   (define export (make-hash))
   (attribute-antecedents imported-ideas antes export)
   (unless (validate-attributions export)
     (error 'validate-attributions "bad attributions: ~a" export))))

(module reader syntax/module-reader abe/antecedents2
  #:whole-body-readers? #t
  #:read reader
  #:read-syntax syntax-reader

  (require racket/match
           syntax/strip-context
           abe/tree-parser)

  (define (syntax-reader src in)
    (port-count-lines! in)
    (define name (read-syntax src in))
    (unless (symbol? (syntax-e name))
      (raise (exn:fail:read
              (format "expected identifier\n  read: ~s" name)
              (current-continuation-marks)
              (list (srcloc src (syntax-line name) (syntax-column name) (syntax-position name) (syntax-span name))))))
    (define import (read-syntax src in))
    (match (syntax->datum import)
      [(list (not (? keyword?)) (? symbol?)) (void)]
      [_ (raise (exn:fail:read
                    (format "expected [module identifier]\n  read: ~s" import)
                    (current-continuation-marks)
                    (list (srcloc src (syntax-line name) (syntax-column name) (syntax-position name) (syntax-span name)))))])
    (define tree (read-idea-antecedents-tree in))
    (strip-context #`(#,name <= #,import <= #,tree)))
  (define (reader in)
    (syntax->datum (syntax-reader #f in))))
