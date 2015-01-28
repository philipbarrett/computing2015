#####################################################################################
# introTAtestFuncs.R - R file containing function definitions for testing in the    #
# "Introduction to R" TA session                                                    #
# Philip Barrett, Chicago                                                           #
# Created: 02oct2013                                                                #
#####################################################################################





opt1 <- function(){
# Test elasticity of substitution is generated from choice behavior
  vPrices <- c(1,1)
  target <- 1
  vConsA <- opt.choice( vPrices, target, c(.5, .5) , 1 )$vCons
  vConsB <- opt.choice( c( vPrices[1]*(1 + 1e-07), vPrices[2] ), target, c(.5, .5) , 1 )$vCons
  relConsA <- vConsA[1] / vConsA[2]
  relConsB <- vConsB[1] / vConsB[2]
  relPrice <- vPrices[1] / vPrices[2]
  test <- 1 / relConsA * ( relConsA - relConsB ) / 1e-07
  return( abs( target - test ) < prec[3] ) 
}

opt2 <- function(){
# Test elasticity of substitution is generated from choice behavior
  vPrices <- c(1,1)
  target <- 2
  vConsA <- opt.choice( target, c(.5, .5) , 1, vPrices )$vCons
  vConsB <- opt.choice( target, c(.5, .5) , 1, c( vPrices[1]*(1 + 1e-07), vPrices[2] ) )$vCons
  relConsA <- vConsA[1] / vConsA[2]
  relConsB <- vConsB[1] / vConsB[2]
  relPrice <- vPrices[1] / vPrices[2]
  test <- 1 / relConsA * ( relConsA - relConsB ) / 1e-07
  return( abs( target - test ) < prec[3] ) 
}

opt3 <- function(){
# Test elasticity of substitution is generated from choice behavior
  vPrices <- c(2,1)
  target <- 2
  vConsA <- opt.choice( target, c(.5, .5) , 1, vPrices )$vCons
  vConsB <- opt.choice( target, c(.5, .5) , 1, c( vPrices[1]*(1 + 1e-07), vPrices[2] ) )$vCons
  relConsA <- vConsA[1] / vConsA[2]
  relConsB <- vConsB[1] / vConsB[2]
  relPrice <- vPrices[1] / vPrices[2]
  test <- 1 / relConsA * ( relConsA - relConsB ) / 1e-07
  return( abs( target - test ) < prec[3] ) 
}

opt4 <- function(){
# Test elasticity of substitution is generated from choice behavior
  vPrices <- c(2,1)
  target <- 4
  vShare <- c( .2, .8 )
  vConsA <- opt.choice( target, vShare , 1, vPrices )$vCons
  vConsB <- opt.choice( target, vShare , 1, c( vPrices[1]*(1 + 1e-07), vPrices[2] ) )$vCons
  relConsA <- vConsA[1] / vConsA[2]
  relConsB <- vConsB[1] / vConsB[2]
  relPrice <- vPrices[1] / vPrices[2]
  test <- 1 / relConsA * ( relConsA - relConsB ) / 1e-07
  return( abs( target - test ) < prec[3] + prec[2] ) 
}