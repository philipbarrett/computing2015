# clusterStart.R: Script to start a cluster

# library(parallel)
library(snow)
    # Using snow only to make charts
cl <- makeCluster(mpi.universe.size(), type = "MPI")