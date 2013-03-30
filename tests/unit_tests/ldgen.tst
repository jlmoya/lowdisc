// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010-2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Generate more than 100 points from a LD sequence in dimension 4
callf = 100;
n = 4;
u=lowdisc_ldgen ( callf , n );
assert_checkequal ( size(u),[callf,4]);
assert_checkequal ( and(u>=0 & u<=1) , %t );

//
// Generate more than 100 points from a Halton sequence in dimension 4
callf = 100;
n = 4;
ldseq = "halton";
u=lowdisc_ldgen ( callf , n , ldseq );
assert_checkequal ( size(u),[callf,4]);
assert_checkequal ( and(u>=0 & u<=1) , %t );

