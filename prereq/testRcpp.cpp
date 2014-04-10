#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void helloWorld_cpp() {
// Simple 'Hello World' example
   Rcout << "Hello World," << std::endl ;
   Rcout << "  Nice to see you there!" << std::endl ;
   Rcout << "Love," << std::endl ;
   Rcout << "    Rcpp x x x x <3" << std::endl ;
}

// [[Rcpp::export]]
NumericVector zeroToN_cpp( int iNN ){
// A very simple loop
  
  NumericVector out(iNN+1) ;
        // Pre-define the output vector
  for( int iII=0; iII<=iNN; iII++ )
    out[ iII ] = iII ;
        // Fill in the entries
  return out ;
}
