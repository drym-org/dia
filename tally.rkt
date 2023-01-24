#lang racket

(require data/lazytree
         relation
         qi)

(define-flow leaf?
  (~> rest empty?))

(define node-name car)

(define node-weight cdr)

(define (bump name delta-coefficients #:results results)
  (let ([current (hash-ref results name 0)]
        [delta (* 100 (apply * (map (☯ (/ 100)) delta-coefficients)))])
    (hash-set! results name (+ current delta))))

(define (tally t observe reduce #:results results)
  (let go ([t t]
           [work null])
    (let* ([n (first t)]
           [name (node-name n)]
           [work (cons (observe n) work)])
      (if (leaf? t)
          (reduce name work #:results results)
          (for-each (☯ (go work))
                    (rest t))))))

(define (validate-attributions attributions)
  (~> (attributions) hash-values △ + (= 100)))

(define (validate-appraisal tree)
  ;; check that everything totals to 1
  (let ([attributions (make-hash)])
    (tally tree
           node-weight
           bump
           #:results attributions)
    (validate-attributions attributions)))

(define labor-tree
  '(("symex" . 100)
    (("functional contributions" . 70)
     (("core" . 50)
      (("sid" . 30))
      (("sid" . 30))
      (("sid" . 40)))
     (("language support" . 30)
      (("clojure" . 20)
       (("dcostaras" . 30))
       (("anonimitoraf" . 40))
       (("markgdawson" . 30)))
      (("common lisp" . 10)
       (("doyougnu" . 100)))
      (("non-lisp" . 70)
       (("anonymous" . 5))
       (("tommy" . 10))
       (("simon" . 20))
       (("simon and sid" . 65)
        (("simon" . 50))
        (("sid" . 50)))))
     (("interfaces" . 20)
      (("evil" . 85)
       (("sid" . 75))
       (("tommy" . 3))
       (("tommy" . 2))
       (("jake" . 20)))
      (("visual aids" . 15)
       (("simon" . 70))
       (("sid" . 30)))))
    (("support" . 30)
     (("documentation" . 40)
      (("sid" . 30))
      (("tommy" . 10))
      (("sid" . 60))
      (("markgdawson" . 0)))
     (("bug reports" . 15)
      (("pepperblue" . 40))
      (("markgdawson" . 20))
      (("tarsius" . 20))
      (("markgdawson" . 20)))
     (("operational excellence" . 15)
      (("riscy" . 20))
      (("riscy" . 40))
      (("sid" . 25))
      (("basilconto" . 5))
      (("dcostaras" . 5))
      (("devcarbon" . 5)))
     (("reach out" . 30)
      (("ariana" . 20))
      (("jeff" . 40))
      (("jeff" . 40))))))

(define capital-tree
  '(("symex" . 100)
    (("platform/core" . 30)
     (("emacs" . 100)))
    (("dev tools" . 5)
     (("melpazoid" . 100)))
    (("structural editing primitives" . 35)
     (("paredit" . 75))
     (("lispy" . 20))
     (("evil-cleverparens" . 2.5))
     (("evil-surround" . 2.5)))
    (("UI libraries" . 30)
     (("hydra" . 30))
     (("evil" . 70)))))

(define antecedents
  (hash
   "custom syntax" '("emacs")
   "cursor-oriented semantics" '("gremlin" "vim" "evil")
   "structural motions" '("emacs" "gremlin" "vim" "evil" "paredit" "lispy" "tree-sitter")
   "structural transformations" '("emacs" "gremlin" "vim" "evil" "paredit" "lispy" "tree-sitter")
   "structural computations" '("gremlin")
   "structure-respecting edits" '("emacs" "paredit" "lispy" "drracket" "parinfer")
   "linguistic interface" '("vim" "evil")
   "menu-driven interface" '("hydra")
   "point-free design" '("apl")
   "elisp runtime" '("emacs")
   "racket runtime" '("racket mode")
   "scheme runtime" '("scheme mode")
   "clojure runtime" '("cider")
   "common lisp runtime" '("slime" "sly")
   "arc runtime" '("arc mode")))

(define ideas-tree
  '(("symex" . 100)
    (("structural editing language (DSL)" . 50)
     (("custom syntax" . 15))
     (("cursor-oriented semantics" . 60))
     (("primitives" . 25)
      (("structural motions" . 30))
      (("structural transformations" . 30))
      (("structural computations" . 10))
      (("structure-respecting edits" . 30))))
    (("modal interface" . 35)
     (("linguistic interface" . 25))
     (("menu-driven interface" . 15))
     (("point-free design" . 60)))
    (("language-specific runtime" . 15)
     (("elisp runtime" . 17))
     (("racket runtime" . 17))
     (("scheme runtime" . 16))
     (("clojure runtime" . 17))
     (("common lisp runtime" . 17))
     (("arc runtime" . 16)))))

(validate-appraisal labor-tree)
(validate-appraisal capital-tree)
(validate-appraisal ideas-tree)

(define-values (labor-attributions
                capital-attributions
                ideas-attributions
                antecedents-attributions
                attributions)
  (values (make-hash)
          (make-hash)
          (make-hash)
          (make-hash)
          (make-hash)))

(tally labor-tree
       node-weight
       bump
       #:results labor-attributions)

(tally capital-tree
       node-weight
       bump
       #:results capital-attributions)

(tally ideas-tree
       node-weight
       bump
       #:results ideas-attributions)

(define (incorporate-appraisal appraisal wt result)
  (for-each (λ (i)
              (match-let ([(cons k v) i])
                (let ([cur (hash-ref result k 0)])
                  (hash-set! result k (+ cur (* v wt))))))
            (hash->list appraisal)))

(incorporate-appraisal labor-attributions .69 attributions)
(incorporate-appraisal capital-attributions .23 attributions)
(define (attribute-antecedents ideas-attributions antecedents result)
  (for ([(k v) (in-hash ideas-attributions)])
    (let* ([ants (hash-ref antecedents k)]
           [n (length ants)])
      (for ([ka ants])
        (hash-set! result ka (/ v n))))))
(attribute-antecedents ideas-attributions antecedents antecedents-attributions)
(incorporate-appraisal antecedents-attributions .08 attributions)

(sort #:key cdr > (hash->list attributions))

(validate-attributions attributions)
