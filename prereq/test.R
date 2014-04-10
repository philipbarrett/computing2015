###############################################################################
# Script to check installation of required packages for Rcpp/RcppArmadillo    #
# classes of the "Practical computing for economists" course, Spring 2014     #
# Philip Barrett, UofC                                                        #
# Created: 19mar2014                                                          #
###############################################################################

#### 0. CONTROLS ####
stDir <- '/home/philip/Dropbox/2014/Teaching/Computational Colloquium/barrett_rcpp/prereq'
      # Directory that the installation check file is saved to. Change this to 
      # your local address.  Remember to use (double) backslashes for addresses
      # on windows machines.
setwd( stDir )
      # Set the working directory to stDir

#### 1. CHECK FOR & INSTALL REQUIRED PACKAGES  ####
mPackages <- installed.packages()
      # Details of installed packages
stInstalled <- rownames( mPackages )
      # Isolate thep package names
stRequired <- c( 'Rcpp', 'RcppArmadillo' )
      #  The required packages

for ( stName in stRequired ){
  if ( !( stName %in% stInstalled ) ){
    cat('****************** Installing ', stName, '****************** \n')
    install.packages( stName )
  }
  library( stName, character.only=TRUE )
}


#### 2. COMPLIE C++ CODE ####
sourceCpp('testRcpp.cpp')
sourceCpp('testRcppArmadillo.cpp')

#### 3. TEST THE INSTALLATION ####
sink('testOutput.txt')
cat( '*********** Testing Rcpp  ***********\n')
cat( '\n\n**** 1. Hello World: ****\n\n')
helloWorld_cpp()
cat( '\n\n**** 2. Loop from 0 to 100: ****\n\n')
print( zeroToN_cpp(100) )
cat( '\n\n**** 3. Create a 10x10 identity matrix: ****\n\n')
print( identity_arma(10) )
cat( '\n\n**** 4. Create an R matrix and invert it using RcppArmadillo: ****\n\n')
XX <- matrix( 1:4, 2, 2 )
cat('Matrix to invert:\n')
print( XX )
cat('\nInverted\n')
print( invert_arma( XX ) )
cat('\nJust to check, here\'s their product:\n')
print( invert_arma( XX ) %*% XX )
sink()