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
// Test the lowdisc_radicalinv library command
//
basis = 2;
phi = lowdisc_radicalinv ( 4 , basis );
assert_close ( phi , 0.125 , %eps );

