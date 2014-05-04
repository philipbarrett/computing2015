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
void helloWorld_cpp(){
// Simple "Hello world"" example
  Rcout << "Hello World!" << std::endl ;
}

// [[Rcpp::export]]
int timesTwo( int x ){
// Simple example to muliply an integer by two
  return x * 2 ;
}

// [[Rcpp::export]]
double timesTwo_d( double x ){
  return x * 2 ;
}

// [[Rcpp::export(equals.two)]]
bool equals_two( double x ){
// Checks if a number is equal to 2
  return x == 2 ;
}

// [[Rcpp::export]]
void equals_two_vocal( double x ){
// Checks if number equals 2
  if ( x == 2 )
    Rcout <<  x << " equals 2" << std::endl ;
  else
    Rcout << x << " does not equal 2" << std::endl ;
}

// [[Rcpp::export]]
void I_like_to_move_it( int iNN ){
// Sings a ridiculous song
  for ( int iII = 0 ; iII < iNN ; iII++ )
    Rcout << "I like to move it, move it!" << std::endl ;
  Rcout << "I like to ... move it!" << std::endl ;
}

// [[Rcpp::export]]
double sumC( NumericVector x ){
// Sum an R vector using a loop
  int iNN = x.size() ;
  double total = 0 ;
  for ( int iII = 0 ; iII < iNN ; iII++ ){
    total += x[iII] ;
  }
  return total ;
}

// [[Rcpp::export]]
double euclidian( NumericVector vX, NumericVector vY ){
// Computes the Euclidean distance between two vectors

  // Error Checking
  int iNN = vX.size() ;
  int iMM = vY.size() ;
      // Size of each vector
  if( iNN != iMM )
    stop( "Error: Vectors must be equal" ) ;
//  return( NA_REAL ) ;
//  return( INFINITY ) ;

  double dist_sq = 0 ;
      // Initialize the distance
  for ( int iII = 0 ; iII < iNN ; iII++ )
    dist_sq += pow( vX[iII] - vY[iII], 2 ) ;
        // Add the square distances
  return( sqrt( dist_sq ) ) ;
      // Return the square root
}












