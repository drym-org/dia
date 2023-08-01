#lang racket

(provide read-attribution-tree
         read-attribution-tree2
         read-idea-attribution-tree
         read-idea-antecedents-tree)

#| TREE PARSING UTILITIES

Textual tree formats described in attribution.rkt, antecedents.rkt next to this
file.

The exported functions receive a filepath, convert it to lines, and parse the
corresponding kind of tree.

|#

(require racket/hash
         qi)

;; If this is not defined with function syntax, inner implementation functions
;; unbound because they are eagerly evaluated.
(define-flow (read-attribution-tree ip)
  (~> port->lines
      (filter non-empty-string? _)
      (make-indent-based-tree (flow (regexp-replace* #px"[[:blank:]]" _ " ")))
      (tree-map label->attribution leaf->attribution)))

(define-flow (read-attribution-tree2 ip)
  (~> port->lines
      (filter non-empty-string? _)
      (make-indent-based-tree (flow (regexp-replace* #px"[[:blank:]]" _ " ")))
      (tree-map label->attribution leaf->attribution2)))

(define-flow (read-idea-attribution-tree ip)
  (~> port->lines
      (filter non-empty-string? _)
      (make-indent-based-tree (flow (regexp-replace* #px"[[:blank:]]" _ " ")))
      (tree-map label->attribution label->attribution)))

(define-flow (read-idea-antecedents-tree ip)
  (~> port->lines
      (filter non-empty-string? _)
      (make-indent-based-tree (flow (regexp-replace* #px"[[:blank:]]" _ " ")))
      (tree-map values leaf->antecedents)
      (leaves->hash car cdr)))

#| Implementation notes

Done by recursive process. An iterative solution is desired if it is performant
and equally readable. Otherwise, this is the best way to understand the process
as it stands:

When the indentation doesn't change from line to line, the current line is a
child of the current tree. Thus we cons it on to the tree built from the rest of
the lines.

When the indent increases, we are starting a new subtree. We bundle the
remaining lines at this new indentation (make-groups-at), and make trees out of
each bundle. These subtrees are then collected into a final tree.

Further improvement: consider using a Markdown parser (require markdown) and
processing the resultant structure?

|#

(define (make-indent-based-tree lines [on-line values])
  (define by-indent
    (for/list ([line lines])
      (match-define (regexp #px"^(\\s*)" (list _ (app string-length indent))) line)
      (cons indent (on-line line))))
  (match by-indent
    ['() '()]
    [(cons (cons ind _) _)
     (let make-tree ([indents by-indent]
                     [prev-indent ind])
       (match indents
         ['() '()]
         [(cons (cons ind line) indents)
          (cond
            [(= ind prev-indent)
             (cons line (make-tree indents prev-indent))]
            [(> ind prev-indent)
             (map (flow (make-tree ind))
                  (make-groups-at ind (cons (cons ind line) indents)))]
            ;; all smaller have already been handled, so this would be a bug
            ;; or bad input: say, the first line is indented and the next is not
            [(< ind prev-indent)
             (error 'make-tree "smaller indent: ~a < ~a in ~a" ind prev-indent indents)])]))]))

#| Example:

(make-groups-at 1 '((1 . a) (1 . b) (2 . c) (2 . d) (1 . e) (2 . f) (3 . g)))
=>
'(((1 . a))
  ((1 . b) (2 . c) (2 . d))
  ((1 . e) (2 . f) (3 . g)))

|#
(define (make-groups-at n xs)
  (let loop ([acc null]
             [xs xs])
    (match xs
      ['() (reverse acc)]
      [(cons x xs)
       (define-values (group rest)
         (split-at xs (or (index-where xs (flow (~> car (= n))))
                          (length xs))))
       (loop (cons (cons x group) acc)
             rest)])))

#| Parsing leafs and labels.

See adjacent module languages attribution.rkt, antecedents.rkt for more details
on format.

|#

(define (leaf->attribution x)
  (match x
    [(regexp #px"^\\s*\\* ([^ ]+)(?:\\s+and\\s+([^ ]+))?.*\\[([[:digit:].]+)%\\]"
             (list _ name1 name2 (app string->number attribution)))
     (cons (if name2 (list name1 name2) name1)
           attribution)]))

(define (leaf->attribution2 x)
  (match x
    ;; uniform contribution syntax (https://github.com/drym-org/dia/issues/5):
    ;;     * [comma-separated contributors] contribution [allocation%]
    ;; Arbitrary spaces are permitted between start of line and start of
    ;; bulleted item.
    [(regexp #px"^\\s*\\* \\[([^]]+)\\].*\\[([[:digit:].]+)%\\]"
             (list _ contributors (app string->number attribution)))
     (cons (~> (contributors)
               (string-split ", ")
               (if (~> cdr null?) car _))
           attribution)]))

(define (label->attribution x)
  (match x
    [(regexp #px"^\\s*\\* (.*) \\[([[:digit:].]+)%\\]"
             (list _ thing (app string->number attribution)))
     (cons thing attribution)]))

(define (leaf->antecedents x)
  (match x
    [(regexp #px"^\\s*\\* (.*) \\[(.*)\\]" (list _ idea antecedents))
     (cons idea (string-split antecedents ", "))]))

(define (leaves->hash t k v)
  (tree-fold t (hash) (flow (~> 2> sep hash-union)) (flow (~> (-< k v) hash))))

#| Trees

t := null | (cons label (listof t)) | (list leaf)
leaf := any
label := any

These procedures implement relatively standard map and fold operations over
trees of this kind.

Map preserves structure but changes data: the label and leaf functions convert
labels and leafs to new representations.

Fold changes structure: z replaces the empty tree value null; leaf replaces the
list contructor for leaves; label replaces the cons constructor for trees.

|#

(define (tree-map t label leaf)
  (match t
    ['() '()]
    [(list x) (list (leaf x))]
    [(cons x children)
     (cons (label x)
           (map (flow (tree-map label leaf)) children))]))

(define (tree-fold t z label leaf)
  (match t
    ['() z]
    [(list x) (leaf x)]
    [(cons x children)
     (label x (map (flow (tree-fold z label leaf)) children))]))
