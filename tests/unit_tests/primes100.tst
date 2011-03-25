// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
prarray = lowdisc_primes100 ( );
prsize = size(prarray);
assert_checkequal ( prsize , [1 100] );
expected10 = [2      3      5      7     11     13     17     19     23     29];
assert_checkequal ( prarray(1:10) , expected10 );


