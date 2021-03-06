#fs <- list.files("~/HITChipDB/R/", full.names = TRUE)
#for (f in fs)  { source(f) }
#fs <- list.files("~/microbiome/R/", full.names = TRUE)
#for (f in fs)  { source(f) }

# -------------------------------------------
library(devtools)
install_github("microbiome/microbiome")
install_github("microbiome/HITChipDB")

library(HITChipDB)
dbuser <- "root"
dbpwd <- "fidipro"
dbname <- "phyloarray"
verbose = TRUE
host = '127.0.0.1'
port = 3307
summarization.methods = c("frpa", "sum", "rpa")
which.projects = "AUTISM"

#fs <- list.files("~/HITChipDB/R/", full.names = TRUE)
#for (f in fs)  { source(f) }
res <- run.profiling.script(dbuser, dbpwd, dbname, verbose = FALSE, host = host, port = port, summarization.methods = summarization.methods, which.projects = which.projects)

projs <- list.mysql.projects(dbuser, dbpwd, dbname, host = host, port = port)

res <- run.profiling.script(dbuser, dbpwd, dbname, verbose = FALSE, host = host, port = port, summarization.methods = summarization.methods, which.projects = "TURKU PET STUDY")

# -------------------------------



