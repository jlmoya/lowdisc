// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_radicalinv --
//   Returns the value of the 
//   radical inverse function.
//   The scrambling is based on the call of a
//   permutation function.
// Arguments
//   i : the index of the item in the sequence.
//   basis : the basis of the sequence
// Test : radicalinverse ( 4 , 2 ) -> 0.125
//
function phi = lowdisc_radicalinv ( i , basis )
  current = i
  ib = 1.0 / basis
  phi = 0.0
  while ( current > 0 )
    digit = modulo ( current , basis )
    current = int ( current / basis )
    phi = phi + digit * ib
    ib = ib / basis
  end
endfunction

