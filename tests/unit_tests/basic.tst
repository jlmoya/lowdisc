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
// Check the configure/cget methods.
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-dimension",12);
nbdim = lowdisc_cget(rng,"-dimension");
assert_equal ( nbdim , 12 );
i = lowdisc_cget(rng,"-sequenceindex");
assert_equal ( i , 0 );
verbose = lowdisc_cget(rng,"-verbose");
assert_equal ( verbose , 0 );
// Exercize cget but do not check the result (which are default values)
seed = lowdisc_cget(rng,"-seed");
seedmethod = lowdisc_cget(rng,"-seedmethod");

// Exercize configure, but do not check the result
rng = lowdisc_configure(rng,"-vandercorputbasis",3);
rng = lowdisc_configure(rng,"-primeslist",[2 3 5]);
lowdisc_display (rng);
rng = lowdisc_destroy(rng);
clear rng;

