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
// lowdisc_rem --
//  Remainder after division.
//
function r = lowdisc_rem ( X , Y )
  r = X - fix ( X ./ Y ) .* Y
endfunction


//
// Check the rem function
//
computed = lowdisc_rem ( 0 , 2 );
expected = 0;
assert_close ( computed, expected , %eps );
computed = lowdisc_rem ( 1 , 2 );
expected = 1;
assert_close ( computed, expected , %eps );
computed = lowdisc_rem ( 2 , 2 );
expected = 0;
assert_close ( computed, expected , %eps );
computed = lowdisc_rem ( 3 , 2 );
expected = 1;
assert_close ( computed, expected , %eps );
computed = lowdisc_rem ( 4 , 2 );
expected = 0;
assert_close ( computed, expected , %eps );
computed = lowdisc_rem ( -1 , 2 );
expected = -1;
assert_close ( computed, expected , %eps );
computed = lowdisc_rem ( -2 , 2 );
expected = 0;
assert_close ( computed, expected , %eps );
computed = lowdisc_rem ( -3 , 2 );
expected = -1;
assert_close ( computed, expected , %eps );

//
// Load this script into the editor
//
filename = "divisionrem.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

