#' Description: ROC analysis returning true and false positive rates
#' along an ordered list
#'
#' Arguments:
#' @param ordered.results Items ordered from best to worst according
#'        to the test score.
#' @param true.positives known true positives
#'
#' Returns:
#'   @return List: true positive rate (tpr) and false positive rate (fpr)
#'
#' @export
#'
#' @references See citation("microbiome") 
#' @author Contact: Leo Lahti \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities

roc <- function (ordered.results, true.positives) {
	
	# Check that all known positives are included in the original 
	# analysis i.e. ordered results list
	positives<-true.positives[true.positives %in% ordered.results]	
	
	# Number of retrieved known cytobands
	N <- length(ordered.results) #total number of samples
	Np <- length(positives) #number of positives
	Nn <- N - Np #number of negatives

	TP <- cumsum(ordered.results %in% positives)
	FP <- cumsum(!(ordered.results %in% positives))
	tpr <- TP/Np #TP/(TP + FN) = TP.simCCA / true.positives
	fpr <- FP/Nn #FP/(FP + TN) = FP.simCCA / N.simCCA

	list(tpr=tpr,fpr=fpr)
}


#' Description: Plot ROC curve
#'
#' Arguments:
#' @param ordered.results Items ordered from best to worst according
#'        to the test score.
#' @param true.positives known true positives
#' @param line Draw 45 angle line
#' @param title Title text
#' Returns:
#'   @return Used for its side effects (plot)
#'
#' @export
#'
#' @references See citation("microbiome") 
#' @author Contact: Leo Lahti \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities


roc.plot <- function(ordered.results, true.positives, line=F, title="") {
	res <- roc(ordered.results, true.positives)
	plot(res$fpr,res$tpr,lty=1,type='l',xlab="False positive rate",ylab="True positive rate",xlim=c(0,1),ylim=c(0,1),main=paste("ROC curve", title))
	if (line) {
	  # Draw 45 angle line
	  lines(c(0,1),c(0,1))
	}
}


#' Description: ROC AUC calculation
#'
#' Arguments:
#' @param ordered.results Items ordered from best to worst according
#'        to the test score.
#' @param true.positives known true positives
#'
#' Returns:
#'   @return ROC AUC value
#'
#' @export
#'
#' @references See citation("microbiome") 
#' @author Contact: Leo Lahti \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities



roc.auc <- function (ordered.results, true.positives) {

  # Compute area under curve
  rates <- roc(ordered.results, true.positives)
  # integration: Compute step intervals and compute weighted sum of 
  # true positive rates in each interval.
  # note that interval length can be 0 if fpr does not change
  auc <- as.numeric(t(rates$fpr[-1]-rates$fpr[-length(rates$fpr)])%*%rates$tpr[-length(rates$fpr)])

  auc
}