
## Networks

For more network examples, see [phyloseq tutorial](http://joey711.github.io/phyloseq/plot_network-examples)


```r
library(microbiome)
pseq <- download_microbiome("dietswap")
ig <- make_network(pseq, max.dist = 0.2)
plot_network(ig, pseq, color = "nationality", shape = "group", line_weight = 0.4, label = "sample")
```

![plot of chunk networks](figure/networks-1.png) 

Another example:


```r
plot_net(pseq, maxdist = 0.2, point_label = "group")
```

![plot of chunk networks2](figure/networks2-1.png) 

