// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
function r = lowdisc_corrcoef ( x )
  // Correlation coefficients
  //
  // Calling Sequence
  // r = lowdisc_corrcoef ( x )
  //
  // Description
  // Returns a matrix r of correlation coefficients calculated from an input matrix X whose rows are observations and whose columns are variables. 
  // The matrix r = corrcoef(x) is related to the covariance matrix c = cov(X) by
  // r(i,j) = c(i,j) / sqrt(c(i,i) * c(j,j)).
  //
  // The cov function comes from Stixbox.
  //
  // TODO : return p-values
  //
  // Examples
  // // Uncorrelated data
  // x = grand(30,4,"nor",0,1)
  // // Introduce correlation.
  // x(:,4) = sum(x,2);
  // // Compute sample correlation
  // r = lowdisc_corrcoef ( x )
  //
  // Authors
  //   2010 - DIGITEO - Michael Baudin
  
  c = cov(x)
  r = c ./ sqrt(diag(c) * diag(c)')
endfunction


