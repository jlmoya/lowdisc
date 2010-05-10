// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

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
// c = lowdisc_binomial ( 4 , 1 ) // 4
// c = lowdisc_binomial ( 5 , 0 ) // 1
// c = lowdisc_binomial ( 5 , 1 ) // 5
// c = lowdisc_binomial ( 5 , 2 ) // 10
// c = lowdisc_binomial ( 5 , 3 ) // 10
// c = lowdisc_binomial ( 5 , 4 ) // 5
// c = lowdisc_binomial ( 5 , 5 ) // 1
// c = lowdisc_binomial ( 17 , 18 ) // 0
// c = lowdisc_binomial ( 17 , -1 ) // 0
// c = lowdisc_binomial ( 1.5 , 0.5 ) // 1.5
// c = lowdisc_binomial ( 10000 , 134 ) // 2.050083865024873735e307
//
function b = lowdisc_binomial ( n , k )
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
//
// assert_close --
//   Returns 1 if the two real matrices computed and expected are close,
//   i.e. if the relative distance between computed and expected is lesser than epsilon.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_close ( computed, expected, epsilon )
  if expected==0.0 then
    shift = norm(computed-expected);
  else
    shift = norm(computed-expected)/norm(expected);
  end
  if shift < epsilon then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction
//
// assert_equal --
//   Returns 1 if the two real matrices computed and expected are equal.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_equal ( computed , expected )
  if ( and ( computed==expected ) ) then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction

//
// Test the lowdisc_binomial library command
//
// Check that integer inputs produce integer output
c = lowdisc_binomial ( 4 , 1 );
assert_equal ( c , 4 );
c = lowdisc_binomial ( 5 , 0 );
assert_equal ( c , 1  );
c = lowdisc_binomial ( 5 , 1 );
assert_equal ( c , 5  );
c = lowdisc_binomial ( 5 , 2 );
assert_equal ( c , 10  );
c = lowdisc_binomial ( 5 , 3 );
assert_equal ( c , 10  );
c = lowdisc_binomial ( 5 , 4 );
assert_equal ( c , 5  );
c = lowdisc_binomial ( 5 , 5 );
assert_equal ( c , 1  );
c = lowdisc_binomial ( 17 , 18 );
assert_equal ( c , 0  );
c = lowdisc_binomial ( 17 , -1 );
assert_equal ( c , 0  );
// Real (i.e. floating point) inputs
c = lowdisc_binomial ( 1.5 , 0.5 );
assert_close ( c , 1.5 , 10 * %eps );
c = lowdisc_binomial ( 10000 , 134 );
assert_close ( c , 2.050083865024873735e307 , 1.e5 * %eps );

