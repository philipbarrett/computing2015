#######################################################################################
# Test squite for optimal choice problem                                              #
#                                                                                     #
# Philip Barrett, Chicago                                                             #
# Created: 28jan2015                                                                  #
#######################################################################################

# 0. Set up
library('RUnit')
rm( list = ls() )
    # Clear workspace
setwd('/home/philip/code/2015/teaching/computing2015/optChoice')

# 1. Source the functions
sourceDir <- function(path, trace = TRUE, ...) {
  for (nm in list.files(path, pattern = '\\.[RrSsQq]$')) {
    if(trace) cat(nm,':')
    source(file.path(path, nm), ...)
    if(trace) cat('\n')
  }
}
sourceDir( 'R', trace=TRUE )

# 2. Run the test suite
test.suite <- defineTestSuite( 'optChoice', dirs = file.path('tests'),
                               testFileRegexp = '^\\d+\\.R' )
    # Define the suite
test.results <- runTestSuite( test.suite )
    # Record the results
printTextProtocol( test.results )
    # Print the results