// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
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
// _bithi1 --
//   I4_BIT_HI1 returns the position of the high 1 bit base 2 in an integer.
//
//  Example:
//
//       N    Binary     BIT
//    ----    --------  ----
//       0           0     0
//       1           1     1
//       2          10     2
//       3          11     2 
//       4         100     3
//       5         101     3
//       6         110     3
//       7         111     3
//       8        1000     4
//       9        1001     4
//      10        1010     4
//      11        1011     4
//      12        1100     4
//      13        1101     4
//      14        1110     4
//      15        1111     4
//      16       10000     5
//      17       10001     5
//    1023  1111111111    10
//    1024 10000000000    11
//    1025 10000000001    11
//
//  ilist =  [
//        22      96     
//        83      56     
//        41       6      
//        26      11      
//         4      64      
//         6      45      
//        40      76     
//        80       0     
//        90      35     
//         9       1       
//  ];
//  expected =  [
//    118
//    107
//    47
//    17
//    68
//    43
//    100
//    80
//    121
//    8
//  ];
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    16 February 2005
//
//  Author:
//
//    John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Parameters:
//
//    Input, integer N, the integer to be measured.
//    N should be nonnegative.  If N is nonpositive, the value will always be 0.
//
//    Output, integer BIT, the number of bits base 2.
//
function bit = _bithi1 ( n )
  i = floor ( n );
  bit = 0;
  while ( 1 )
    if ( i <= 0 )
      break;
    end
    bit = bit + 1;
    i = floor ( i / 2 );
  end
endfunction

//
// Check the bithi1 function
//
computed = [];
ilist =  [
    22      
    96      
    83     
    56      
    41     
     6     
    26      
    11     
     4     
    64     
];
expected =  [
  5
  7
  7
  6
  6
  3
  5
  4
  3
  7
];
for i = 1:size(ilist,"*")
  j = ilist(i);
  computed ( $ + 1 ) = lowdisc_bithi1 (j );
end
assert_equal ( computed , expected );

