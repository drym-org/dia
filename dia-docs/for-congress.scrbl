#lang scribble/manual

@title{For congress participants}

@table-of-contents[]

@section{Attribution}

@subsection{Analyze}

@subsubsection[#:tag "analyze:consider"]{Consider}

@itemlist[
#:style 'ordered

@item{On your own, analyze the project's anonymized labor contributions and organize them into a tree that you feel is representative, where the leaf nodes are the actual elements of the original list, and higher-level nodes represent groupings of the lower-level nodes.}

@item{Repeat for the project's anonymized capital contributions.}

@item{Repeat for the project's anonymized idea contributions.}

@item{Share your analysis with the other attendees.}

]

@subsubsection[#:tag "analyze:agree"]{Agree}

@itemlist[
#:style 'ordered

@item{As a group, discuss to reconcile the different labor analyses to agree on one labor tree that decomposes the project's labor contributions in a way that accounts for all of the independent analyses.}

@item{Repeat step 1 for the capital analysis.}

@item{Repeat step 1 for the ideas analysis.}

]

@subsection{Appraise}

@subsubsection[#:tag "appraise:consider"]{Consider}

@itemlist[
#:style 'ordered

@item{On your own, starting at the highest node in the labor analysis, appraise the proportion of value contributed by each labor component, progressively working your way into deeper levels of the tree. How important is each component compared to the others? The total of all of the components at each level must equal 100%.}

@item{Repeat (1) for the capital analysis.}

@item{Repeat (1) for the ideas analysis.}

@item{Share your appraisals with the group.}

]

@subsubsection[#:tag "appraise:agree"]{Agree}

@itemlist[
#:style 'ordered

@item{Discuss to reconcile the different labor appraisals to agree on one appraisal that apportions value in the project in a way that accounts for all of the independent appraisals.}

@item{Repeat (1) for the project's capital appraisal.}

@item{Repeat (1) for the project's ideas appraisal, distributing the value of each "leaf" idea in the tree evenly over its antecedents.}

]

@subsection{Antecedents}

@subsubsection[#:tag "antecedents:consider"]{Consider}

@itemlist[
#:style 'ordered

@item{On your own, annotate each @emph{leaf} idea in the agreed-upon ideas tree with any projects that you can think of that exhibit the idea or a similar idea. "Projects" here could be software projects, academic papers, videos, art, songs, or anything else that could be considered as a single creation. These projects need not have any other relationship to the present project besides common ideas, and these should be recorded with no consideration to temporality (i.e. whether the project came before or after the present one). Projects may appear on any number of leaf ideas.}
]

@subsubsection[#:tag "antecedents:agree"]{Agree}

@itemlist[
#:style 'ordered

@item{As a group, reconcile all reported antecedents in the ideas tree.}

@item{For each reported antecedent, find out when it was published (i.e. released publicly). Create a new list of these projects together with their publication date, e.g. "The Merchant of Venice, 1596".}

@item{In this list, for projects that were announced within a year (on either side) of the present project, they are considered "cognates," so write down the word "cognate" next to them, e.g. "The Merchant of Venice, 1596, cognate". These will be treated in the same way as true antecedents, so they can remain on the annotated ideas tree.}

@item{In the same list, for projects that were announced more than a year after the present project, write down "subsequent" (instead of "cognate" -- e.g. "The Merchant of Venice, 1596, subsequent"), and remove them from the annotated ideas tree.}

]

@section{Pricing and Valuation}

@subsection[#:tag "evaluate:consider"]{Consider}

@itemlist[
#:style 'ordered

@item{On your own, review the cost analysis and proxy analysis provided by the project.}

@item{Come up with a fair market price for use of the project.}

@item{Come up with a valuation of everything created so far in the project.}

]

@subsection[#:tag "evaluate:agree"]{Agree}

@itemlist[
#:style 'ordered

@item{Discuss and agree on price and valuation.}
]

@section{Results}

@subsection{Reconcile the Appraisals}

Discuss to assign weights to each appraisal tree. Consider using the 1-N-N² rule -- that is, if labor is worth K, then capital is worth 1/N × K, and ideas are worth 1/N² × K, for some "scaling factor" N that you agree on. The rationale is that we want labor, capital and ideas to be equally valuable when aggregated over all projects. Since labor is the least portable while ideas are the most portable, this rule models the fluidity of these categories as, roughly, "for every project you directly work on, N projects will use your work, and N² projects will be inspired by it." Note, nevertheless, that the ideas analysis described elsewhere in this document is not in terms of "inspiration" (implying causation) but only similarity.

@subsection{Deanonymize and Tally}

@itemlist[
#:style 'ordered

@item{"Deanonymize" – connect each leaf node in the appraised labor tree to a single contributor in the original non-anonymous list prepared by core project contributors.}

@item{Repeat (1) for capital.}

@item{Sum up the proportions by leaf nodes across all appraisal trees, weighted by the scaling factor for each tree (i.e. in the manner decided upon in "reconcile the appraisals"), to arrive at the final attributive proportions that total to 100%. Deliver this as an abe/ATTRIBUTIONS.txt file in the project repository.}
]
