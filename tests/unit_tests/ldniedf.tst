// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

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
  if ( and ( computed==expected ) ) then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction

//
// Check the Fast Niederreiter sequence 
// Use base 2 - this is the default.
//
lds = ldniedf_new();
lds = ldniedf_configure(lds,"-dimension",4);
lds = ldniedf_startup (lds);
// Term #1
[lds,computed] = ldniedf_next (lds);
expected = [0.500000      0.500000      0.750000      0.875000];
assert_close ( computed, expected , 10 * %eps );
// Terms #2 to #9
[lds,computed]=ldniedf_next(lds,8);
expected= [...
  0.250000      0.750000      0.562500      0.765625
  0.750000      0.250000      0.312500      0.140625
  0.125000      0.625000      0.437500      0.546875
  0.625000      0.125000      0.687500      0.421875
  0.375000      0.375000      0.875000      0.281250
  0.875000      0.875000      0.125000      0.656250
  0.062500      0.937500      0.953125      0.234375
  0.562500      0.437500      0.203125      0.859375
];
assert_close ( computed, expected , 1.e-4 );
lds = ldniedf_destroy(lds);


