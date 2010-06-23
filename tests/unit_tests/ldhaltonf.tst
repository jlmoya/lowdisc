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
// Check the Fast Halton sequence in dimension 2
//
lds = ldhaltonf_new();
lds = ldhaltonf_configure(lds,"-dimension",2);
lds = ldhaltonf_startup (lds);
// Term #1
[lds,computed] = ldhaltonf_next (lds);
expected = [0.5 1./3.];
assert_close ( computed, expected, 10 * %eps );
// Terms #2 to #6
[lds,computed]=ldhaltonf_next(lds,5);
expected= [
    1./4. 2./3. 
    3./4. 1./9.    
    1./8. 4./9. 
    5./8. 7./9. 
    3./8. 2./9. 
];
assert_close ( computed, expected, 10 * %eps );
lds = ldhaltonf_destroy(lds);


