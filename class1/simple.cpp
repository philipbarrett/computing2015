/*********************************************************************
 * 
 * simple.cpp
 * Includes simple examples for learning how to use Rcpp
 * Some material taken from Hadley Wickham's tutorial:
 *      http://adv-r.had.co.nz/Rcpp.html
 * Philip Barrett, Chicago, 01may2014
 * 
 *********************************************************************/

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void helloWorld_cpp() {
// Simple 'Hello World' example.  Illustrates how to source and call a C++
// function from R
   Rcout << "Hello World!" << std::endl ;
}


// [[Rcpp::export]]
int timesTwo(int x) {
// Simple example to multiply an integer by 2
  int ans = x * 2 ;
  return ans ;
}

// [[Rcpp::export]]
double timesTwo_d(double x) {
// Now multiply a double by 2
  return  x * 2 ;
}

// [[Rcpp::export(equals.two)]]
bool equals_two(double x) {
// Checks if a number equals 2
  return  x == 2 ;
}

// [[Rcpp::export]]
void equals_two_vocal(double x) {
// Checks if a number equals 2
  if( x == 2 )
    Rcout << "This number equals 2" << std::endl ;
  else
    Rcout << "This number does not equal 2" << std::endl ;
}

// [[Rcpp::export]]
void I_like_to_move_it( int iNN ){
// Sings a ridiculous song
  for( int iII = 0; iII < iNN; iII++ )
    Rcout << "I like to move it, move it." << std::endl ;
  Rcout << "I to ... move it!" << std::endl << std::endl;
}

// [[Rcpp::export]]
void n_green_bottles( int iNN ){
// Also sings a song.
  for ( int iII = iNN; iII > 0; iII-- ){
    Rcout << iII << " bottles of beer on the wall,"<< std::endl ;
    Rcout << iII << " bottles of beer,"<< std::endl ;
    Rcout << "Take one down, pass it around," << std::endl ;
    Rcout << iII - 1 << " bottles of beer on the wall." << std::endl << std::endl ;
  }
}

// [[Rcpp::export]]
double sumC(NumericVector x) {
// Sum an R vector using a loop.  Note the base zero counting!!!
  int n = x.size();
  double total = 0;
  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total;
}

// [[Rcpp::export]]
double euclidian( NumericVector vX, NumericVector vY ) {
// Computes the Euclidian distance between two vectors
  
  // Error checking
  int iNN = vX.size() ;
  int iMM = vY.size() ;
      // The size of each vector
      // This is an example of a METHOD
  if( iNN != iMM ){
    Rcout << "Error: Vectors must be same size" << std::endl ;
    return( NA_REAL );
        // Return NA if don't agree
//    return( INFINITY );
//    stop( "Error: Vectors must be same size" )
  }
  
  double dist_sq = 0;
      // Initialize the distance calculator
  for ( int iII = 0; iII < iNN; ++iII ) {
    dist_sq += pow( vX[iII] - vY[iII], 2 ) ;
        // Compute the distance
  }
  return sqrt( dist_sq );
      // Return the sqaure of the sum of the entries
}

// [[Rcpp::export]]
double mat_row_sum( NumericMatrix vMM, int iRow ){
// Sums a given row from a matrix
  NumericVector vRow = vMM( iRow - 1, _ ) ;
  return sumC( vRow ) ;
}


// [[Rcpp::export]]
double mpe(List mod) {
// Computes the mean percentage error in a regression.  Illustrates how to use
// an R list
  if ( !mod.inherits("lm") ) stop("Input must be a linear model");
      // Error checking
  NumericVector resid = as<NumericVector>(mod["residuals"]);
  NumericVector fitted = as<NumericVector>(mod["fitted.values"]);
      // Map the vectors in mod
  int n = resid.size();
  double err = 0;
  for(int i = 0; i < n; ++i) {
    err += resid[i] / (fitted[i] + resid[i]);
  }
  return err / n;
}
