% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ROC.R
\name{roc.auc.matrix}
\alias{roc.auc.matrix}
\title{ROC AUC calculation for a matrix of variables}
\usage{
roc.auc.matrix(dat, true.positives)
}
\arguments{
\item{dat}{Data matrix (variables x samples)}

\item{true.positives}{known true positive samples}
}
\value{
Vector of ROC AUC values for each variable
}
\description{
ROC AUC calculation for a matrix of variables
}
\details{
The samples are ordered for each row (variable) from the highest
   to the lowest score, and ROC/AUC value is calculated
   based on this ordering.
}
\examples{
data(peerj32)
  dat <- peerj32$microbes
  res <- roc.auc.matrix(dat, sample(colnames(dat)))
}
\author{
Contact: Leo Lahti \email{microbiome-admin@googlegroups.com}
}
\references{
See citation('microbiome')
}
\keyword{utilities}

