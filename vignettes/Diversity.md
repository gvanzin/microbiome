
### Richness 


```r
# Get example data in phyloseq format
library(microbiome)
pseq <- download_microbiome("atlas1006")

# Pick the OTU data
# (note the zero point has been moved to the detection threshold;
#  typically signal 1.8 at HITChip log10 scale)
otu <- otu_table(pseq)@.Data

# Determine detection threshold at the 0.15 quantile
# Bacteria that exceed this threshold are considered present
# otherwise absent
det.th <- quantile(otu, 0.15)

# Visualize the detection threshold (at log10 scale for clarity)
plot(density(log10(otu)), main = "Detection threshold", xlab = "Abundance (Log10)", ylab = "Frequency")
abline(v = log10(det.th))
```

![plot of chunk rich-example](figure/rich-example-1.png) 

```r
# Calculate richness.
# This simply indicates how many taxa are present in each sample
# (exceed the detection threshold). This measure is sometimes used with
# phylogenetic microarrays.
ri <- estimate_diversity(pseq, det.th = det.th)$Observed
hist(ri, main = "Richness")
```

![plot of chunk rich-example](figure/rich-example-2.png) 


### Diversity 

Estimate diversity (table with various diversity measures):


```r
diversity <- estimate_diversity(pseq)
```

Visualize diversity vs. discrete variable:


```r
p <- plot_diversity(pseq, x = "bmi_group", measures = "Shannon")
print(p)
```

![plot of chunk div-example2](figure/div-example2-1.png) 

Same with the phyloseq function:


```r
p <- plot_richness(pseq, x = "bmi_group", measures = c("Chao1", "Shannon"))
p <- p + geom_boxplot()
print(p)
```

![plot of chunk div-example2b](figure/div-example2b-1.png) 


Highlight specific groups:


```r
library(ggplot2)
data.dietswap <- download_microbiome("dietswap")
p <- plot_richness(data.dietswap, x = "gender", color = "group", measures = c("Shannon", "Simpson")) 
p <- p + geom_boxplot()
print(p)
```

![plot of chunk richness](figure/richness-1.png) 

Diversity vs. continuous variable:


```r
p <- plot_diversity(pseq, x = "age", measures = "Shannon")
print(p)
```

![plot of chunk diversitywithmetadata2](figure/diversitywithmetadata2-1.png) 

Same with the phyloseq function:


```r
p <- plot_richness(pseq, x = "age", measures = "Shannon")
p <- p + geom_smooth()
print(p)
```

![plot of chunk diversitywithmetadata2b](figure/diversitywithmetadata2b-1.png) 


Diversity vs. age with smoothed confidence intervals - manual version:


```r
library(microbiome)
library(sorvi)
library(dplyr)

# Add diversity into sample metadata
sample_data(pseq)$diversity <- estimate_diversity(pseq)$Shannon

# Select a subset of samples
pseq0 <- subset_samples(pseq, time == 0 & DNA_extraction_method == "r")

# Visualize
df <- sample_data(pseq0)
p <- sorvi::regression_plot(diversity ~ age, df)
print(p)
```

![plot of chunk diversity-example13](figure/diversity-example13-1.png) 


