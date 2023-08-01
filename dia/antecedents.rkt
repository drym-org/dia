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

|#

(require syntax/parse/define
         (for-syntax syntax/path-spec
                     racket/path)
         abe/dia
         abe/tree-parser)

(define-syntax-parse-rule
  (mb [ideas:string antecedents:string] {~datum =>} export:id)
  #:with ideas-p (some-system-path->string (resolve-path-spec #'ideas #'ideas #'[ideas antecedents]))
  #:with antecedents-p (some-system-path->string (resolve-path-spec #'antecedents #'antecedents #'[ideas antecedents]))
  (#%module-begin
   (provide export)
   ;; unless path-strings quoted, #%datum unbound error (not sure why not automatically introduced)
   (define tree (call-with-input-file 'ideas-p read-idea-attribution-tree))
   (define antes (call-with-input-file 'antecedents-p read-idea-antecedents-tree))
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
