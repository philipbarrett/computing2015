# clusterStart.R: Script to start a cluster

library(parallel)
cl <- makeCluster(mpi.universe.size(), type = "MPI")