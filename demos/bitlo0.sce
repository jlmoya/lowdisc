// Copyright (C) 2008 - INRIA - Michael Baudin
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
// _bitlo0 --
//   I4_BIT_LO0 returns the position of the low 0 bit base 2 in an integer.
//
//  Example:
//
//       N    Binary     BIT
//    ----    --------  ----
//       0           0     1
//       1           1     2
//       2          10     1
//       3          11     3 
//       4         100     1
//       5         101     2
//       6         110     1
//       7         111     4
//       8        1000     1
//       9        1001     2
//      10        1010     1
//      11        1011     3
//      12        1100     1
//      13        1101     2
//      14        1110     1
//      15        1111     5
//      16       10000     1
//      17       10001     2
//    1023  1111111111     1
//    1024 10000000000     1
//    1025 10000000001     1
//
//  Licensing:
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//    16 February 2005
//
//  Author:
//    John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Parameters:
//    Input, integer N, the integer to be measured.
//    N should be nonnegative.
//
//    Output, integer BIT, the position of the low 1 bit.
//
function bit = lowdisc_bitlo0 ( n )
  bit = 0;
  i = floor ( n );
  while ( 1 )
    bit = bit + 1;
    i2 = floor ( i / 2 );
    if ( i == 2 * i2 )
      break;
    end
    i = i2;
  end
endfunction


//
// Check the bitlo0 function
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
]
expected =  [
  1
  1
  3
  1
  2
  1
  1
  3
  1
  1
];
for i = 1:size(ilist,"*")
  j = ilist(i);
  computed($+1) = lowdisc_bitlo0 ( j );
end
assert_equal ( computed , expected );

//
// Load this script into the editor
//
filename = "bitlo0.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

