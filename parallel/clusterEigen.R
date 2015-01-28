# clusterEigen.R - Computes the eigenvectors of many different-sized random matrices

eigen.random <- function( iSize=5 ){
# Compute the eigenvectors of a random square matrix of arbitrary size
  mA <- matrix( runif( iSize ^ 2 ), ncol = iSize )
          # The random matrix A
  eigen <- eigen( mA )
        # The list of eigenvectors and eigenvalues
  return( eigen$vector )
}

vTaskSizes <- 10 * rep( 15:31, 3 )
    # Crate matrices of varying sizes

tm <- proc.time()
serial.execution <- lapply( vTaskSizes, eigen.random )
serial.time <- proc.time()- tm
print( serial.time )

tm <- snow.time( clusterApply( cl, vTaskSizes, eigen.random ) )
pdf('eigenClusterApply.pdf')
plot( tm )
dev.off()

tm <- snow.time( clusterApplyLB( cl, vTaskSizes, eigen.random ) )
pdf('eigenClusterApplyLB.pdf')
plot( tm )
dev.off()

tm <- snow.time( parLapply( cl, vTaskSizes, eigen.random ) )
pdf('eigenParLapply.pdf')
plot( tm )
dev.off()