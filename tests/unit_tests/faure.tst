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
// Test the lowdisc_faure library command
//
basis = 3;
dimension = 3;
vk = lowdisc_faure ( 4 , basis , dimension );
if ( %f ) then
assert_close ( vk , [4/9 7/9 1/9] , %eps );
//
// Check the Faure sequence in dimension 3
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","faure");
rng = lowdisc_configure(rng,"-dimension",3);
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
expected = [1/3 1/3 1/3];
assert_close ( computed, expected, %eps );
// Terms #2 to #6
[rng,computed]=lowdisc_next(rng,7);
expected= [
    2/3 2/3 2/3 
    1/9 4/9 7/9 
    4/9 7/9 1/9 
    7/9 1/9 4/9 
    2/9 8/9 5/9 
    5/9 2/9 8/9 
    8/9 5/9 2/9
];
assert_close ( computed, expected, %eps );
rng = lowdisc_destroy(rng);
clear rng;
end
