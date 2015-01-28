#####################################################################################
# 1.R - Test functions for functions in choice.R                                    #
# Functions tested:                                                                 #
#           - util.CES                                                              #
#           - util.CES.marg.i                                                       #
#           - util.CES.marg                                                         #
#                                                                                   #
# Philip Barrett, Chicago                                                           #
# Created: 28jan2015                                                                #
#####################################################################################

test.util <- function(){
# Tests the utility function

  checkEquals( util.CES( c( 1, 1 ), c( .25, .25 ), 2 ), 1 )
      # Simple check that utility is 1 at this point
  checkEquals(  util.CES( c( 2, 2 ), c( .25, .25 ), 2 ), 2 )
    # Test that we have CRS in consumption
  checkEquals( util.CES( c( 4, 9 ), c( 1, 1 ), 2 ), 25 )
      # Test that we have function is correct on unequal consumption bundles
  checkTrue( util.CES( c( 4, 9 ), c( 1, 1 / 9 ), 2 ) == 9 )
      # Test that weights work.  Try different checking function here too
  checkException( util.CES( c( 1, 1, 1 ), c( .25, .25 ), 2 ) )
  checkException( util.CES( c( -1, 1 ), c( .25, .25 ), 2 ) )
      # Check that either different quantities and shares fails, or that
      # negative consumption fails
}

test.util.marg <- function(){
# Tests the marginal utility function
  
  prec <- 1e-06
  
  util <- util.CES( c( 1, 2 ), c( 1 / 3, 2 / 3 ), 2 )
  test <- util.CES.marg.i( 1, 1 / 3, 2, util=util )
  target <- 1e08 * ( util.CES( c( 1 + 1e-08, 2 ), c( 1 / 3, 2 / 3 ), 2 ) - util )
      # Test marginal utility in good 1.  NB: Using previously-tested funcntions
  checkEquals( target, test )
  
  util <- util.CES( c( 4, 3 ), c( .2, .8 ), 5 )
  test <- util.CES.marg.i( 3, .8, 5, util=util )
  target <- 1e08 * ( util.CES( c( 4, 3 + 1e-08 ), c( .2, .8 ), 5 ) - util )
      # Test MU in good 2
  checkTrue( abs( target / test - 1 ) < prec )
  
  util <- util.CES( c( 4, 3 ), c( .2, .8 ), 1 )
  test <- util.CES.marg.i( 3, .8, 1, util=util )
  target <- 1e08 * ( util.CES( c( 4, 3 + 1e-08 ), c( .2, .8 ), 1 ) - util )
      # Test marginal utility in good 2 with log preferences
  checkTrue( abs( target / test - 1 ) < prec )
  
  util <- util.CES( c( 2, 1 ), c( .5, .5 ), 1 )
  test <- util.CES.marg.i( 2, .5, 1, util=util )
  target <- 1e08 * ( util.CES( c( 2 + 1e-08, 1 ), c( .5, .5 ), 1 ) - util )
      # Test marginal utility in good 1 with log preferences
  checkTrue( abs( target / test - 1 ) < prec )
  
  util <- util.CES( c( 2, 1 ), c( .5, .5 ), .2 )
  test <- util.CES.marg(  c( 2, 1 ), c( .5, .5 ), .2, util=util )
  target <- 1e08 * ( c( util.CES( c( 2 + 1e-08, 1 ), c( .5, .5 ), .2 ),
                        util.CES( c( 2, 1 + 1e-08 ), c( .5, .5 ), .2 ) ) - util )
      # Test the vector of marginal utilities
  checkTrue( max( abs( target / test - 1 ) ) < prec )
  
}