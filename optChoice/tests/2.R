#####################################################################################
# 2.R - Test functions for functions in choice.R                                    #
# Functions tested:                                                                 #
#           - opt.choice                                                            #
#                                                                                   #
# Philip Barrett, Chicago                                                           #
# Created: 28jan2015                                                                #
#####################################################################################

test.opt <- function(){
# Simple tests of the optimal choice function
  
  prec <- 1e-06
  
  test <- opt.choice( c(1,1), 1, c(.5, .5), 1 )
  checkEquals( test$vCons, c( .5, .5 ) )
  checkEquals( test$util, util.CES( c( .5, .5 ), c(.5, .5), 1 ) )
      # Symmetric case, rho=1
  
  test <- opt.choice( c(1,1), 2, c(.5, .5), 1 )
  checkEquals( test$vCons, c( .5, .5 ) )
  checkEquals( test$util, util.CES( c( .5, .5 ), c(.5, .5), 2 ) )
      # Symmetric case, rho=2
  
  test <- opt.choice( c(1,1), 1, c(.5, .5), 2 )
  checkEquals( test$vCons, c( 1, 1 ) )
  checkEquals( test$util, util.CES( c( 1, 1 ), c(.5, .5), 1 ) )
      # Symmetric case, income=2

  test <- opt.choice( c(1,1), 1, c(.2, .8), 1 )
  checkEquals( test$vCons, c( .2, .8 ) )
  checkEquals( test$util, util.CES( c( .2, .8 ), c(.2, .8), 1 ) )
      # Asymmetric case, rho=1
  
  test <- opt.choice( c(1,1), 2, c(.2, .8), 1 )
  checkEquals( test$vCons, c( .2, .8 ) )
  checkEquals( test$util, util.CES( c( .2, .8 ), c(.2, .8), 2 ) )
      # Asymmetric case, rho=2
  
  test <- opt.choice( c(1,1), 1, c(.2, .8), 2 )
  checkTrue( max( abs( test$vCons / c( .4, 1.6 ) - 1 ) ) < prec )
  checkEquals( test$util, util.CES( c( .4, 1.6 ), c(.2, .8), 1 ) )
      # Asymmetric case, income=2
}

# help.test.opt.elas <- function( target, vPrices, vShare, income ){
# # Helper function for test.opt.elas
#   
#   vConsA <- opt.choice( vPrices, target, vShare, income )$vCons
#   vConsB <- opt.choice( c( vPrices[1]*(1 + 1e-06), vPrices[2] ), target, vShare, income )$vCons
#   relConsA <- vConsA[1] / vConsA[2]
#   relConsB <- vConsB[1] / vConsB[2]
#   relPrice <- vPrices[1] / vPrices[2]
#   test <- 1 / relPrice * ( relConsA - relConsB ) / 1e-06
#   return(test)
# }
# 
# test.opt.elas <- function(){
# # Check that the optimal choice function generates the same elasticity as the
# # CES parameter
#   
#   prec <- .1
#   
#   l.prices <- list( c(1,1), c(2,1), c( 1, 2 ), c( 4, 2 ) )
#   l.rho.target <- c( .8, 1, 1.5, 3 )
#   l.shares <- list( c(.5, .5), c(.1, .9), c( .2, .8), c(.8, .2), c( 1, 1 ) )
#   l.income <- list( 1, 2, 4 )
#   for( vPrices in l.prices ){
#     for ( rho in l.rho.target ){
#       for ( vShare in l.shares ){
#         for( income in l.income ){
#           browser()
#           test <- help.test.opt.elas( rho, vPrices, vShare, income )
#           checkTrue( abs( test - rho ) < prec  )   
#         }
#       }
#     }
#   }
# }





