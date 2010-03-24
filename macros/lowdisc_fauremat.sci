// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_fauremat --
//   Returns the Faure generator rxr matrix C(i).
// Arguments
//   r : the number of digits in the base-b expansion of k
//   i : the index of the coordinate of the point in the sequence,
//       with i= 1,d and d is the dimension
//   basis : the basis to use 
//     The binomial coefficients are computed modulo basis
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman
// Test : 
// faurematrix(3,2) = [1 2 4; 0 1 4; 0 0 1]
// faurematrix(2,1) = [1 1; 0 1]
// faurematrix(2,2) = [1 2; 0 1]
//
function c = lowdisc_fauremat ( r , i )
  for m = 1:r
    for n = 1:r
      if ( m <= n ) then
        c(m,n) = i^(n-m) * lowdisc_binomial ( n-1 , m-1 );
      end
    end
  end
endfunction


