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


ldb = ldbase_new();
ldb
//
startedup = ldbase_get ( ldb , "-startedup" );
assert_equal ( startedup , %f );
//
ldb = ldbase_configure ( ldb , "-dimension" , 4 );
dimension = ldbase_cget ( ldb , "-dimension" );
assert_equal ( dimension , 4 );
//
verbose = ldbase_cget ( ldb , "-verbose" );
assert_equal ( verbose , %f );
//
ldb = ldbase_configure ( ldb , "-verbose" , %t );
verbose = ldbase_cget ( ldb , "-verbose" );
assert_equal ( verbose , %t );
//
skip = ldbase_cget ( ldb , "-skip" );
assert_equal ( skip , 0 );
//
ldb = ldbase_configure ( ldb , "-skip" , 10 );
skip = ldbase_cget ( ldb , "-skip" );
assert_equal ( skip , 10 );
//
leap = ldbase_cget ( ldb , "-leap" );
assert_equal ( leap , 0 );
//
ldb = ldbase_configure ( ldb , "-leap" , 10 );
leap = ldbase_cget ( ldb , "-leap" );
assert_equal ( leap , 10 );
//
ldb = ldbase_startup ( ldb );
//
startedup = ldbase_get ( ldb , "-startedup" );
assert_equal ( startedup , %t );
//
sequenceindex = ldbase_get ( ldb , "-index" );
assert_equal ( sequenceindex , 0 );
//
ldb = ldbase_incr ( ldb );
sequenceindex = ldbase_get ( ldb , "-index" );
assert_equal ( sequenceindex , 1 );
//
ldb = ldbase_indexset ( ldb , 10 );
sequenceindex = ldbase_get ( ldb , "-index" );
assert_equal ( sequenceindex , 10 );
//
ldb = ldbase_destroy ( ldb );

