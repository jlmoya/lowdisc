// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010-2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// Check all sequences in dimension 2
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

