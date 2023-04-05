.POSIX:
SHELL = /bin/sh

# TEMPLATE MAKEFILE
#
# The attribution target deanonymizes as necessary, and then runs the
# attribution script, dumping its results to a file. See the adjacent
# synthesis.rkt script for how that works.
#
# The deanonymize target runs the deanonymization script (details on its
# function in the source). You shouldn't need to run this manually very often
# unless you want to deanonymize separately from attribution. See the adjacent
# deanonymize.rkt for details.
#
# This Makefile assumes a project structure containing appraisal and attribution
# files in certain places.

DEANONYMIZED_OUT = evaluation/appraisal/deanonymized/capital.md \
                   evaluation/appraisal/deanonymized/capital.md.sed \
                   evaluation/appraisal/deanonymized/labor.md \
                   evaluation/appraisal/deanonymized/labor.md.sed \

DEANONYMIZED_IN = input/capital.md \
                  input/capital-anonymized.md \
                  input/labor.md \
                  input/labor-anonymized.md \
                  evaluation/appraisal/capital.md \
                  evaluation/appraisal/labor.md \
                  evaluation/appraisal/deanonymized/deanonymize.rkt

.PHONY: deanonymize
deanonymize: $(DEANONYMIZED_OUT)
$(DEANONYMIZED_OUT): $(DEANONYMIZED_IN)
	evaluation/appraisal/deanonymized/deanonymize.rkt --execute

ATTRIBUTION_IN = $(DEANONYMIZED_OUT) \
                 evaluation/appraisal/ideas.md \
                 evaluation/antecedents/ideas.md \
                 evaluation/attribution/capital.rkt \
                 evaluation/attribution/ideas.rkt \
                 evaluation/attribution/labor.rkt \
                 evaluation/attribution/synthesis.rkt

.PHONY: attribute
attribute: evaluation/attribution/attribution.rktd
evaluation/attribution/attribution.rktd: $(ATTRIBUTION_IN)
	racket evaluation/attribution/synthesis.rkt > $@
