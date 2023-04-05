#lang racket

(provide (rename-out [mb #%module-begin]) #%datum #%top #%top-interaction #%app)

#| Module language for antecedents

Format:
  #lang abe/antecedents
  ["path/to/ideas-appraisal.md" "path/to/antecedents.md"] => exported-attributions-id

Meaning:

- The ideas path is an "appraisal" tree. Roughly, markdown bulleted list in tree
form, with bracketed percentags [N%] at the end of the line. The antecedents
path is an "antecedents" tree of roughly the same shape where the leaves have
comma-separated antecedents in place of percentages.
- Validate appraisals.
- Tally antecedents attributions.
- Validate attributions.
- Export (provide) the exported-attributions-id bound to the attributions.

Technically, the shape of the antecedents tree doesn't matter, as long as the
leaves have antecedents. But this has only been tested on antecedents trees.

Future work: try swapping define-runtime-path for syntax/path-spec's
resolve-path-spec.

|#

(require racket/runtime-path
         syntax/parse/define
         abe/dia
         abe/tree-parser)

(define-syntax-parse-rule
  (mb [ideas:string antecedents:string] {~datum =>} export:id)
  ;; Make sure runtime-path resolved like a require: from context of written
  ;; module, not this module. Also, we have to wrap path in #%datum manually or
  ;; suffer a "#%datum not bound in the transformer environment" error.
  #:with runtime-path-define-ideas
  (datum->syntax #'ideas (syntax-e #'(define-runtime-path ideas-p (#%datum . ideas))) #'ideas)
  #:with runtime-path-define-antecdents
  (datum->syntax #'antecedents (syntax-e #'(define-runtime-path antecdents-p (#%datum . antecedents))) #'antecedents)
  (#%module-begin
   (provide export)
   runtime-path-define-ideas
   runtime-path-define-antecdents
   (define tree (read-idea-attribution-tree ideas-p))
   (define antes (read-idea-antecedents-tree antecdents-p))
   (unless (validate-appraisal tree)
     (error 'validate-appraisal "bad appraisal: ~a" tree))
   (define export (make-hash))
   (define aux (make-hash))
   (tally tree node-weight bump #:results aux)
   (unless (validate-attributions aux)
     (error 'validate-attributions "bad attributions: ~a" aux))
   (attribute-antecedents aux antes export)
   (unless (validate-attributions export)
     (error 'validate-attributions "bad attributions: ~a" export))))

(module reader syntax/module-reader abe/antecedents)
