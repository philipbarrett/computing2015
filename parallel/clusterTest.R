# clusterTest.R: Script to test cluster execution by computing 10*n sequences of
# 100 uniformly distributed random draws on 10*n different nodes

names <- clusterCall(cl, 
             function() Sys.info()[c("nodename","machine")])
print( unlist( names ) )

randoms <- clusterCall( cl, runif, 10 * mpi.universe.size() )
print( randoms )
