// Copyright (C) 2010-2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Generate more than 100 points from a LD sequence in dimension 4
callf = 100;
n = 4;
[ u , evalf ] = lowdisc_ldgen ( callf , n );
assert_checkequal ( evalf>=callf , %t );
assert_checkequal ( size(u) , [evalf n] );
assert_checkequal ( and(u>=0 & u<=1) , %t );

//
// Generate more than 100 points from a Halton sequence in dimension 4
callf = 100;
n = 4;
ldseq = "halton";
[ u , evalf ] = lowdisc_ldgen ( callf , n , ldseq );
assert_checkequal ( evalf>=callf , %t );
assert_checkequal ( size(u) , [evalf n] );
assert_checkequal ( and(u>=0 & u<=1) , %t );

//
// Check strict
callf = 100;
n = 4;
ldseq = "halton";
strict = %t;
[ u , evalf ] = lowdisc_ldgen ( callf , n , ldseq , strict );
assert_checkequal ( evalf , callf );
assert_checkequal ( size(u) , [evalf n] );
assert_checkequal ( and(u>=0 & u<=1) , %t );

// Check all sequences in dimensions 10
callf = 10;
n = 2;
seqmat = lowdisc_methods ();
for ldseq = seqmat'
  mprintf("Checking sequence %s - strict true\n",ldseq)
  [ u , evalf ] = lowdisc_ldgen ( callf , n , ldseq , %t );
  assert_checkequal ( evalf >= callf , %t );
  assert_checkequal ( size(u) , [evalf n] );
  assert_checkequal ( and(u>=0 & u<=1) , %t );
  mprintf("Checking sequence %s - strict false\n",ldseq)
  [ u , evalf ] = lowdisc_ldgen ( callf , n , ldseq , %f );
  assert_checkequal ( evalf >= callf , %t );
  assert_checkequal ( size(u) , [evalf n] );
  assert_checkequal ( and(u>=0 & u<=1) , %t );
end
