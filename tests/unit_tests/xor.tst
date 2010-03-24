// Copyright (C) 2009 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


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
  if computed==expected then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction


//
// Check the bithi1 function
//
computed = [];
ilist =  [
      22      96     
      83      56     
      41       6      
      26      11      
       4      64      
       6      45      
      40      76     
      80       0     
      90      35     
       9       1       
];
expected =  [
  118
  107
  47
  17
  68
  43
  100
  80
  121
  8
];
for k = 1 : size ( ilist , "r" )
  i = ilist ( k , 1 );
  j = ilist ( k , 2 );
  computed ( $ + 1 ) = lowdisc_xor ( i , j );
end
assert_equal ( computed , expected );

