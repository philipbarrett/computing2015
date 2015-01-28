#####################################################################################
# choiceExtras.R - functions to manipulate the optimal choice models in choice.R    #
#                                                                                   #
# Philip Barrett, Chicago                                                           #
# Created: 28jan2015                                                                #
# Based heavily on code for TAing Ken Judd's class in Fall 2013                     #
#####################################################################################

#** 0. Set up **#
library('parallel')

#** 1. Compute the elasticity of substitution **#

opt.elasticity.fd <- function( vPrices, rho, vShare, income, iGoods=c(1,2), diff=1e-06 ){
# Computes by finite difference the elasticity of substitution implied by
# opt.choice.  Here iGoods is the two goods between which we compute the elastiticy
  
  # Construct consumption at two different prices
  lCons <- list( )
  lCons[[1]] <- opt.choice( vPrices, rho, vShare , income )$vCons
  iPrices <- length( vPrices )
  vPrices.alt <- vPrices * ( 1 + diff * ( 1:iPrices == iGoods[1] ) )
  lCons[[2]] <- opt.choice( vPrices.alt, rho, vShare , income )$vCons
  
  # Compute relative changes
  vRelCons <- c( lCons[[1]][ iGoods[1] ] / lCons[[1]][ iGoods[2] ], 
                 lCons[[2]][ iGoods[1] ] / lCons[[2]][ iGoods[2] ] )
  return( ( vRelCons[1] - vRelCons[2] ) / ( diff * vRelCons[1] ) )
  
}

#** 2. Calculate some demand curves  **#

demand.curve <- function( rho, vShare, income, vPrices, pRange, iGood=1, iPrices=100 ){
  # Compute the demand curve for good iGood over prices pRange, given income,
  # other prices, and preferences
  
  demand.i <- function ( price.i ){
    # Local function to compute demand for good i at price.i, given the other
    # parameters of the model
    vPrices.demand <- vPrices
    vPrices.demand[ iGood ] <- price.i
    # Calculate the vector of prices
    cons <- opt.choice( vPrices.demand, rho, vShare, income )$vCons
    # Compute the consuption of all goods
    return( cons[ iGood ] )
    # Return consumption of good i
  }
  
  prices.i <- seq( pRange[1], pRange[2], length.out=iPrices )
  # The vector of prices at which to compute demands
  quantities.i <- sapply( prices.i, demand.i )
  # Calculate the quantities demanded of good i
  return( quantities.i )
  
}

plot.demand.rho <- function( vRho, vShare, income, vPrices, pRange, iGood=1, iPrices=100, 
                             log.flag=FALSE ){
  # Plot the demand functions for rho in vRho
  
  # Compute the demands
  lDemands.i <- mclapply( vRho, demand.curve, vShare, income, vPrices, pRange, iGood, iPrices )
  if( log.flag ) lDemands.i <- lapply( lDemands.i, log )
  
  # Create plot and draw lines
  prices.i <- seq( pRange[1], pRange[2], length.out=iPrices )
  if( log.flag ) prices.i <- log(prices.i)
  if( log.flag ){
    plot( log( pRange ), range( unlist( lDemands.i ) ), type='n', xlab='Log Price', ylab='Log Quantity' )
  }else{
    plot( pRange, range( unlist( lDemands.i ) ), type='n', xlab='Price', ylab='Quantity' )
  }
  for ( iRho in 1:length( vRho ) )
    lines( prices.i, lDemands.i[[ iRho ]], col=iRho, lwd=2 )
  
  # Add legend
  legend.text <- list()
  for ( iII in 1:length( vRho ) )
    legend.text[ iII ] <- paste( 'rho' , ' = ' , vRho[ iII ] )
  legend( 'topright', legend=unlist( legend.text ), col=1:length( vRho ), lwd=2, bty='n')
}