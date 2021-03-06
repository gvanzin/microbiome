% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/diversity.R
\name{estimate_diversity}
\alias{estimate_diversity}
\title{Diversity estimation. Augments the estimate_richness function of the
phyloseq package}
\usage{
estimate_diversity(x, split = TRUE, measures = NULL, det.th = 0)
}
\arguments{
\item{x}{\code{\link{phyloseq-class}} object}

\item{split}{See help(phyloseq::estimate_richness)}

\item{measures}{See help(phyloseq::estimate_richness)}

\item{det.th}{detection threshold for observing taxa (absence / presence)}
}
\value{
Vector containing relative proportions for each phylotype in
        each sample
}
\description{
Diversity estimation. Augments the estimate_richness function of the
phyloseq package
}
\examples{
#pseq <- download_microbiome("peerj32")$physeq
  #d <- estimate_diversity(pseq, det.th = 0)
}
\author{
Contact: Leo Lahti \email{microbiome-admin@googlegroups.com}
}
\references{
See citation('microbiome')
}
\keyword{utilities}

