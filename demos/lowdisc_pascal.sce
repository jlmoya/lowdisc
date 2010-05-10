// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

// 
// lowdisc_pascal --
//   Returns the Pascal matrix number n
//                    
// References
//   http://en.wikipedia.org/wiki/Pascal_matrix
//
function c = lowdisc_pascal (n)
  c = zeros(n,n);
  for i = 1:n
    for j = 1:n
      m = i+j-2;
      k = i-1;
      c(i,j) = _binomial (m,k);
    end
  end
endfunction

// 
// _binomial --
//   Returns the binomial number (n,k), i.e.
//   the number of k-element subsets of an n-element set.
//   It is defined by n!/(k! (n-k)!
//   and can be computed as 
//
//   n (n-1) ... (n-k+1)
//   -------------------
//   k (k-1) ... 1
//                    
// References
//   http://en.wikipedia.org/wiki/Binomial_coefficients
//   http://wiki.tcl.tk/1755
//
// Note about floating point accuracy
//   factorial(170) ~ 7.e306
//   So n=170 is the greatest integer for which
//   n! can be computed.
//   If the naive formula 
//
//   b = factorial(n)/factorial(k)/factorial(n-k);
//
//   was used, the maximum value n for which 
//   the binomial can be computed is n = 170.
//   But binomial(171,1) = 1, so there is no reason
//   to prevent the computation of 1 because an intermediate
//   result is > 1.e308.
//   This is why the gammaln function is used instead.
// Note about rounding for integer inputs
//   If n = 4 and k = 1, the gammaln and exp functions 
//   are accurate only to 1ulp. This leads to the 
//   result that b = 3.99...99998.
//   It is the result of the fact that we use the elementary 
//   functions exp and gammaln.
//   This is very close to 4, but is not equal to 4.
//   Assume that you know compute c = b (mod 4) and you 
//   get c = b = 3.99...99998, intead of getting c  = 4.
//   This is why, when input arguments are integers,
//   the result is rounded to the nearest integer.
//
function b = _binomial ( n , k )
  if ( ( k < 0 ) | ( k > n ) ) then 
    b = 0
  else
    r = gammaln ( n + 1 ) - gammaln (k + 1) - gammaln (n - k + 1)
    b = exp( r );
  end
  // If the input where integers, returns also an integer.
  if ( and(round(n)==n) & and(round(k)==k) ) then
    b = round ( b )
  end
endfunction

computed = lowdisc_pascal ( 5 )
expected = [
  1 1 1 1 1
  1 2 3 4 5
  1 3 6 10 15
  1 4 10 20 35
  1 5 15 35 70
]

