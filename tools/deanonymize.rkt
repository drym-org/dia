#! /usr/bin/env racket
#lang rash

#| Overview

Assumes a very specific project structure. See adjacent Makefile example for
details on "input" files and "output" files. Also assumes its placement in the
project (next to the output files).

*nix specifics: you'll need implementations of POSIX paste(1), column(1), and
POSIX sed(1). The column(1) implementation should support `-t` and `-s`.

1. Build lookup tables from the anonymized and named files. Uses paste(1) to
   pair up lines and column(1) to separate them for post-processing.
2. Generate sed(1) code from the lookup tables. N.B. This implies that
   anonymized lines must be distinct, since they are effectively "keys."
3. If given --execute, run the sed(1) code on the input files to generate
   deanonymized output files.

If you commit the sed(1) code, too, you ensure that Racket is not needed to
regenerate the deanonymized files. In practice you would want Racket to generate
the sed(1) code anyway.

Rash tips: lines that don't start with parens are rash commands. Almost sh-like,
but different. If you don't do anything too complicated, it'll probably work the
way you think… but redirection operators are not normal! Inside parens, use {}
to escape to Rash, or #{} to escape to Rash and capture the output, like $()
in a shell. Use () to escape back to Racket, although variables can be accessed
by $racket-variable or $ENVIRONMENT_VARIABLE.

|#

(require racket
         racket/runtime-path
         qi)

(define-runtime-path here ".")
(define evaluation (build-path here 'up 'up))
(define inputs (build-path evaluation 'up "input"))
(define appraisals (build-path evaluation "appraisal"))
(define-flow input (build-path inputs __))
(define-flow appraisal (build-path appraisals __))
(define-flow output (build-path here __))
(define-flow sed (~> (string-append ".sed") (build-path here __)))

(define anon->actual
  (hash "capital-anonymized.md" "capital.md"
        "labor-anonymized.md" "labor.md"))

(define (make-lookup anon actual)
  (define anon-actual-table
    #{paste $anon $actual | column -ts'* |> port->lines})
  (for/hash ([line anon-actual-table])
    (~> (line) (string-split "\t") (sep string-trim))))

(define (lookup->sed lookup)
  ;; sed uses BREs by default (man re_format). With a pattern separator of /,
  ;; the only interesting metacharacters are /, \, ^ at the beginning of the
  ;; pattern, and $ at the end of the pattern. The careful reader will note
  ;; that, in the BRE \(^foo\), ^ is also a metacharacter; because we already
  ;; escape the \( and \) metacharacters, there is no need to adjust this ^.
  ;; More generally, escaping all \s escapes most of the unenhanced BRE
  ;; metacharacters.
  (define-flow sed-escape
    ;; double-escaped replacements to quote the backslashes, not the following
    ;; replacement characters.
    (regexp-replaces '([#rx"[/\\]" "\\\\&"]
                       [#rx"^\\^" "\\\\^"]
                       [#rx"\\$$" "\\\\$"])))
  (string-join
    (for/list ([(anon actual) lookup])
      (format "s/~a/~a/" (sed-escape anon) (sed-escape actual)))
    "\n"))

(define execute? (make-parameter #f))
(command-line
  #:usage-help
  "Generate deanonymization scripts."
  "When enabled, execute deanonymization scripts."
  #:once-each
  [("--execute") "execute deanonmyization" (execute? #t)]
  #:args ()
  (void))

(for ([(anon actual) anon->actual])
  (define lookup (make-lookup (input anon) (input actual)))
  {
    echo (lookup->sed lookup) &>! (sed actual)
  })

(when (execute?)
  {
    (for ([actual (in-hash-values anon->actual)])
      { sed -f (sed actual) (appraisal actual) &>! (output actual) })
  })
