// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_faure --
//   Returns the vector of index #k in dimension d of the
//   Faure sequence of base b.
// Arguments
//   k : the index of the point in the sequence
//   b : the basis
//   dimension : the dimension of the space
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman
// Test : fauresequence ( 4 , 3 , 3 ) = [4/9 7/9 1/9]
// Caution !
//   This implementation is not protected against overflow.
//   Practically, we did not experience any problem with 
//   that specific issue.
//   If that point was being an issue, we could use
//   as in TOMS 647, the Faure matrix modulo the basis.
//   To do this, it suffices to pass the basis to the fauremat
//   function and to use binomialmod instead of binomial.
//
function v = lowdisc_faure ( k , basis , dimension )
  digits = lowdisc_bary ( k , basis , "bigendian" )
  digits = digits'
  r = size ( digits , 1 )
  // Compute a vector made of 1/b, 1/b^2, etc...
  ib = 1.0/basis
  for i = 1:r
    bpwrs(i) = ib
    ib = ib / basis
  end
  // Compute the element #i in the sequence
  for idim = 1 : dimension
    ci = lowdisc_fauremat ( r , idim - 1 )
    y = ci * digits
    ymodb = modulo ( y , basis )
    // Compute the component #idim of sequence
    v(1,idim) = ymodb' * bpwrs
  end
endfunction


