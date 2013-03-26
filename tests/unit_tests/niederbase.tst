// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// This is from :
//    "Low-discrepancy and low-dispersion sequences",
//    Harald Niederreiter, Journal of Number Theory,
//    Volume 30, Issue 1, September 1988, Pages 51-70
// p. 63, table I
// Only some values are tested.
//
base = lowdisc_niederbase ( 1 );
assert_checkequal ( base , 2 );
//
base = lowdisc_niederbase ( 2 );
assert_checkequal ( base , 2 );
//
base = lowdisc_niederbase ( 3 );
assert_checkequal ( base , 3 );
//
base = lowdisc_niederbase ( 6 );
assert_checkequal ( base , 7 );
//
base = lowdisc_niederbase ( 12 );
assert_checkequal ( base , 13 );
//
base = lowdisc_niederbase ( 13 );
assert_checkequal ( base , 2 );
//
// Use optimal base in dimension 4
//
dim = 4;
base = lowdisc_niederbase ( dim );
lds = lowdisc_new("niederreiter");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-base",base);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);


