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

// This is from :
//    "Low-discrepancy and low-dispersion sequences",
//    Harald Niederreiter, Journal of Number Theory,
//    Volume 30, Issue 1, September 1988, Pages 51-70
// p. 63, table I
// Only some values are tested.
//
base = lowdisc_niederbase ( 1 );
assert_equal ( base , 2 );
//
base = lowdisc_niederbase ( 2 );
assert_equal ( base , 2 );
//
base = lowdisc_niederbase ( 3 );
assert_equal ( base , 3 );
//
base = lowdisc_niederbase ( 6 );
assert_equal ( base , 7 );
//
base = lowdisc_niederbase ( 12 );
assert_equal ( base , 13 );
//
base = lowdisc_niederbase ( 13 );
assert_equal ( base , 2 );
//
// Use optimal base in dimension 4
//
dim = 4;
base = lowdisc_niederbase ( dim );
lds = lowdisc_new("niederreiterf");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-base",base);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);


