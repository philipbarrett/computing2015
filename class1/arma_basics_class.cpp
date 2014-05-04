/*********************************************************************
 * 
 * arma_basics.cpp
 * Includes simple examples for learning how to use RcppArmadillo
 * Some material taken from Dirk Eidelbuettel's wabpage:
 *      http://dirk.eddelbuettel.com/code/rcpp.armadillo.html
 * Philip Barrett, Chicago, 01may2014
 * 
 *********************************************************************/

#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
mat identity_arma( int iNN ){
// Create and return an identity matrix
  mat AA = eye( iNN, iNN ) ;
  return AA ;
}

// [[Rcpp::export]]
mat invert_arma( mat mX ){
// Invert a matrix
  mat mY = inv( mX ) ;
  return mY ;
}

// [[Rcpp::export]]
colvec solve_cpp( mat mA, colvec vB ){
// Solve a linear system
  return solve( mA, vB ) ;
}

List lm_cpp ( colvec vY, mat mX ){
// Linear projection in C++
  
  int iObs = mX.n_rows, iVars = mX.n_cols ;
  colvec vCoef = solve( mX, vY ) ;
      // Fit Model
  colvec vResid = vY - mX * vCoef ;
      // Residuals
  double dSig2 = as_scalar( trans( vResid ) * vResid / ( iObs - iVars ) ) ;
  colvec vStdErrEst = sqrt( dSig2 * diagvec( inv( trans( mX ) * mX ) ) ) ;
      // Vector of standard errors
  return List::create( Named("coefficients") = vCoef,
                        Named("stderr") = vStdErrEst ) ;
}







