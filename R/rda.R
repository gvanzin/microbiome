
#' rda_physeq 
#'
#' RDA for phyloseq objects. Based on the \code{\link{rda}} function 
#' from the \pkg{vegan} package.
#'
#' Arguments:
#'   @param x \code{\link{phyloseq-class}} object
#'   @param varname Variable to apply in RDA visualization.
#'   @param scale See help(rda)
#'   @param na.action See help(rda)
#'
#' Returns:
#'   @return rda result. See help(vegan::rda)
#'
#' @export
#' @importFrom vegan rda
#'
#' @examples #
#'
#' @references See citation("microbiome") 
#' @author Contact: Leo Lahti \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities

rda_physeq <- function (x, varname, scale = FALSE, na.action = na.fail) {

  # Microbiota profiling data (44 samples x 130 bacteria)
  otu <- t(otu_table(x)@.Data)

  # Sample annotations
  annot <- sample_data(x)[[varname]]

  # Run RDA
  rdatest <- rda(otu ~ annot, scale = scale, na.action = na.action) 
  
  rdatest

}


#' Description: BAGGED RDA Bootstrap solutions that follows the
#' Jack-knife estimation of PLS by Martens and Martens, 2000.  Solves
#' rotational invariance of latent space by orthogonal procrustes
#' rotations
#'
#' Arguments:
#'   @param X a matrix, samples on columns, variables (bacteria) on rows.
#'   @param Y vector with names(Y)=rownames(X), for example
#'   @param boot Number of bootstrap iterations
#'
#' Returns:
#'   @return List with items:
#'   	     loadings: bagged loadings
#' 	     scores: bagged scores
#' 	     significance: significances of X variables
#' 	     etc. TBA.	    
#'
#' @export
#' @importFrom vegan scores
#' @importFrom vegan rda
#' @importFrom vegan procrustes
#'
#' @examples # NOT RUN data(peerj32); x <- as.matrix(peerj32$microbes)[1:20, 1:6]; y <- rnorm(nrow(x)); names(y) <- rownames(x); res <- Bagged.RDA(x, y , boot = 5)
#'
#' @references See citation("microbiome") 
#' @author Contact: Jarkko Salojarvi \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities

Bagged.RDA <- function(X, Y, boot = 1000){

  ## Jarkko Salojarvi 7.8.2012
  ##  #17.8.2012 fixed problem with multiclass RDA  

   if (is.numeric(boot)){
      class.split=split(names(Y),Y)

      boot=replicate(boot,unlist(sapply(class.split,function(x) sample(x,length(x),replace=T))),simplify=F)
   }
   nboot=length(boot)
   n.lev=length(levels(Y))
   TT=scores(rda(t(X)~Y),choices=1:max(n.lev-1,2),display="sites")
   nRDA=ncol(TT) 
   # rotate 
   rotateMat=function(M,TT,x){
      M.rot=procrustes(TT[x,],M)
      return(M.rot$Yrot)
   }
   nearest.centers=function(xx,cc){
     nC=nrow(cc)
     nS=nrow(xx)
     MM=as.matrix(dist(rbind(cc,xx)))[1:nC,(nC+1):(nC+nS)]
     if (nS>1)
       apply(MM,2,which.min)
     else
       which.min(MM)
   }
   # bootstrap loadings
   Tx=lapply(boot,function(x){ 
      nC=length(levels(Y[x]))
      M=rda(t(X[,x])~Y[x])
      # get scores
      TT.m=scores(M,choices=1:max(nC-1,2),display="sites")
      # bootstrap error
      testset=setdiff(colnames(X),x)
      err=NA
      if (length(testset)>0){
        Pr=predict(M,t(as.data.frame(X[,testset])),type="wa",model="CCA")
        centers=apply(TT.m,2,function(z) sapply(split(z,Y[x]),mean))
        if (nC==2)
           y.pred=apply(sapply(Pr,function(x) (x-centers[,1])^2),2,which.min)
        else
           y.pred=nearest.centers(Pr,centers) 
        err=mean(y.pred-as.numeric(Y[testset])!=0)
      }
      # procrustes rotation of scores
      TT.m=rotateMat(TT.m,TT,x)
      # solve loadings
      a=t(TT.m) %*% TT.m
      b=as.matrix(X[,x]-rowMeans(X[,x]))
      loadingsX=t(solve(a,t(b %*% TT.m)))
      list(loadingsX=loadingsX,err=err)
   })
   # significances   
   sig.prob=list()
   for (i in 1:nRDA){
     tmp=sapply(Tx,function(x) x$loadingsX[,i])
     sig.prob[[i]]=apply(tmp,1,function(x){ x1=sum(x>0)/length(x); x2=1-x1; min(x1,x2)})
    }
    names(sig.prob)=colnames(TT)
    # bagged estimates
    bagged.loadings=Tx[[1]]$loadingsX
    for (i in 2:nboot)
      bagged.loadings=bagged.loadings+Tx[[i]]$loadingsX
    bagged.loadings=bagged.loadings/nboot
    colnames(bagged.loadings)=colnames(TT)

    # solve scores
    a=t(bagged.loadings) %*% bagged.loadings
    b=as.matrix(X-rowMeans(X))
    bagged.scores=t(solve(a,t(bagged.loadings) %*% b))
    colnames(bagged.scores)=colnames(TT)
    # Group centers 
    Group.center=apply(bagged.scores,2,function(x) sapply(split(x,Y),mean))
    err.t=mean((nearest.centers(bagged.scores,Group.center)-as.numeric(Y))!=0) 

    # bagged error
    #err.t=mean((Y-prediction(X,Y,bagged.loadings,bagged.loadings.Y,bagged.proj,mean(Y),rowMeans(X)))^2)
    #random.pred=Y-rmultinom(length(Y),1,
    err.random=replicate(nboot,mean((as.numeric(Y)-sample(as.numeric(Y)))!=0))
    bagged.error=mean(sapply(Tx, function(x) x$err),na.rm=T)
    R=(bagged.error-err.t)/(mean(err.random)-err.t)
    R=max(min(R,1),0)
    w=.632/(1-.368*R)
    bagged.R2=(1-w)*bagged.error+w*err.t
    #bagged.R2=1-((1-w)*err.t+w*err.b)/mean(Y^2)
    can.cor.R=apply(X,1,function(x) cor(x,bagged.scores))^2
    Rsquare=rowSums(can.cor.R)/sum(diag(var(t(X))))
    names(Rsquare)=colnames(bagged.scores)
    Rsquare.variable=t(can.cor.R/apply(X,1,var))
    colnames(Rsquare.variable)=colnames(bagged.scores)
    list(loadings=bagged.loadings,scores=bagged.scores,significance=sig.prob,error=bagged.R2,group.centers=Group.center,bootstrapped=Tx,err.random=mean(err.random),err.significance=sum(err.random>bagged.R2)/nboot,R2=Rsquare,R2.variables=Rsquare.variable)
}


#' Description: Bagged RDA feature selection
#'
#' Arguments:
#'   @param x a matrix, samples on columns, variables (bacteria) on rows. 
#'          Or a \code{\link{phyloseq-class}} object
#'   @param y vector with names(y)=rownames(X). 
#'            Or name of phyloseq sample data variable name.
#'   @param sig.thresh signal p-value threshold, default 0.1
#'   @param nboot Number of bootstrap iterations
#'   @param verbose verbose
#'
#' Returns:
#'   @return List with items:
#'   	     loadings: bagged loadings
#' 	     scores: bagged scores
#' 	     significance: significances of X variables
#' 	     group.centers: group centers on latent space
#' 	     bootstrapped: bootstrapped loadings
#' 	     data: data set with non-significant components dropped out.
#'
#' @examples #
#' #  library(microbiome)
#' #  data(peerj32)
#' #  x <- t(peerj32$microbes)
#' #  y <- factor(peerj32$meta$time); names(y) <- rownames(peerj32$meta)
#' #  res <- bagged_rda(x, y, sig.thresh=0.05, nboot=100)
#' #  PlotBaggedRDA(res, y)
#'
#' @export
#'
#' @references See citation("microbiome") 
#' @author Contact: Jarkko Salojarvi \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities
bagged_rda <- function(x, y, sig.thresh = 0.1, nboot = 1000, verbose = T){

  if (class(x) == "phyloseq") {
    # Pick OTU matrix and the indicated annotation field
    y <- factor(sample_data(x)[[y]])
    names(y) <- sample_data(x)$sample
    x <- otu_table(x)@.Data
  }

  stop.run=F
  class.split=split(names(y),y)
  dropped=vector("character",nrow(x))
  x.all=x
  mean.err=rep(1,nrow(x))
  while(stop.run==F){
    boot=replicate(nboot,unlist(sapply(class.split,function(x) sample(x,length(x),replace=T))),simplify=F)
    Bag.res=Bagged.RDA(x,y,boot=boot)
    min.prob=Bag.res$significance[[1]]
    if (length(levels(y))>2){
      for (i in 1:nrow(x))
         min.prob[i]=min(sapply(Bag.res$significance,function(x) x[i]))
    }
    mean.err[nrow(x)]=Bag.res$error
    dropped[nrow(x)]=rownames(x)[which.max(min.prob)]
    if (verbose) {message(c(nrow(x), Bag.res$error))}
    if (nrow(x)>max(length(class.split),2))
      x=x[-which.max(min.prob),]
    else
      stop.run=T
  }
  dropped[1:length(class.split)]=rownames(x)[order(min.prob)[1:length(class.split)]]
  best.res=which.min(mean.err)

  Bag.res=Bagged.RDA(x.all[dropped[1:best.res],],y,boot=boot)
  Bag.res$data=x.all[dropped[1:best.res],]
  Bag.res$Err.selection=mean.err
  Bag.res$dropped=dropped

  plot(mean.err,xlab="x dimension")
  points(best.res,mean.err[best.res],col="red")

  list(bagged.rda = Bag.res, variable = y)

}




#' Description: Bagged RDA visualization
#'
#' Arguments:
#'   @param x Output from bagged_rda
#'   @param which.bac TBA
#'   @param ptype TBA
#'   @param comp TBA
#'   @param cex.bac TBA
#'   @param plot.names Plot names
#'   @param group.cols TBA
#'   @param ... Other arguments to be passed
#'   
#'
#' Returns:
#'   @return TBA
#'
#' @examples #
#'   #library(microbiome)
#'   #data(peerj32)
#'   #x <- t(peerj32$microbes)
#'   #y <- factor(peerj32$meta$time); names(y) <- rownames(peerj32$meta)
#'   #res <- bagged_rda(x, y, sig.thresh=0.05, nboot=100)
#'   #plot_bagged_rda(res)
#'
#' @export
#' @importFrom ade4 s.class
#'
#' @references See citation("microbiome") 
#' @author Contact: Jarkko Salojarvi \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities
plot_bagged_rda <- function(x, which.bac = 1:nrow(Bag.res$loadings),
	           ptype="spider", comp=1:2, cex.bac=0.5, plot.names=T,
		   group.cols = as.numeric(unique(Y)),...){

  Bag.res <- x$bagged.rda
  Y <- x$variable

  scaled.loadings <- (Bag.res$loadings/max(abs(Bag.res$loadings)))[,comp]
  scaled.scores <- (Bag.res$scores/max(abs(Bag.res$scores)))[,comp]

  plot(rbind(scaled.scores,scaled.loadings),type="n",xlab=paste(names(Bag.res$R2)[1]," (",format(100*Bag.res$R2[1],digits=2),"%)",sep=""),ylab=paste(names(Bag.res$R2)[2]," (",format(100*Bag.res$R2[2],digits=2),"%)",sep=""))
  if (ptype=="spider")
    s.class(scaled.scores,factor(Y),grid=F,col=group.cols,cellipse=0.5,cpoint=0,add.plot=T)
  if (ptype=="hull"){

    ll=split(rownames(scaled.scores),Y)
    hulls=lapply(ll,function(ii) ii[chull(scaled.scores[ii,])])
    for (i in 1:length(hulls))
      polygon(scaled.scores[hulls[[i]],],border=group.cols[i])
  }   
  if (plot.names){
     text(scaled.scores,rownames(scaled.scores),cex=0.5,...)
  }else{
    points(scaled.scores,...)
  }
  text(scaled.loadings[which.bac,],rownames(scaled.loadings)[which.bac],cex=cex.bac)
}


