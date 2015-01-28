#!/bin/bash
#PBS -j oe
#PBS -V
#PBS -v np=10
#PBS -l procs=10

cd $PBS_O_WORKDIR

`which mpiexec` -n 1 -machinefile $PBS_NODEFILE R --vanilla > myrmpi.out <<EOF

# Start Cluster
source('clusterStart.R')

# Your parallel script here
source('clusterTest.R')
# source('clusterEigen.R')

# Stop cluster
source('clusterStop.R')

EOF
