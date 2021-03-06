% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/plot_abundance.R
\name{plot_composition}
\alias{plot_composition}
\title{Plot taxon abundance for samples}
\usage{
plot_composition(x, taxonomic.level = NULL, relative.abundance = FALSE,
  sort.by = NULL, x.label = "sample")
}
\arguments{
\item{x}{\code{\link{phyloseq-class}} object or an OTU matrix (samples x phylotypes)}

\item{taxonomic.level}{Merge the OTUs (for phyloseq object) into a higher taxonomic level.
This has to be one from \code{colnames(tax_table(x))}.}

\item{relative.abundance}{Logical. Show relative abundances or not.}

\item{sort.by}{Sort by sample data column. Or provide vector of sample IDs.}

\item{x.label}{Specify how to label the x axis. This should be one of the variables in
       \code{sample_variables(x)}}
}
\value{
A \code{\link{ggplot}} plot object.
}
\description{
Plot taxon abundance for samples
}
\examples{
#
}
\keyword{utilities}

