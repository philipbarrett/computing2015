#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
mat identity_arma(int iNN) {
  mat AA = eye( iNN, iNN ) ;
  return AA ;
}

// [[Rcpp::export]]
mat invert_arma(mat XX) {
  mat YY = inv( XX ) ;
  return YY ;
}