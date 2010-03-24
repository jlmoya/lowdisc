// Copyright (C) 2008-2009 - INRIA - Michael Baudin
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
      c(i,j) = lowdisc_binomial (m,k);
    end
  end
endfunction

