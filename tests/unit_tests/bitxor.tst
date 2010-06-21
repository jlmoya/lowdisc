// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.


// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

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
// Check the exor function
//
computed = []
x12mat =  [
    86     19     
    90     31     
    32     48     
     4     22     
    41     36     
    55     71    
    77     77      
    37     57     
   100      8    
    99     76     
];
expected =  [
  69
  69
  16
  18
  13
  112
  0
  28
  108
  47
];
for k = 1 : size ( x12mat , "r" )
  i = x12mat ( k , 1 );
  j = x12mat ( k , 2 );
  computed ( $ + 1 ) = lowdisc_bitxor ( i , j );
end
assert_equal ( computed , expected );
//
// Check that it is correctly vectorized.
computed = lowdisc_bitxor ( x12mat(:,1) , x12mat(:,2) );
assert_equal ( computed , expected );

