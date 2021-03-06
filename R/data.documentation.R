#' peerj32 data documentation 
#'
#' The peerj32 data set contains high-through profiling data from 
#' 389 human blood serum lipids and 130 intestinal genus-level bacteria from 
#' 44 samples (22 subjects from 2 time points; before and after 
#' probiotic/placebo intervention). The data set can be used to investigate 
#' associations between intestinal bacteria and host lipid metabolism. 
#' For details, see \url{http://dx.doi.org/10.7717/peerj.32}.
#'
#' @name peerj32
#' @docType data
#' @author Leo Lahti \email{microbiome-admin@@googlegroups.com} 
#'         has preprocessed the data.
#' @references Lahti et al. (2013) Associations between the human intestinal 
#'             microbiota, Lactobacillus rhamnosus GG and serum lipids 
#'             indicated by integrated analysis of high-throughput profiling 
#'             data. PeerJ 1:e32 \url{http://dx.doi.org/10.7717/peerj.32}
#' @usage data(peerj32)
#' @format List of the following data matrices as described in detail in 
#'         Lahti et al. (2013):
#' \itemize{
#'   \item lipids: Quantification of 389 blood serum lipids across 44 samples
#'   \item microbes: Quantification of 130 genus-like taxa across 44 samples
#'   \item meta: Sample metadata including time point, gender, subjectID, sampleID and treatment group (probiotic LGG / Placebo)
#' }
#'   
#' @keywords data
NULL 
