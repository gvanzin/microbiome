### ROC analysis

A basic example of ROC/AUC analysis.


```r
# Example data
library(microbiome)
pseq <- download_microbiome("dietswap")
```

```
## Downloading data set from O'Keefe et al. Nat. Comm. 6:6342, 2015 from Data Dryad: http://datadryad.org/resource/doi:10.5061/dryad.1mn1n
```

```r
# Pick two groups of samples
# African, DI group, time points 1 and 2
# See the original publication for details: 
# references provided in help(dietswap)
pseq1 <- subset_samples(pseq, nationality == "AFR" & 
		     timepoint.within.group == 1 & 
		     group == "DI")
pseq2 <- subset_samples(pseq, nationality == "AFR" & 
		     timepoint.within.group == 2 & 
		     group == "DI")

# Pick OTU matrix
otu <- otu_table(pseq)@.Data

# Pick sample metadata
meta <- sample_data(pseq)

# Define two sample groups for demonstration purpose
g1 <- sample_names(pseq1)
g2 <- sample_names(pseq2)

# Compare the two groups with Wilcoxon test
pvalues <- c()
for (tax in rownames(otu)) {
  pvalues[[tax]] <- wilcox.test(otu[tax, g1], otu[tax, g2])$p.value
}

# Order the taxa based on the p-values
ordered.results <- names(sort(pvalues))

# Assume there are some known true positives 
# Here for instance Bacteroidetes
bacteroidetes <- levelmap("Bacteroidetes", from = "L1", to = "L2", GetPhylogeny("HITChip", "filtered"))$Bacteroidetes
true.positives <- bacteroidetes

# Overall ROC analysis (this will give the cumulative TPR and FPR 
# along the ordered list)
res <- roc(ordered.results, true.positives)

# Calculate ROC/AUC value
auc <- roc.auc(ordered.results, true.positives)
print(auc)
```

```
## [1] 0.3621495
```

```r
# Plot ROC curve
roc.plot(ordered.results, true.positives, line = TRUE)
```

![plot of chunk roc-example](figure/roc-example-1.png) 
