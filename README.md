# DIA Resources

## Installation

``` shell
$ cd dia
$ make install
```

## Usage

In a project's DIA repo (e.g. [dia-symex](https://github.com/drym-org/dia-symex)), something like this will generate the attribution results:

``` shell
$ cd evaluation/attribution
$ racket synthesized.rkt
```

## Incorporating Adjustments

When labor, capital or ideas inputs are modified to account for formerly left-out items, these "adjustments" could be incorporated by following these steps.

1. Update the input files.
2. Use those to update the trees, adding hierarchy levels as needed.
3. Use those to update the appraisals, leaving TODOs on all new items.
4. Resolve the TODOs.
5. Refer to the appraisals and update the deanonymized appraisals.
6. Update the resulting tree data in the attributions scripts.
7. Recompute the results by running ``$ racket synthesized.rkt``.
