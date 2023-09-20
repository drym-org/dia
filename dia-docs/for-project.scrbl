#lang scribble/manual

@title{For project contributors}

@table-of-contents[]

@section{List all contributions}

@itemlist[
#:style 'ordered

@item{Analyze the project and write down all @emph{labor} contributions and who made them. This is just everything you can think of that anyone ever did in the vicinity of the project. Write these down as "X did Y" where X is the name of the person and Y is what they did. The descriptions should be minimally self-contained so as to convey the relevance of the contribution to an informed layperson.}

@item{Share this list with other contributors and community members to solicit input until there is broad agreement that it is comprehensive.}

@item{Commit this list into the project repository at abe/labor.md. Record a unique identifier (such as a commit hash) for the last contribution on the main line of development that is accounted for in the file, i.e. that the list is "current up to." The chosen contribution need not be the most recent one made, but all contributions preceding the chosen one must be accounted for and there should be no gaps of unaccounted contributions.}

@item{Create another file abe/labor-anonymized.md containing the same line items but restated in passive voice without contributor names (e.g. "Y was done" instead of "X did Y").}

@item{Repeat steps 1-4 for all @emph{capital} contributions (e.g. source code, libraries and APIs used) and their sources. The descriptions should be minimally self-contained, as before. Commit this list as abe/capital.md and abe/capital-anonymized.md.}

@item{Repeat steps 1-4 for all @emph{ideas} exhibited by the project. The descriptions should be minimally self-contained, as before. As you will likely think of these ideas in a "top down" fashion, i.e. high level ideas followed by more specific ideas, it would be most helpful to write down this tree representation of these ideas as you see them reflected in your project. Commit this as abe/ideas.md.}
]

@section{Cost analysis and proxy analysis}

@itemlist[
#:style 'ordered

@item{Come up with an estimate of all costs incurred in creating the project. This could include estimates for the cost of labor using suitable hourly wages and number of person hours. Commit this "cost analysis" as abe/cost-analysis.md}

@item{Identify other projects that are similar or analogous to the project and gather information about their pricing and valuation. Commit this "proxy analysis" as abe/proxy-analysis.md}
]
