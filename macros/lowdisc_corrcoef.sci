// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
function r = lowdisc_corrcoef ( x )
  // Correlation coefficients
  //
  // Calling Sequence
  // r = lowdisc_corrcoef ( x )
  //
  // Parameters
  //   x : a m-by-n matrix of doubles, the data. <literal>m</literal> is the number of observations. <literal>n</literal> is the number of variables.
  //   r : a n-by-n matrix of doubles, the correlation coefficient.
  //
  // Description
  // Returns the matrix <literal>r</literal> of correlation coefficients calculated from an 
  // input matrix <literal>x</literal>. 
  // The matrix <literal>r</literal> is related to the covariance matrix <literal>c=cov(x)</literal> by
  //
  // <literal>r(i,j) = c(i,j) / sqrt(c(i,i) * c(j,j)).</literal>
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
  //   2010 - 2011 - DIGITEO - Michael Baudin
  
  c = cov(x)
  r = c ./ sqrt(diag(c) * diag(c)')
endfunction


