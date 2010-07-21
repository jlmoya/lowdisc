// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





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
  if ( and(expected==0.0) ) then
    shift = norm(computed-expected);
  else
    shift = norm(computed-expected)/norm(expected);
  end
  if ( shift < epsilon ) then
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
////////////////////////////////////////

//
// Generate more than 100 points from a LD sequence in dimension 4
callf = 100;
n = 4;
[ evalf , u ] = lowdisc_ldgen ( callf , n );
assert_equal ( evalf>=callf , %t );
assert_equal ( size(u) , [evalf n] );
assert_equal ( and(u>=0 & u<=1) , %t );

//
// Generate more than 100 points from a Halton sequence in dimension 4
callf = 100;
n = 4;
ldseq = "halton";
[ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq );
assert_equal ( evalf>=callf , %t );
assert_equal ( size(u) , [evalf n] );
assert_equal ( and(u>=0 & u<=1) , %t );

//
// Check strict
callf = 100;
n = 4;
ldseq = "halton";
strict = %t;
[ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq , strict );
assert_equal ( evalf , callf );
assert_equal ( size(u) , [evalf n] );
assert_equal ( and(u>=0 & u<=1) , %t );

//
// Check verbose
callf = 100;
n = 4;
ldseq = [];
strict = [];
verbose = %t;
[ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq , strict , verbose );
assert_equal ( evalf >= callf , %t );
assert_equal ( size(u) , [evalf n] );
assert_equal ( and(u>=0 & u<=1) , %t );

// Check all sequences
callf = 10;
n = 2;
strict = %f;
seqmat = lowdisc_methods ();
for ldseq = seqmat'
  mprintf("Checking sequence %s\n",ldseq)
  [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq , strict );
  assert_equal ( evalf >= callf , %t );
  assert_equal ( size(u) , [evalf n] );
  assert_equal ( and(u>=0 & u<=1) , %t );
end



