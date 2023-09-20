#lang scribble/manual

@title{For congress participants}

@table-of-contents[]

@section{Attribution}

@subsection[#:style 'unnumbered]{1 Analyze}

@itemlist[
#:style 'ordered

@item{On your own, analyze the project's anonymized labor contributions and organize them into a tree that you feel is representative, where the leaf nodes are the actual elements of the original list, and higher-level nodes represent groupings of the lower-level nodes.}

@item{Repeat for the project's anonymized capital contributions.}

@item{Repeat for the project's anonymized idea contributions.}

@item{Share your analysis with the other attendees.}

]

@subsection[#:style 'unnumbered]{2 Agree on Analysis}

@itemlist[
#:style 'ordered

@item{As a group, discuss to reconcile the different labor analyses to agree on one labor tree that decomposes the project's labor contributions in a way that accounts for all of the independent analyses.}

@item{Repeat step 1 for the capital analysis.}

@item{Repeat step 1 for the ideas analysis.}

]

@subsection[#:style 'unnumbered]{3 Identify Antecedents}

@itemlist[
#:style 'ordered

@item{As a group, annotate each @emph{leaf} idea in the agreed-upon ideas tree with any projects that you can think of, that is, projects exhibiting that idea or a similar idea. These projects need not have any other relationship to the present project besides common ideas, and these should be recorded with no consideration to temporality (i.e. whether the project came before or after the present one). Projects may appear on any number of leaf ideas.}

@item{Identify projects in the annotated ideas tree that were announced within a year (on either side) of the present project, and write those down as a list of identified "cognates," retaining them on the annotated ideas tree. These will be treated in the same way as true antecedents.}

@item{Identify projects in the annotated ideas tree that were announced more than a year after the present project, and write those down as a list of identified "subsequents," removing them from the annotated ideas tree.}

]

@subsection[#:style 'unnumbered]{4 Appraise}

@itemlist[
#:style 'ordered

@item{On your own, starting at the highest node in the labor analysis, appraise the proportion of value contributed by each labor component, progressively working your way into deeper levels of the tree. How important is each component compared to the others? The total of all of the components at each level must equal 100%.}

@item{Repeat (1) for the capital analysis.}

@item{Repeat (1) for the ideas analysis.}

@item{Share your appraisals with the group.}

]

@subsection[#:style 'unnumbered]{5 Agree on Appraisals}

@itemlist[
#:style 'ordered

@item{Discuss to reconcile the different labor appraisals to agree on one appraisal that apportions value in the project in a way that accounts for all of the independent appraisals.}

@item{Repeat (1) for the project's capital appraisal.}

@item{Repeat (1) for the project's ideas appraisal, distributing the value of each "leaf" idea in the tree evenly over its antecedents.}

]

@subsection[#:style 'unnumbered]{6 Reconcile the Appraisals}

Discuss to assign weights to each appraisal tree. Consider using the 1-N-N² rule -- that is, if labor is worth K, then capital is worth 1/N × K, and ideas are worth 1/N² × K, for some "scaling factor" N that you agree on. The rationale is that we want labor, capital and ideas to be equally valuable when aggregated over all projects. Since labor is the least portable while ideas are the most portable, this rule models the fluidity of these categories as, roughly, "for every project you directly work on, N projects will use your work, and N² projects will be inspired by it." Note, nevertheless, that the ideas analysis described elsewhere in this document is not in terms of "inspiration" (implying causation) but only similarity.

@subsection[#:style 'unnumbered]{7 Deanonymize and Tally}

@itemlist[
#:style 'ordered

@item{"Deanonymize" – connect each leaf node in the appraised labor tree to a single contributor in the original non-anonymous list prepared by core project contributors.}

@item{Repeat (1) for capital.}

@item{Sum up the proportions by leaf nodes across all appraisal trees, weighted by the scaling factor for each tree (i.e. in the manner decided upon in "reconcile the appraisals"), to arrive at the final attributive proportions that total to 100%. Deliver this as an abe/ATTRIBUTIONS.txt file in the project repository.}

@item{Deliver the list of cognates and subsequents as abe/cognates.txt and abe/subsequents.txt, respectively, to be committed to the project repository.}

]

@section{Pricing and Valuation}

@itemlist[
#:style 'ordered

@item{Review the cost analysis and proxy analysis provided by the project.}

@item{Come up with a fair market price for use of the project.}

@item{Come up with a valuation of everything created so far in the project.}

]
