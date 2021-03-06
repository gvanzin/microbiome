### Interactive motioncharts

Plotting a Motion Chart using googleVis package.


```r
library(microbiome)  

# Load simulated example data
data.directory <- system.file("extdata", package = "microbiome")
metadata.example.file <- paste(data.directory, "/meta.tab", sep = "")
metadata.simulated <- read.csv(metadata.example.file, sep = "\t", as.is = TRUE)
genus.matrix.log10.simulated <- read.profiling(data.directory, method = "frpa")$L2

# Combine phylotype profiling data and sample metadata
df <- cbind(metadata.simulated, t(genus.matrix.log10.simulated))  

# Plot a Motion Chart using googleVis - package
# Note: requires flash and internet connection
# use install.packages("googleVis") to install the library if needed
library(googleVis)  

# Form a motion chart from example data
# NOTE: the data set must be given as data.frame
# which can contain NUMERIC and CHARACTER fields
# (NO FACTORS, NOR LOGICAL variables!).
# The FIRST FOUR FIELDS must be provided in the following order:
# idvar, timevar, two numeric fields, then any number of numeric and 
# character fields
#
# NOTE: the plot shows only the first time point. 
# Replace the time field with a constant to plot all in one figure
# using df$time <- rep(1, nrow(df))

# See help(gvisMotionChart) for further details
mchart <- gvisMotionChart(df, idvar = "sample", timevar = "time")  

# Plot immediately (opens in browser, requires flash)
plot(mchart)  
```

Save as html (needs javascript to open!). NOTE: html file viewing does not work locally - store the html file on server and view through internet:


```r
print(mchart, file="~/MotionChart.html")
```
