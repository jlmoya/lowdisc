// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

//
// lowdisc_ridigits --
//   Returns the value of the 
//   radical inverse function with given digits.
//   The expected order is big endian.
// Arguments
//   digits : the digits of the number, as row vector
//   basis : the basis of the sequence
// Test : lowdisc_ridigits ( [0 0 1] , 2) -> 0.125
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

lowdisc_ridigits ( [0 0 1] , 2)

expected = 0.125

