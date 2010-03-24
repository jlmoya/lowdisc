// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_ridigits --
//   Returns the value of the 
//   radical inverse function with given digits.
//   The expected order is big endian.
// Arguments
//   digits : the digits of the number, as row vector
//   basis : the basis of the sequence
// Test : radicalinverse_digits ( [0 0 1] , 2) -> 0.125
//
function phi = lowdisc_ridigits ( digits , basis )
  ib = 1.0 / basis
  phi = 0.0
  r = size(digits,2)
  for j = 1:r
    phi = phi + digits(j) * ib
    ib = ib / basis
  end
endfunction

