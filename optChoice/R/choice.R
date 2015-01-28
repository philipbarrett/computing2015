#####################################################################################
# choice.R - Definitiions for the optimal choice problem used as an example for     #
# the unit testing session of "Practiclal Computing for Economists" 2015            #
#                                                                                   #
# Philip Barrett, Chicago                                                           #
# Created: 28jan2015                                                                #
# Based heavily on code for TAing Ken Judd's class in Fall 2013                     #
#####################################################################################

#** 0. Set up **#
library('nloptr')

#** 1. Define utility functions **#

share.cons.check <-function( vCons, vShare ){
# Assigns equal shares to empty shares and checks shares and consumption vector
# are the same length

  if ( is.null( vShare ) ) 
    vShare <- rep( 1, length( vCons ) ) / length( vCons )
  # Set all share parameters to 1 if not supplied
  
  if ( length( vShare ) != length( vCons ) )
    stop('Shares and consumption bundles must be the same size')
  # Error checking: make sure that the bundles and share are off the same length  
  
  if( any( vCons < 0 ) )
    stop('All consumption shares must be positive')
  # Error checking: cannot have negative consumption
  
  return( vShare )
}

util.CES <- function( vCons, vShare=NULL, rho=1 ){
# The utility of consuming a vector of goods vCons with share parameters vShare
# and constant elasticity of substitution rho.  Utility is given by:
  
  # Error checking:
  vShare <- share.cons.check( vCons, vShare )
  
  # Output
  if ( rho != 1 )
    return( ( sum( vCons ^ ( 1 - 1 / rho ) * vShare ^ ( 1 / rho ) ) ^ ( rho / ( rho - 1 ) ) ) )  
  else
    return( prod( vCons ^ vShare ) )
          # Return the Armington aggregate of the goods
}

util.CES.marg.i <- function( ci, ai, rho=rho.true, util=NULL, vCons=NULL, vShare=NULL ){
# Computes the marginal utility of product i with share ai and CES rho.  Utility
# of all the other goods may be provided directly via util, or computed using vCons
  
  # Error checking:
  if( is.null( util ) & is.null( vCons ) ) stop('Need to provide one of util or vCons')
  
  # Compute util if absent
  if ( is.null( util ) ) util <- util.CES( vCons, vShare, rho )
  
  # Output
  return( ( util * ai / ci ) ^ ( 1 / rho ) )
  
}

util.CES.marg <- function( vCons, vShare=NULL, rho=rho.true, util=NULL ){
# Computes the vector of derivatives of util.CES.marg.i
  
  # Error checking:
  vShare <- share.cons.check( vCons, vShare )
  
  # Compute utility if missing
  if( is.null( util ) )
    util <- util.CES( vCons, vShare, rho )
  
  # Comptue the vector of marginal utilites
  return( mapply( util.CES.marg.i, ci=vCons, ai=vShare, 
                  MoreArgs=list( rho=rho, util=util ) ) )
  
}

#** 2. Define the budget set **#

expenditure.slack <- function( vCons, vPrices, income ){
# Computes the expenditure at the given prices
  return( sum( vCons * vPrices ) - income )
}

expenditure.deriv <- function( vPrices ){
# Computes the derivative of the expenditure wrt consumption of each good
  return( vPrices )
}

#** 3. Set up the optimality problem **#

opt.choice <- function( vPrices, rho, vShare, income ){
# Returns the optimal choice given prices, preferences and income
  
  #* i. Specifics of the problem *#
  iGoods <- length( vPrices )
        # Number of goods
  lb <- 0 * 1:iGoods
  ub <- Inf * 1:iGoods
        # Range of consumption choices
  x0 <- income / vPrices / sum(1/vPrices)
        # Initial guess that satsfies the constraint

  #* ii. Translate the functions above into those dependent only on consumption *#
  eval_f <- function( vCons ) return( - util.CES( vCons, vShare, rho ) )
  eval_grad_f <- function( vCons ) return( - util.CES.marg( vCons, vShare, rho ) )
  eval_g <- function( vCons ) return( expenditure.slack( vCons, vPrices, income ) )
  eval_jac_g <- function( vCons ) return( expenditure.deriv( vPrices ) )
  
  #* iii. Solve the optimization problem *#
  opts <- list( "algorithm"="NLOPT_LD_SLSQP", 'xtol_rel'=1e-08, 
                                'ftol_rel'=1e-08, 'maxeval'=10000 )
  optimize <- nloptr(x0 = x0, eval_f = eval_f, eval_grad_f = eval_grad_f, lb = lb,
                     ub = ub, eval_g_ineq = eval_g, eval_jac_g_ineq = eval_jac_g, 
                     opts = opts )
  
  2#* iv. Check the status of the solver and return *#
  if ( !( optimize$status %in% c(1,3) ) )
    stop('NLOPT did not solve OK')
  else
    return( list( vCons=optimize$solution, util=-optimize$objective ) ) 
}

