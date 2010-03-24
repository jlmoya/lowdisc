// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

// 
// lowdisc_binomialmod --
//   Returns the binomial number (n,k) modulo m, i.e.
//   the number of k-element subsets of an n-element set.
//   It is defined by n!/(k! (n-k)!
//   and can be computed as 
//
//   n (n-1) ... (n-k+1)
//   -------------------
//   k (k-1) ... 1
//
//   =
//
//   n (n-1) ... (n-k+1)
//   -------------------
//   1 2 ... (k-1) k
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
//
function b = lowdisc_binomialmod ( n , k , m )
  if ( ( k < 0 ) | ( k > n ) ) then 
    b = 0
  else
    b = 1
    for i = 1 : k
      b = modulo ( b * (n - i + 1) / (k - i + 1) , m )
    end
  end
  // If the input where integers, returns also an integer.
  if ( and(round(n)==n) & and(round(k)==k) ) then
    b = round ( b )
  end
endfunction

