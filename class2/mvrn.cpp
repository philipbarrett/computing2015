#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
mat mvrnormArma(int n, mat sigma) {
// Code to compute multivariate normal.  Based on code from stackoverflow 
//  http://stackoverflow.com/questions/15263996/
//      rcpp-how-to-generate-random-multivariate-normal-vector-in-rcpp
  RNGScope scope;    // ensure RNG gets set/reset
  int ncols = sigma.n_cols;
  mat Y = randn(n, ncols);
  return Y ;
  return Y * chol(sigma);
}

// # R code to run after sourcing this
// set.seed(123)
// mvrnormArma( 8, sigma )
// set.seed(123)
// mvrnormArma( 8, sigma )
//    # Gives different answers!!!