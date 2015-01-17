/*****************************************************************************
 * 
 * Code to run a Gibb's sampler on a hidden factor model
 * Adapted from John Eric Humphries' R & C++ code
 * Created: 01may2014
 * Philip Barrett, Chicago
 * 
 */


#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

const double log2pi = std::log(2.0 * M_PI);

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
mat rmvnormArma( int iNN, vec vMu, mat mSigma ) {
// Code to compute multivariate normal.  Based on code from Dirk Eidelbuettel's
// presentation:
//  http://www.rinfinance.com/agenda/2013/talk/DirkEddelbuettel.pdf
  int iCols = mSigma.n_cols;
  mat mY = randn( iNN, iCols);
  return repmat( vMu, 1, iNN ).t() + mY * chol( mSigma ) ;
}


// [[Rcpp::export]]
mat alphaUpdate_cpp ( mat mY, colvec vf, colvec vSig2 ){
/* Updates the estimate of alpha  */
  int iFacts = 1 ;
  int iMeas = mY.n_cols ;
      // Only works for one factor atm
  mat mAlphaDraw( iMeas, iFacts ) ;
      // Initialize the matrix of new alpha draws
  mAlphaDraw.row( 0 ) = ones<vec>( iFacts ) ;
      // And set the first entry of each factor to 1
  mat mInvFact = inv( trans( vf ) * vf ) ;
      // Useful matrix in the loop, just calculate it once
  for ( int iMM = 1; iMM < iMeas; iMM++ ) {
    mat mA        = vSig2[ iMM ] * mInvFact ;
    colvec vAlpha = mA * (  1 / vSig2[ iMM ] * trans( vf ) * ( mY.col( iMM ) ) ) ;
        // The updated mean and variance of the parameter distribution
    mAlphaDraw.row( iMM ) = rmvnormArma( 1, vAlpha, mA ) ;
        // Drawing from the distribution
  }
  return mAlphaDraw ;
}

// [[Rcpp::export]]
mat betaUpdate_cpp ( mat mY, colvec vf, colvec vSig2 ){
/* Updates the estimate of beta  */
  int iVars = 1 ;
  int iMeas = mY.n_cols ;
      // Only works for one data type atm
  mat mInvFact = inv( trans( vf ) * vf ) ;
      // Useful matrix in the loop, just calculate it once
  mat mBetaDraw( iMeas, iVars ) ;
      // Initialize the matrix of new alpha draws
  for ( int iMM = 0; iMM < iMeas; iMM++ ) {
    mat mB        = vSig2[ iMM ] * mInvFact ;
    colvec vBeta  = mB * (  1 / vSig2[ iMM ] * trans( vf ) * ( mY.col( iMM ) ) ) ;
        // The updated mean and variance of the parameter distribution
    mBetaDraw.row( iMM ) = rmvnormArma( 1, vBeta, mB ) ;
        // Drawing from the distribution
  }
  return mBetaDraw ;
}

// [[Rcpp::export]]
mat factorUpdate_cpp( mat mY, mat mAlpha, colvec vSig2, int iFact ) { 
/* Updates the estimate of beta */
  int iObs = mY.n_rows ;
      // The number of observations
  iFact = 1 ;
      // For now
  mat mF( iObs, iFact ) ;
      // Initialize the output
  mat mFvar  = inv( trans( mAlpha ) * diagmat( 1 / vSig2 ) * mAlpha ) ;
      // The variance matrix
  for ( int iMM = 0; iMM < iObs; iMM++ ){
    colvec vFmean = mFvar * ( trans( mAlpha ) * diagmat( 1 / vSig2 ) * trans( mY.row( iMM )  ) ) ;
        // The updated mean
    mF.row( iMM )      = rmvnormArma( 1, vFmean, mFvar ) ;
        // Drawing from the distribution
  }
  return mF ;
}


// [[Rcpp::export]]
mat factorCGibbs( int iIter, int iBurn, int iThin, mat mAlpha, vec vF, vec vSigma2,
                    mat mBeta, mat mY, vec vX) { 
// The Gibbs sampler loop
  int iMeas = mY.n_cols, iObs = mY.n_rows ;
      // Number of measures and observations
  mat mDraws = zeros( iIter, 2 * iMeas + vF.size() + mBeta.n_rows )  ;
      // Initialize the output matrix
  
  for ( int iThisIt = 0 ; iThisIt < iBurn + iIter * iThin ; iThisIt++ ){ 
    
    //Draw from Sigma (informal "flat" prior)
    vec vA  = 0.5 * ones<vec>( iMeas ) * iObs ;
    vec vB( iMeas ) ;
    
    for ( int iII = 0 ; iII < iMeas ; iII++ ){
      vec vY = mY.col( iII ) ;
      vec vAlpha = mAlpha.row( iII ) ;
      vec vBeta = mBeta.row( iII ) ;
      vB[ iII ] = 1.0 / ( 0.5 * sum( pow ( vY - vF * vAlpha - vX * vBeta, 2 ) ) ) ;
      vSigma2[ iII ]  = 1.0 / as<double>( rgamma( 1.0, vA[ iII ], vB[ iII ] ) ) ;      
    }
    
    // Draw from alpha
    mat mYa = mY - vX * trans( mBeta ) ;
    mAlpha  = alphaUpdate_cpp( mYa, vF, vSigma2) ;
    
    // Draw from beta
    mat mYb = mY - vF * trans( mAlpha ) ;
    mBeta   = betaUpdate_cpp( mYb, vX, vSigma2 ) ;
    
    // Updating Factor
    mat mYf = mY - vX * trans( mBeta ) ;
    vF = factorUpdate_cpp( mYf, mAlpha, vSigma2, 1 ) ;
        // Hard coding the number of factors here

    // Saving output
    if( ( iThisIt - iBurn ) >= 0 && iThisIt % iThin == 0 ){
      int iRow = ( iThisIt - iBurn ) / iThin ;
      mDraws.submat( iRow , 0, iRow, iMeas - 1 ) = trans( mAlpha ) ; 
      mDraws.submat( iRow , iMeas, iRow, 2 * iMeas - 1 ) = trans( vSigma2 ) ;
      mDraws.submat( iRow , 2 * iMeas, iRow, 3 * iMeas - 1 ) = trans( mBeta ) ;
      mDraws.submat( iRow , 3 * iMeas, iRow, 3 * iMeas + iObs - 1 ) = trans( vF ) ;
    }
    if ( 0 == ( iThisIt % 100 ) ) 
      Rcout << "Iteration " << iThisIt << std::endl ;
  }
  return(mDraws) ;
}
