#lang racket

(provide (rename-out [mb #%module-begin]) #%datum #%top #%top-interaction #%app)

#| Module language for attributions

Format:
  #lang abe/attributions
  "path/to/capital-or-labor-appraisal.md" => exported-attributions-id

Meaning:

- The path is an "appraisal" tree. Roughly, markdown bulleted list in tree form,
with bracketed percentags [N%] at the end of the line.
- Validate appraisals.
- Tally attributions.
- Validate attributions.
- Export (provide) the exported-attributions-id bound to the attributions.

To identify attributions, the first sequence of non-space characters after a
bullet is used. For capital, this means that descriptive bullets without a
project name should be given a faux project name.

Additionally, a sequence of non-space characters followed by the text " and "
and another sequence of non-space characters is considered an attributive "pair"
and is attributed as a single unit, to account for teamwork. Groups of sizes
larger than 2 are not yet supported.

|#

(require syntax/parse/define
         (for-syntax syntax/path-spec
                     racket/path)
         abe/dia
         abe/tree-parser)

(define-syntax-parse-rule
  (mb path:string {~datum =>} export:id)
  #:with input (some-system-path->string (resolve-path-spec #'path #'path #'path))
  (#%module-begin
   (provide export)
   ;; unless path-strings quoted, #%datum unbound error (not sure why not automatically introduced)
   (define tree (read-attribution-tree 'input))
   (unless (validate-appraisal tree)
     (error 'validate-appraisal "bad appraisal: ~a" tree))
   (define export (make-hash))
   (tally tree node-weight bump #:results export)
   (unless (validate-attributions export)
     (error 'validate-attributions "bad attributions: ~a" export))))

(module reader syntax/module-reader abe/attribution)
