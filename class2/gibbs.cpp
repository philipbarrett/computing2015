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


//// [[Rcpp::export]]
//colvec alphaUpdate_cpp ( int iFacts, int iMeas, mat mY, colvec vf, colvec vSig2 )   {
///* Updates the estimate of alpha  */
//  for ( int iMM = 1 + iFacts; iMM < iMeas; iMM++ ) {
//    colvec mA      = solve(  1/sigma2[miter] * (t(fa)%*%fa))
//    alpha1             <- A1 %*% (  1/sigma2[miter] * t(fa) %*% (Ya[,miter]) )
//    alpha[miter,] <- rnorm(1,alpha1,A1)    
//  }
//  alpha
//}


//// [[Rcpp::export]]
//SEXP factorCGibbs(int N, int Measures, int Burnin, int Thin, int Niter, int Nfactors,
//                  NumericVector alpha, NumericVector X, NumericVector beta, NumericVector f,
//                  NumericVector sigma2, NumericVector Y ){
//  
//  arma::mat aalpha  = as<arma::mat>(alpha);
//  arma::mat XX =     as<arma::mat>(X);
//  arma::mat bbeta  = as<arma::mat>(beta);
//  arma::mat ff     = as<arma::mat>(f);
//  arma::vec  ssigma2 = as<arma::vec>(sigma2);
//  arma::mat YY = as<arma::mat>(Y); 
//  
//  
//      // Vars Defined In The Code
//  RNGScope scope;
//  int iter;
//  int Tot = Burnin + Niter*Thin;
//  arma::mat Ya(N,Measures);
//  arma::mat fa(N,2); // Note the hard coding
//  Rcpp::NumericVector temp(1);
//  int a1;
//  double b1;
//  int miter;
//  int m;
//  arma::vec tem(ssigma2.n_rows);
//  // double F1;
//  arma::mat alphaf(Measures,2); //Note Hard Code
//  arma::mat Yf;
//  arma::mat Yb;
//  arma::mat Xb(N,3); // NOTE HARD CODED 2
//  // arma::vec temp2(Measures) ; 
//  arma::mat mid  ;
//  double je ;
//  arma::mat B1  ;
//  arma::mat beta1      ;
//  arma::vec  rnd ;
//  arma::mat  drw(4,1)  ; //Note Hard Code
//  arma::rowvec Yfsub ;
//  arma::vec   f1  ;
//  arma::mat A1    ;
//  arma::mat alpha1  ;
//  arma::rowvec temp3 ;
//  arma::rowvec temp4 ;
//  arma::rowvec temp5 ;
//  arma::vec sig2;
//  int fill;
//  arma::mat FF0(2,2); // note hard code
//  arma::vec ff0(2);   // not hard code
//  arma::mat F1(2,2);
//  
//  
//  // The Loop
//  double sza = aalpha.n_rows * aalpha.n_cols;
//  arma::mat draws_alpha(Niter, sza)  ;
//  arma::mat draws_sigma2(Niter, ssigma2.n_rows )  ;
//  int szf = N * 2 ; // Note Hard Code
//  arma::mat draws_f(Niter,szf)  ;
//  double szb = bbeta.n_rows * bbeta.n_cols;
//  arma::mat draws_beta(Niter,  szb )  ;
//  
//  for (iter=0;iter<Tot;iter++)
//  { 
//  
//  
//  // UPDATING SIGMA2 
//  for (miter=0;miter<Measures;miter++)
//  {   
//  arma::vec YYc = YY.col(miter);
//  arma::rowvec aalphar = aalpha.row(miter);
//  arma::rowvec bbetar = bbeta.row(miter);
//  a1 = YY.col(miter).n_rows /2 ; // Eventually want to make this non-NA rows of Y...
//  b1= 1 / (sum( pow( (YYc - ff*aalphar.t() - XX*bbetar.t()),2)) / 2);
//  temp = 1 / rgamma(1,a1,b1);
//  ssigma2(miter) = temp(0) ;
//  }
//  
//  //UPDATING ALPHA AND BETA
//  arma::mat Obs = join_rows(ff,XX);
//  tem = 1.0/ssigma2;
//  for (miter=3;miter<Measures;miter++) 
//  {
//  je     = tem(miter) ;
//  A1     =  inv(  (Obs.t()*Obs)) ;
//  alpha1 = A1 * (  (Obs.t()*YY.col(miter))) ;
//  rnd    = rnorm(5)  ; // Note the hardcodede 4
//  drw    = alpha1 + chol(A1) * rnd ;
//  if (miter>0)
//  {
//  aalpha(miter,0) = drw(0);
//  aalpha(miter,1) = drw(1);
//  bbeta(miter,0)  = drw(2);
//  bbeta(miter,1)  = drw(3);
//  bbeta(miter,2)  = drw(4);
//  }
//  }
//  
//  
//  //UPDATING ALPHA
//  Ya = YY - XX * inv( XX.t()*XX )* (XX.t()*YY);
//  fa.col(0) = ff.col(0) - XX * inv( XX.t()*XX )* (XX.t()*ff.col(0));
//  fa.col(1) = ff.col(1) - XX * inv( XX.t()*XX )* (XX.t()*ff.col(1));
//  tem = 1.0/ssigma2;
//  for (miter=2;miter<3;miter++) 
//  {
//  je = tem(miter) ;
//  A1     =  inv( tem(miter) *  (fa.t()*fa)) ;
//  alpha1 = A1 * ( tem(miter) * (fa.t()*Ya.col(miter))) ;
//  rnd = rnorm(2)  ;
//  drw = alpha1 + chol(A1) * rnd ;
//  aalpha.row(miter) = drw.t() ;
//  }
//  
//  
//  //Updating Beta
//  Yb    = YY  - ff* inv(ff.t() * ff)  * (ff.t()*YY);
//  Xb.col(0) = XX.col(0)  - ff * inv(ff.t() * ff)  * (ff.t()*XX.col(0));
//  Xb.col(1) = XX.col(1) - ff * inv(ff.t() * ff)  * (ff.t()*XX.col(1));
//  Xb.col(2) = XX.col(2) - ff * inv(ff.t() * ff)  * (ff.t()*XX.col(2));
//  for (miter=2;miter<3;miter++) 
//  {
//  je = tem(miter) ;
//  B1  =  inv(  (Xb.t()*Xb)) ;
//  beta1        = B1 * (  (Xb.t()*Yb.col(miter))) ;
//  rnd =  rnorm(3);
//  drw = beta1 + chol(B1)*rnd ;
//  bbeta.row(miter) = drw.t() ;
//  }   
//  
//  
//  //Updating Factor
//  mid  = diagmat(tem);
//  Yf     = (YY.t() - bbeta * inv(bbeta.t()* mid * bbeta) * bbeta.t()* mid * YY.t()).t();
//  //Yf     = (YY.t() - bbeta * inv(bbeta.t()* mid * bbeta) * bbeta.t()* mid * YY.t()).t() ;
//  alphaf.col(0) = aalpha.col(0) - bbeta * inv(bbeta.t() * mid * bbeta) * bbeta.t()*mid*aalpha.col(0);
//  alphaf.col(1) = aalpha.col(1) - bbeta * inv(bbeta.t() * mid * bbeta) * bbeta.t()*mid*aalpha.col(1);
//  
//  FF0 = cov(ff,ff)  - cov(ff,XX) * inv(cov(XX,XX)) * cov(XX,ff);
//  arma::mat FF0inv = inv(FF0);
//  arma::mat meanXX     = mean(XX).t(); // Note hard coded value
//  arma::mat meanff     = mean(ff).t(); // Note hard coded value
//  arma::mat F1         =  inv( FF0inv +  alphaf.t() * mid * alphaf);
//  arma::mat cholF1     = chol(F1) ;
//  arma::mat covXXinv = inv(cov(XX,XX));
//  for (m=0;m<N;m++) 
//  {
//  //Forming Priors (which use population level data so they update)
//  ff0 = meanff + cov(ff,XX) * covXXinv * (XX.row(m).t() - meanXX) ;
//  Yfsub = Yf.row(m);
//  f1  =  F1  * ( FF0inv*ff0 + alphaf.t() * mid * Yfsub.t());
//  rnd =  rnorm(2);
//  drw = f1 + cholF1 * rnd ;
//  ff.row(m) = drw.t() ;
//  }
//  
//  
//  
//  // Saving Output
//  if( (iter - Burnin)>=0 && iter%Thin==0)
//  {   
//  fill = (iter-Burnin)/Thin;
//  draws_sigma2.row(fill) = ssigma2.t();
//  arma::rowvec ac1 = aalpha.col(0).t();
//  arma::rowvec ac2 = aalpha.col(1).t();
//  arma::mat    ac  = join_rows(ac1,ac2);
//  draws_alpha.row(fill) = ac;
//  arma::rowvec bc1 = bbeta.col(0).t()  ;
//  arma::rowvec bc2 = bbeta.col(1).t() ;
//  arma::rowvec bc3 = bbeta.col(2).t() ;
//  arma::rowvec bct  = join_rows(bc1,bc2);
//  arma::mat bc4  = join_rows(bct,bc3);
//  draws_beta.row(fill) = bc4;
//  arma::rowvec fc1 = ff.col(0).t();
//  arma::rowvec fc2 = ff.col(1).t();
//  arma::mat    fc  = join_rows(fc1,fc2);
//  draws_f.row(fill) = fc;
//  }
//  if (iter % 100==0)
//  Rcpp::Rcout << "Iteration: " << iter << std::endl; 
//  }
//  
//  // Preparing output for return to R
//  Rcpp::GenericVector Out =
//  Rcpp::GenericVector::create(
//  Rcpp::Named("Alpha") = draws_alpha,
//  Rcpp::Named("Beta") = draws_beta,
//  Rcpp::Named("Sigma2") = draws_sigma2,
//  Rcpp::Named("factor") = draws_f);
//  
//  return wrap(Out);
//
//}