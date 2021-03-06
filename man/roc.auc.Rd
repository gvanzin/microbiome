% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ROC.R
\name{roc.auc}
\alias{roc.auc}
\title{ROC AUC calculation}
\usage{
roc.auc(ordered.results, true.positives)
}
\arguments{
\item{ordered.results}{Items ordered from best to worst according
to the test score.}

\item{true.positives}{known true positives}
}
\value{
ROC AUC value
}
\description{
ROC AUC calculation
}
\examples{
data(peerj32)
  x <- unlist(peerj32$microbes[1,])
  res <- roc.auc(names(x), sample(names(x), 10))
}
\author{
Contact: Leo Lahti \email{microbiome-admin@googlegroups.com}
}
\references{
See citation('microbiome')
}
\keyword{utilities}

