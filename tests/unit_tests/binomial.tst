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
  if ( and ( computed==expected ) ) then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction
//
// Test the lowdisc_binomial library command
//
// Check that integer inputs produce integer output
c = lowdisc_binomial ( 4 , 1 );
assert_equal ( c , 4 );
c = lowdisc_binomial ( 5 , 0 );
assert_equal ( c , 1  );
c = lowdisc_binomial ( 5 , 1 );
assert_equal ( c , 5  );
c = lowdisc_binomial ( 5 , 2 );
assert_equal ( c , 10  );
c = lowdisc_binomial ( 5 , 3 );
assert_equal ( c , 10  );
c = lowdisc_binomial ( 5 , 4 );
assert_equal ( c , 5  );
c = lowdisc_binomial ( 5 , 5 );
assert_equal ( c , 1  );
c = lowdisc_binomial ( 17 , 18 );
assert_equal ( c , 0  );
c = lowdisc_binomial ( 17 , -1 );
assert_equal ( c , 0  );
// Real (i.e. floating point) inputs
c = lowdisc_binomial ( 1.5 , 0.5 );
assert_close ( c , 1.5 , 10 * %eps );
c = lowdisc_binomial ( 10000 , 134 );
assert_close ( c , 2.050083865024873735e307 , 10 * %eps );

