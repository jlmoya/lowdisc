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
// Check the Fast Faure sequence in dimension 3
//
lds = ldfauref_new();
lds = ldfauref_configure(lds,"-dimension",3);
lds = ldfauref_startup (lds);
// Term #1
[lds,computed] = ldfauref_next (lds);
expected = [1/3 1/3 1/3];
assert_close ( computed, expected, %eps );
// Terms #2 to #6
[lds,computed]=ldfauref_next(lds,7);
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
lds = ldfauref_destroy(lds);


