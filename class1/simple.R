###############################################################################
# simple.R                                                                    #
# Companion R functions for those defined in simple.cpp                       #
# Some material taken from Hadley Wickham's tutorial:                         #
#      http://adv-r.had.co.nz/Rcpp.html                                       #
# Philip Barrett, Chicago                                                     #
# Created: 19mar2014                                                          #
###############################################################################

sumR <- function(x) {
# A *horrible* way to sum up vectors
  total <- 0
  for (i in seq_along(x)) {
    total <- total + x[i]
  }
  total
}


x <- runif(1e3)
microbenchmark( sum(x), sumR(x), sumC(x) )

mX <- cbind(runif( 10000, -1, 1 ), rnorm( 10000, 2, 3 ) )
vY <- 2 + mX %*% c( 3, 4 ) + rnorm( 10000, 0, 2)
AA <- data.frame( X=mX, Y =vY  )

reg.XY <- lm( Y ~ X.1 + X.2, data=AA )
summary( reg.XY )
mpe( reg.XY )
lm_cpp( vY, cbind( 1, mX ) )

mXext <- cbind( 1, mX )
microbenchmark( lm( Y ~ X.1 + X.2, data=AA ), lm_cpp( vY, mXext ) )
    # About 180 times faster!