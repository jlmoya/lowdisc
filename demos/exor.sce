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

//  _exor --
//    calculates the exclusive OR of two integers.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    31 March 2003
//
//  Author:
//
//   John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Reference:
//
//    Bennett Fox,
//    Algorithm 647:
//    Implementation and Relative Efficiency of Quasirandom 
//    Sequence Generators,
//    ACM Transactions on Mathematical Software,
//    Volume 12, Number 4, pages 362-376, 1986.
//
//  Parameters:
//
//    Input, integer I, J, two values whose exclusive OR is needed.
//
//    Output, integer K, the exclusive OR of I and J.
//
function k = lowdisc_exor ( i, j )
  k = 0;
  l = 1;
  i = floor ( i );
  j = floor ( j );
  while ( i ~= 0 | j ~= 0 )
//
//  Check the current right-hand bits of I and J.
//  If they differ, set the appropriate bit of K.
//
    i2 = floor ( i / 2 );
    j2 = floor ( j / 2 );
    if ( ...
      ( ( i == 2 * i2 ) & ( j ~= 2 * j2 ) ) | ...
      ( ( i ~= 2 * i2 ) & ( j == 2 * j2 ) ) )
      k = k + l;
    end
    i = i2;
    j = j2;
    l = 2 * l;
  end
endfunction

//
// Check the exor function
//
computed = []
ilist =  [
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
for k = 1 : size ( ilist , "r" )
  i = ilist ( k , 1 );
  j = ilist ( k , 2 );
  computed ( $ + 1 ) = lowdisc_exor ( i , j );
end
assert_equal ( computed , expected );

//
// Load this script into the editor
//
filename = "exor.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

