#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
mat rmvnormArma( int iNN, vec vMu, mat mSigma ) {
// Code to compute multivariate normal.  Based on code from stackoverflow 
//  http://stackoverflow.com/questions/15263996/
//      rcpp-how-to-generate-random-multivariate-normal-vector-in-rcpp
  int iCols = mSigma.n_cols;
  mat mY = randn( iNN, iCols);
  return repmat( vMu, 1, iNN ).t() + mY * chol( mSigma ) ;
}

