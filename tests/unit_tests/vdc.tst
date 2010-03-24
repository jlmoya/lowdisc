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
// Test the lowdisc_vdc library command
//
basis = 2;
next = lowdisc_vdc ( 0 , basis );
assert_close ( next , 0.0 , %eps );
next = lowdisc_vdc ( 1 , basis );
assert_close ( next , 0.5 , %eps );
next = lowdisc_vdc ( 2 , basis );
assert_close ( next , 0.25 , %eps );
next = lowdisc_vdc ( 3 , basis );
assert_close ( next , 0.75 , %eps );
next = lowdisc_vdc ( 4 , basis );
assert_close ( next , 0.125 , %eps );
next = lowdisc_vdc ( 5 , basis );
assert_close ( next , 0.625 , %eps );
//
// Check the Van Der Corput sequence
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","vandercorput");
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
expected = 0.5;
shift = norm(computed-expected)/norm(expected);
if shift > 1.e-6 then pause,end
// Terms #2 to #6
[rng,computed]=lowdisc_terms(rng,5);
expected= [...
    0.25 ;...
    0.75 ;...   
    0.125   ;...
    0.625   ;...
    0.375  ];
shift = norm(computed-expected)/norm(expected);
if shift > 1.e-6 then pause,end
rng = lowdisc_destroy(rng);
clear rng;

