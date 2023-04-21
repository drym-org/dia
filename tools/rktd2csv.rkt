#!/usr/bin/env racket
#lang cli

(require csv-writing
         qi
         relation)

(define (read-rktd filename)
  (call-with-input-file filename
    (λ (port)
      ;; the input is a list of conses
      ;; but we need a "table" which is
      ;; a list of lists
      (map (☯ (~> (-< (~> car ->string) cdr)
                  list))
           ;; the value is read as `(quote ...)` as we use `pretty-print`,
           ;; so extract the quoted list here via `cadr`
           (cadr (read port))))))

(define (write-csv data [headers #f])
  (let ([data (if headers
                  (cons headers data)
                  data)])
    (display-table data)))

(program (main [rktd-filename "The RKTD file (e.g. an attributions file that is the output of DIA)."])
  (write-csv (read-rktd rktd-filename)))

(run main)
