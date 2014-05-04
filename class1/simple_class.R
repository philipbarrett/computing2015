###############################################################################
# simple.R                                                                    #
# Companion R functions for those defined in simple.cpp                       #
# Some material taken from Hadley Wickham's tutorial:                         #
#      http://adv-r.had.co.nz/Rcpp.html                                       #
# Philip Barrett, Chicago                                                     #
# Created: 01may2014                                                          #
###############################################################################

library(microbenchmark)

sumR <- function(x){
# A *horrible* way to sum vectors
  total <- 0
  for ( iII in seq_along(x) ){
    total <- total + x[iII]
  }
  return( total )
}

x <- runif(1e3)
microbenchmark( sum(x), sumR(x), sumC(x) )

iSize <- 200
mA <- matrix( runif( iSize ^ 2 ), iSize, iSize )
vB <- vB <- runif( iSize )
solve( mA, vB )  
solve_cpp( mA, vB )
microbenchmark( solve( mA, vB ) , solve_cpp( mA, vB ) )

mX <- cbind( runif( 1000, -1, 1), rnorm( 1000, 2, 3 ) )
vY <- 2 + mX %*% c( 3, 4 ) + rnorm( 1000, 0, 2 )
reg.XY <- lm( vY ~ mX )
summary( reg.XY )
lm_cpp( vY, cbind( 1, mX ) )

mXext <- cbind( 1, mX )
microbenchmark( lm( vY ~ mX ), lm_cpp( vY, mXext ) )



