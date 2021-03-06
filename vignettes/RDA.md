### RDA analysis and visualization. 

Load the package and example data:


```r
library(microbiome)
# Data from https://peerj.com/articles/32/
pseq <- download_microbiome("peerj32")$physeq
```

### Standard RDA 

Standard RDA for microbiota profiles versus the 'time' variable from 
sample metadata:


```r
rdatest <- rda_physeq(pseq, "time")
```

### RDA significance test


```r
permutest(rdatest) 
```

```
## 
## Permutation test for rda 
## 
## Permutation: free
## Number of permutations: 99
##  
## Call: rda(formula = otu ~ annot, scale = scale, na.action =
## na.action)
## Permutation test for all constrained eigenvalues
## Pseudo-F:	 0.3570377 (with 1, 42 Degrees of Freedom)
## Significance:	 0.9
```

### RDA visualization

Visualizing the standard RDA output:


```r
plot(rdatest, choices = c(1,2), type = "points", pch = 15, scaling = 3, cex = 0.7, col = meta$time)
points(rdatest, choices = c(1,2), pch = 15, scaling = 3, cex = 0.7, col = meta$time)
pl <- ordihull(rdatest, meta$time, scaling = 3, label = TRUE)
title("RDA with control for subject effect")
```

![plot of chunk rda4](figure/rda4-1.png) 

### Bagged RDA

Fitting bagged RDA on a phyloseq object:


```r
res <- bagged_rda(pseq, "group", sig.thresh=0.05, nboot=100)
```

![plot of chunk rda5](figure/rda5-1.png) 

Visualizing bagged RDA:


```r
plot_bagged_rda(res)
```

![plot of chunk rda6](figure/rda6-1.png) 


### Controlling confounding variables with RDA

For more complex scenarios, use the vegan package directly:


```r
# Pick microbiota profiling data from the phyloseq object
otu <- otu_table(pseq)@.Data

# Sample annotations
meta <- sample_data(pseq)

# RDA with confounders
rdatest2 <- rda(t(otu) ~ meta$time + Condition(meta$subject + meta$gender))
```



