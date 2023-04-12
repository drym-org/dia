#lang racket

#| TEMPLATE ATTRIBUTION SCRIPT

This script performs attribution based on the subsidiary attributions in
capital.rkt, labor.rkt, and ideas.rkt. It reconciles the various attributions,
validates the result, and dumps it to stdout.

See the example Makefile for usage instructions.

Place this script with other attribution files, like the subsidiary
attribution scripts and, possibly, outputs.

|#

(require abe/dia
         qi
         "capital.rkt"
         "labor.rkt"
         "ideas.rkt")

(define attributions (make-hash))

(define N 3)

(reconcile-appraisals N
                      labor-attributions
                      capital-attributions
                      antecedents-attributions
                      attributions)

(unless (validate-attributions attributions)
  (error 'validate-attributions "bad attributions: ~a" attributions))

(define-flow round-attribution
  (~>> (~r #:precision '(= 2)) string->number))

(~> (attributions)
    (hash-map/copy (flow (== _ round-attribution)))
    hash->list
    (sort > #:key cdr)
    pretty-print)
